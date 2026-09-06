import hashlib
import importlib.util
import io
import json
import os
from pathlib import Path
import plistlib
import stat
import subprocess
import sys
import tempfile
import types
import unittest
from unittest.mock import patch
import zipfile


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("import_shorebird_release", ROOT / "tool/import_shorebird_release.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)
REPOSITORY = "example/university"
SOURCE = "a" * 40


def origin(platform="ios"):
    return dict(id=123, path=MODULE.WORKFLOWS[platform], head_branch="master", event="workflow_dispatch",
        status="completed", conclusion="success", repository={"full_name": REPOSITORY},
        head_repository={"full_name": REPOSITORY}, head_sha=SOURCE, run_attempt=1)


def zip_bytes(entries):
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w") as archive:
        for name, data in entries:
            entry = zipfile.ZipInfo(name) if isinstance(name, str) else name
            if isinstance(name, str):
                entry.filename = name
            archive.writestr(entry, data)
    return output.getvalue()


def ipa_bytes(**overrides):
    values = dict(CFBundleIdentifier=MODULE.BUNDLE_IDS["ios"], CFBundleShortVersionString="5.2.1", CFBundleVersion="2439.17.57")
    return zip_bytes([("Payload/Runner.app/Info.plist", plistlib.dumps({**values, **overrides}))])


class ReleaseImporterTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)

    def artifact(self, data=b"archive", platform="ios"):
        return dict(id=456, name="ios-shorebird-release" if platform == "ios" else "android-beta-5.2.1+1006601",
            workflow_run={"id": 123, "head_sha": SOURCE, "head_branch": "master"}, expired=False,
            digest="sha256:" + hashlib.sha256(data).hexdigest(), size_in_bytes=len(data))

    def test_accepts_only_successful_manual_same_repository_release(self):
        for platform in MODULE.WORKFLOWS:
            self.assertEqual(MODULE.verify_run(origin(platform), REPOSITORY, 123, platform), SOURCE)
        mutations = [
            {"id": 124}, {"path": ".github/workflows/shorebird-patch.yml"}, {"head_branch": "feature"},
            {"event": "workflow_run"}, {"event": "pull_request"}, {"status": "in_progress"},
            {"conclusion": "failure"}, {"head_sha": "a" * 7}, {"run_attempt": 0},
            {"repository": {"full_name": "other/repo"}}, {"head_repository": {"full_name": "fork/repo"}},
        ]
        for mutation in mutations:
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                MODULE.verify_run({**origin(), **mutation}, REPOSITORY, 123, "ios")

    def test_artifact_requires_unique_immutable_matching_origin(self):
        artifact = self.artifact()
        with patch.object(MODULE, "api", return_value={"artifacts": [artifact]}):
            self.assertEqual(MODULE.find_artifact(REPOSITORY, origin(), "ios"), artifact)
        mutations = [
            {"expired": True}, {"digest": None}, {"digest": "sha256:bad"}, {"id": 0},
            {"size_in_bytes": MODULE.MAX_ARCHIVE_BYTES + 1},
            {"workflow_run": {"id": 124, "head_sha": SOURCE, "head_branch": "master"}},
            {"workflow_run": {"id": 123, "head_sha": "b" * 40, "head_branch": "master"}},
        ]
        for mutation in mutations:
            with self.subTest(mutation=mutation), patch.object(MODULE, "api", return_value={"artifacts": [{**artifact, **mutation}]}), self.assertRaises(ValueError):
                MODULE.find_artifact(REPOSITORY, origin(), "ios")
        for artifacts in ([], [artifact, artifact]):
            with patch.object(MODULE, "api", return_value={"artifacts": artifacts}), self.assertRaises(ValueError):
                MODULE.find_artifact(REPOSITORY, origin(), "ios")

    def test_artifact_discovery_follows_pagination(self):
        with patch.object(MODULE, "api", side_effect=[{"artifacts": [{"name": "unrelated"}] * 100}, {"artifacts": [self.artifact()]}]) as requests:
            self.assertEqual(MODULE.find_artifact(REPOSITORY, origin(), "ios")["id"], 456)
            self.assertIn("page=2", requests.call_args.args[0])

    def test_rejects_unsafe_and_ambiguous_zip_entries(self):
        link = zipfile.ZipInfo("application.ipa")
        link.external_attr = (stat.S_IFLNK | 0o777) << 16
        cases = [
            [("../escape", b"bad")], [("/absolute", b"bad")], [("C:/escape", b"bad")],
            [("nested\\escape", b"bad")], [(link, b"target")],
            [("application.ipa", b"one"), ("APPLICATION.IPA", b"two")],
        ]
        for entries in cases:
            with self.subTest(entries=entries), zipfile.ZipFile(io.BytesIO(zip_bytes(entries))) as archive, self.assertRaises(ValueError):
                MODULE.archive_entries(archive)
        with patch.object(MODULE, "MAX_CONTENT_BYTES", 1), zipfile.ZipFile(io.BytesIO(zip_bytes([("large", b"xx")]))) as archive, self.assertRaises(ValueError):
            MODULE.archive_entries(archive)

    def test_extracts_only_one_binary_to_a_fixed_local_name(self):
        path = self.root / "download.zip"
        output = self.root / "out"
        output.mkdir()
        path.write_bytes(zip_bytes([("nested/source.ipa", b"binary"), ("symbols.cms", b"encrypted")]))
        extracted = MODULE.extract_binary(path, output, "ios")
        self.assertEqual(extracted, output / "application.ipa")
        self.assertEqual(extracted.read_bytes(), b"binary")
        self.assertEqual(list(output.iterdir()), [extracted])
        path.write_bytes(zip_bytes([("one.ipa", b"one"), ("two.ipa", b"two")]))
        with self.assertRaises(ValueError):
            MODULE.extract_binary(path, output, "ios")

    def test_ipa_identity_comes_from_application_plist(self):
        path = self.root / "application.ipa"
        path.write_bytes(ipa_bytes())
        self.assertEqual(MODULE.binary_identity(path, "ios"), "5.2.1+2439.17.57")
        for mutation in ({"CFBundleIdentifier": "wrong.app"}, {"CFBundleVersion": "../../escape"}, {"CFBundleShortVersionString": "5.2.1;bad"}):
            path.write_bytes(ipa_bytes(**mutation))
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                MODULE.binary_identity(path, "ios")
        path.write_bytes(zip_bytes([("Payload/One.app/Info.plist", b"one"), ("Payload/Two.app/Info.plist", b"two")]))
        with self.assertRaises(ValueError):
            MODULE.binary_identity(path, "ios")

    def test_apk_identity_uses_aapt_and_rejects_wrong_package(self):
        good = b"package: name='ninja.mirea.mireaapp' versionCode='1006601' versionName='5.2.1'\n"
        with patch.object(MODULE, "aapt_path", return_value="aapt"), patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, stdout=good)) as command:
            self.assertEqual(MODULE.binary_identity(self.root / "app.apk", "android"), "5.2.1+1006601")
            self.assertEqual(command.call_args.args[0][:3], ["aapt", "dump", "badging"])
        for output in (good.replace(b"ninja.mirea.mireaapp", b"wrong.app"), good + good, b"malformed"):
            with patch.object(MODULE, "aapt_path", return_value="aapt"), patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, stdout=output)), self.assertRaises(ValueError):
                MODULE.binary_identity(self.root / "app.apk", "android")

    def import_fixture(self, *, corrupt=False, live_mutation=None, schema=False):
        data = zip_bytes([("release.ipa", ipa_bytes())])
        artifact = self.artifact(data)
        app_id = "21c47e68-a64f-49c1-af6e-4a406dfe266f"
        live = {"id": 789, "app_id": app_id, "version": "5.2.1+2439.17.57", "platform_statuses": {"ios": "active"}, "flutter_version": "3.44.2", "flutter_revision": "d" * 40, **(live_mutation or {})}
        built = {}

        def build_manifest(**values):
            built.update(values)
            return {"source_sha": values["source_sha"], "evidence": values["evidence"], "build_inputs": {}}

        helper = types.SimpleNamespace(
            GENERATED={"ios": ("ios/Tenant.xcconfig", "ios/Podfile.lock")},
            read_app_id=lambda *args: app_id, load_shorebird_release=lambda *args: live,
            build_manifest=build_manifest, write_manifest=lambda path, manifest: path.write_text(json.dumps(manifest)),
        )
        if schema:
            specification = importlib.util.spec_from_file_location("release_manifest", ROOT / "tool/release_manifest.py")
            helper = importlib.util.module_from_spec(specification)
            specification.loader.exec_module(helper)
            helper.read_app_id = lambda *args: app_id
            helper.load_shorebird_release = lambda *args: live
            helper.git = lambda *args: "c" * 40

        def command(arguments, **kwargs):
            if arguments[0] == "gh":
                kwargs["stdout"].write(b"corrupt" if corrupt else data)
            return subprocess.CompletedProcess(arguments, 0)

        with patch.dict(sys.modules, {"release_manifest": helper}), patch.dict(os.environ, {"GITHUB_REPOSITORY": REPOSITORY, "GITHUB_SHA": "b" * 40, "GITHUB_RUN_ID": "999", "GITHUB_RUN_ATTEMPT": "2"}), patch.object(MODULE, "api", return_value=origin()), patch.object(MODULE, "find_artifact", return_value=artifact), patch.object(MODULE, "command", side_effect=command):
            manifest = MODULE.import_release(repo=self.root, repository=REPOSITORY, run_id=123, platform="ios", output_dir=self.root / "registry")
        return manifest, built

    def test_import_preserves_origin_and_explicitly_marks_missing_prepared_inputs(self):
        manifest, built = self.import_fixture()
        evidence = manifest["evidence"]
        self.assertEqual(evidence["kind"], "legacy")
        self.assertEqual(evidence["run_id"], 123)
        self.assertEqual(evidence["artifact"]["id"], 456)
        self.assertEqual(evidence["registration_run_id"], 999)
        self.assertEqual(evidence["registration_run_attempt"], 2)
        self.assertEqual(evidence["signing_workflow"], ".github/workflows/shorebird-register.yml")
        self.assertEqual(evidence["signing_sha"], "b" * 40)
        self.assertEqual(evidence["missing_prepared_inputs"], ["ios/Tenant.xcconfig", "ios/Podfile.lock"])
        self.assertEqual(manifest["build_inputs"], {})
        self.assertEqual(built["source_sha"], SOURCE)
        self.assertEqual(built["release_version"], "5.2.1+2439.17.57")

    def test_imported_evidence_validates_against_the_shared_manifest_schema(self):
        manifest, _ = self.import_fixture(schema=True)
        stored = json.loads((self.root / "registry/release-manifest.json").read_text())
        self.assertEqual(manifest, stored)
        self.assertEqual(manifest["schema_version"], 1)
        self.assertEqual(manifest["evidence"]["missing_prepared_inputs"], ["ios/Flutter/Tenant.xcconfig", "ios/Podfile.lock"])
        self.assertEqual(manifest["build_inputs"], {})
        self.assertIsNone(manifest["private_native_sha"])
        binary = self.root / "registry/application.ipa"
        self.assertEqual(manifest["artifacts"], [{"name": "application.ipa", "sha256": MODULE.digest(binary), "size": binary.stat().st_size}])

    def test_downloaded_archive_digest_must_match_api(self):
        with self.assertRaisesRegex(ValueError, "immutable artifact digest"):
            self.import_fixture(corrupt=True)

    def test_live_shorebird_identity_must_match_binary(self):
        for mutation in ({"version": "5.2.1+1"}, {"app_id": "other-app"}, {"platform_statuses": {"ios": "draft"}}):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as directory:
                self.root = Path(directory)
                with self.assertRaisesRegex(ValueError, "active Shorebird"):
                    self.import_fixture(live_mutation=mutation)

    def test_registration_workflow_has_no_release_version_or_source_inputs(self):
        import yaml

        workflow = yaml.safe_load((ROOT / ".github/workflows/shorebird-register.yml").read_text())
        trigger = workflow.get("on", workflow.get(True))
        self.assertEqual(set(trigger["workflow_dispatch"]["inputs"]), {"run_id", "platform"})
        steps = workflow["jobs"]["register"]["steps"]
        self.assertIn('test "$WORKFLOW_REF" = refs/heads/master', steps[0]["run"])
        self.assertEqual(workflow["jobs"]["register"]["environment"], "beta")
        attest = next(step for step in steps if step["name"] == "Attest release manifest")
        self.assertTrue(attest["with"]["subject-path"].endswith("/release-manifest.json"))
        self.assertNotIn("--clobber", steps[-1]["run"])


if __name__ == "__main__":
    unittest.main()
