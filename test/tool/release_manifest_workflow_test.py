import os
import plistlib
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[2]
CHECKOUT = "actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1"
ATTEST = "actions/attest-build-provenance@977bb373ede98d70efdf65b84cb5f73e068dcc2a"
ANDROID = yaml.safe_load((ROOT / ".github/workflows/beta-release.yml").read_text(encoding="utf-8"))
IOS = yaml.safe_load((ROOT / ".github/workflows/shorebird-release.yml").read_text(encoding="utf-8"))


def step(workflow, job, name):
    return next(item for item in workflow["jobs"][job]["steps"] if item.get("name") == name)


class ReleaseManifestWorkflowTest(unittest.TestCase):
    def assert_order(self, workflow, job, names):
        steps = workflow["jobs"][job]["steps"]
        positions = [steps.index(step(workflow, job, name)) for name in names]
        self.assertEqual(positions, sorted(positions))
        for name in names:
            item = step(workflow, job, name)
            self.assertNotIn("continue-on-error", item)
            self.assertNotIn("if", item)

    def test_android_records_real_release_source_after_successful_build(self):
        self.assert_order(ANDROID, "android", [
            "Configure university", "Release Android beta", "Collect artifacts",
            "Record Android release manifest", "Upload Android artifacts",
        ])
        manifest = step(ANDROID, "android", "Record Android release manifest")
        self.assertEqual(manifest["env"]["RELEASE_SHA"], "${{ needs.prepare.outputs.release_sha }}")
        self.assertEqual(manifest["env"]["RELEASE_VERSION"], "${{ needs.prepare.outputs.release_version }}")
        self.assertIn('--source-sha "$RELEASE_SHA"', manifest["run"])
        self.assertIn('--release-version "$RELEASE_VERSION"', manifest["run"])
        self.assertIn("--platform android", manifest["run"])
        self.assertIn("--artifact-dir dist", manifest["run"])
        self.assertIn("--output dist/release-manifest.json", manifest["run"])
        self.assertEqual(ANDROID["jobs"]["android"]["env"]["SHOREBIRD_TOKEN"], "${{ secrets.SHOREBIRD_TOKEN }}")
        checkout = step(ANDROID, "android", "Check out repository")
        self.assertEqual(checkout["with"]["ref"], manifest["env"]["RELEASE_SHA"])

    def test_android_tooling_is_pinned_to_workflow_even_for_older_release_source(self):
        checkout = step(ANDROID, "android", "Check out release tooling")
        self.assertEqual(checkout["uses"], CHECKOUT)
        self.assertEqual(checkout["with"]["ref"], "${{ github.workflow_sha }}")
        self.assertEqual(checkout["with"]["path"], ".release-tools")
        self.assertFalse(checkout["with"]["persist-credentials"])
        self.assertIn("python3 .release-tools/tool/release_manifest.py create", step(
            ANDROID, "android", "Record Android release manifest")["run"])
        publish_checkout = step(ANDROID, "publish", "Check out release tooling")
        self.assertEqual(publish_checkout["with"]["ref"], "${{ github.workflow_sha }}")
        self.assertFalse(publish_checkout["with"]["persist-credentials"])
        nfc = step(ANDROID, "android", "Check out private NFC module")["with"]
        self.assertRegex(nfc["ref"], r"^[0-9a-f]{40}$")
        self.assertEqual(nfc["path"], "android/private/nfc-pass-android")

    def test_ios_records_completed_artifact_version_and_current_source(self):
        self.assert_order(IOS, "release", [
            "Configure university", "Release iOS", "Encrypt release symbols",
            "Collect iOS release artifacts", "Record iOS release manifest",
            "Attest iOS artifacts", "Attest release manifest",
            "Upload iOS artifact", "Publish release manifest",
        ])
        manifest = step(IOS, "release", "Record iOS release manifest")
        self.assertEqual(manifest["env"]["RELEASE_VERSION"], "${{ steps.artifacts.outputs.release_version }}")
        self.assertEqual(manifest["env"]["SHOREBIRD_TOKEN"], "${{ secrets.SHOREBIRD_TOKEN }}")
        self.assertIn('--source-sha "$(git rev-parse HEAD)"', manifest["run"])
        self.assertIn("--platform ios", manifest["run"])
        self.assertIn("--artifact-dir dist", manifest["run"])
        self.assertIn("--output dist/release-manifest.json", manifest["run"])

    def test_manifests_are_attested_before_durable_publication_with_scoped_permissions(self):
        for workflow, job in ((ANDROID, "publish"), (IOS, "release")):
            with self.subTest(job=job):
                self.assert_order(workflow, job, ["Attest release manifest", "Publish release manifest"])
                attestation = step(workflow, job, "Attest release manifest")
                self.assertEqual(attestation["uses"], ATTEST)
                self.assertEqual(attestation["with"]["subject-path"], "dist/release-manifest.json")
                for scope in ("contents", "id-token", "attestations"):
                    self.assertEqual(workflow["jobs"][job]["permissions"][scope], "write")
                publish = step(workflow, job, "Publish release manifest")
                self.assertEqual(publish["env"]["GH_TOKEN"], "${{ github.token }}")
                self.assertIn("python3 tool/release_manifest.py publish", publish["run"])
                self.assertIn("--manifest dist/release-manifest.json", publish["run"])
                self.assertIn("--artifacts-dir dist", publish["run"])
                self.assertNotIn("--clobber", publish["run"])
                self.assertEqual(workflow["permissions"]["contents"], "read")
        self.assertEqual(step(ANDROID, "publish", "Attest artifacts")["uses"], ATTEST)
        self.assertEqual(step(IOS, "release", "Attest iOS artifacts")["uses"], ATTEST)

    def test_android_download_and_attestation_precede_both_publications(self):
        self.assertEqual(ANDROID["jobs"]["publish"]["needs"], ["prepare", "android"])
        self.assert_order(ANDROID, "publish", [
            "Check out release tooling", "Download artifacts", "Attest artifacts",
            "Attest release manifest", "Publish release manifest", "Publish GitHub prerelease",
        ])
        download = step(ANDROID, "publish", "Download artifacts")["with"]
        upload = step(ANDROID, "android", "Upload Android artifacts")["with"]
        self.assertEqual(download["name"], upload["name"])
        self.assertEqual(upload["path"], "dist/")
        self.assertEqual(download["path"], "dist")
        self.assertEqual(step(IOS, "release", "Upload iOS artifact")["with"]["path"], "dist/")
        for workflow, job, name in ((ANDROID, "android", "Upload Android artifacts"),
                                    (IOS, "release", "Upload iOS artifact")):
            self.assertEqual(step(workflow, job, name)["with"]["if-no-files-found"], "error")


class IosReleaseArtifactCollectionTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        (self.root / "build/ios/ipa").mkdir(parents=True)
        (self.root / "ios").mkdir()
        (self.root / "ios/Podfile.lock").write_bytes(b"PODS: resolved fixture\n")
        (self.root / "build/release-symbols").mkdir()
        (self.root / "build/release-symbols/ios-release-symbols.cms").write_bytes(b"encrypted fixture")
        self.metadata = {
            "CFBundleIdentifier": "pro.oniel.it.university",
            "CFBundleShortVersionString": "5.2.1",
            "CFBundleVersion": "2440.17.53",
        }
        self.write_ipa()

    def write_ipa(self, filename="university.ipa", additional_metadata=False):
        with zipfile.ZipFile(self.root / "build/ios/ipa" / filename, "w") as archive:
            archive.writestr("Payload/Runner.app/Info.plist", plistlib.dumps(self.metadata))
            archive.writestr("Payload/Runner.app/PlugIns/Home.app/Info.plist", b"nested ignored")
            if additional_metadata:
                archive.writestr("Payload/Other.app/Info.plist", plistlib.dumps(self.metadata))

    def collect(self):
        script = step(IOS, "release", "Collect iOS release artifacts")["run"]
        python = script.split("python3 - <<'PY'\n", 1)[1].rsplit("\nPY", 1)[0]
        return subprocess.run(
            [sys.executable, "-c", python], cwd=self.root,
            env={**os.environ, "IOS_APP_BUNDLE_ID": "pro.oniel.it.university",
                 "GITHUB_OUTPUT": str(self.root / "outputs")},
            capture_output=True, text=True, check=False,
        )

    def test_collects_exact_binary_symbols_lock_and_artifact_version(self):
        result = self.collect()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.root / "outputs").read_text(), "release_version=5.2.1+2440.17.53\n")
        self.assertEqual({path.name for path in (self.root / "dist").iterdir()},
                         {"university.ipa", "ios-release-symbols.cms", "Podfile.lock"})
        self.assertEqual((self.root / "dist/Podfile.lock").read_bytes(),
                         (self.root / "ios/Podfile.lock").read_bytes())
        self.assertEqual((self.root / "dist/university.ipa").read_bytes(),
                         (self.root / "build/ios/ipa/university.ipa").read_bytes())

    def test_rejects_multiple_binaries_without_recording_version(self):
        self.write_ipa("other.ipa")
        self.assertNotEqual(self.collect().returncode, 0)
        self.assertFalse((self.root / "outputs").exists())

    def test_rejects_ambiguous_app_metadata(self):
        self.write_ipa(additional_metadata=True)
        self.assertNotEqual(self.collect().returncode, 0)
        self.assertFalse((self.root / "outputs").exists())

    def test_requires_resolved_pod_lock_and_encrypted_symbols(self):
        for name in ("ios/Podfile.lock", "build/release-symbols/ios-release-symbols.cms"):
            with self.subTest(name=name):
                path = self.root / name
                original = path.read_bytes()
                path.write_bytes(b"")
                self.assertNotEqual(self.collect().returncode, 0)
                self.assertFalse((self.root / "outputs").exists())
                path.write_bytes(original)

    def test_rejects_wrong_bundle_and_invalid_versions(self):
        for key, value in (("CFBundleIdentifier", "other.app"),
                           ("CFBundleShortVersionString", "5.2.1\ninjected=value"),
                           ("CFBundleVersion", "1005801")):
            with self.subTest(key=key):
                original = self.metadata[key]
                self.metadata[key] = value
                self.write_ipa()
                self.assertNotEqual(self.collect().returncode, 0)
                self.assertFalse((self.root / "outputs").exists())
                self.metadata[key] = original


if __name__ == "__main__":
    unittest.main()
