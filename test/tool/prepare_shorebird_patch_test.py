import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("prepare_shorebird_patch", ROOT / "tool/prepare_shorebird_patch.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class PrepareShorebirdPatchTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.git("init", "-q")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        self.git("config", "core.autocrlf", "false")
        self.write("pubspec.yaml", b"name: example\nversion: 5.2.1+154\ndependencies:\n  pdfx: ^2.11.0\n")
        self.lock = b'packages:\n  existing:\n    version: "1.0.0"\nsdks:\n  dart: ">=3.12.0"\n'
        self.write("pubspec.lock", self.lock)
        self.manifest = b"<manifest>\n    <queries>\n    </queries>\n</manifest>\n"
        self.write(MODULE.MANIFEST, self.manifest)
        self.write("assets/font.ttf", b"original asset")
        self.write("lib/main.dart", b"void main() {}\n")
        self.baseline = self.commit()
        self.write(MODULE.MANIFEST, self.manifest.replace(b"    </queries>", MODULE.PROCESS_TEXT + b"    </queries>"))
        pubspec = (self.root / "pubspec.yaml").read_bytes()
        self.write("pubspec.yaml", pubspec.replace(b"  pdfx:", b"  pdf: 3.12.0\n  pdfx:"))
        additions = "".join(
            f'  {name}:\n    dependency: transitive\n    description:\n      name: {name}\n      sha256: "{digest}"\n      url: "https://pub.dev"\n    source: hosted\n    version: "{version}"\n'
            for name, (version, digest) in MODULE.DART_PACKAGES.items()
        )
        self.write("pubspec.lock", self.lock.replace(b"sdks:", additions.encode() + b"sdks:"))
        self.write("lib/main.dart", b"void main() { print('reviewed'); }\n")
        self.reviewed = self.commit()
        self.pin("BASELINE_SHA", self.baseline)
        self.pin("REVIEWED_SOURCE_SHA", self.reviewed)

    def pin(self, name, value):
        context = patch.object(MODULE, name, value)
        context.start()
        self.addCleanup(context.stop)

    def git(self, *arguments):
        return subprocess.check_output(
            ["git", "-C", str(self.root), *arguments],
            stderr=subprocess.PIPE, timeout=15,
            env={**os.environ, "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": os.devnull},
        ).decode().strip()

    def write(self, path, value):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(value)

    def commit(self):
        self.git("add", ".")
        self.git("commit", "-qm", "Fixture")
        return self.git("rev-parse", "HEAD")

    def project(self, source=None):
        revision = source or self.git("rev-parse", "HEAD")
        return MODULE.projection(self.root, revision, revision)

    def test_projection_restores_native_and_keeps_reviewed_dart_and_pdf(self):
        overrides, receipt = self.project()
        self.assertEqual(overrides[MODULE.MANIFEST], self.manifest)
        self.assertIn(b"  pdf: 3.12.0\n", overrides["pubspec.yaml"])
        for path, value in overrides.items():
            self.write(path, value)
        MODULE.verify_worktree(self.root, overrides)
        self.assertIn(b"reviewed", (self.root / "lib/main.dart").read_bytes())
        self.assertEqual(len(receipt["projection_sha256"]), 64)
        self.assertEqual(receipt["reviewed_source_sha"], self.reviewed)

    def test_arbitrary_runtime_tail_is_rejected(self):
        self.write("lib/unreviewed.dart", b"void change() {}\n")
        self.commit()
        with self.assertRaisesRegex(ValueError, "explicitly reviewed snapshot"):
            self.project()

    def test_reviewed_support_tail_is_allowed_and_has_a_distinct_receipt(self):
        _, initial = self.project()
        self.write(".github/workflows/shorebird-patch.yml", b"name: Patch\n")
        fixtures = {
            "supabase/tests/guest_active_day_contract.sql",
            "supabase/tests/mentorship_contract.sql",
        }
        self.assertEqual({path for path in MODULE.WORKFLOW_PATHS if path.startswith("supabase/")}, fixtures)
        for path in fixtures:
            self.write(path, b"select 1;\n")
        source = self.commit()
        _, updated = self.project(source)
        self.assertNotEqual(initial["projection_sha256"], updated["projection_sha256"])
        self.assertEqual(updated["source_sha"], source)

    def test_new_asset_in_reviewed_commit_is_still_rejected(self):
        self.write("assets/new-font.ttf", b"new asset")
        self.pin("REVIEWED_SOURCE_SHA", self.commit())
        with self.assertRaisesRegex(ValueError, "bundled assets"):
            self.project()

    def test_other_native_manifest_changes_are_not_hidden(self):
        path = self.root / MODULE.MANIFEST
        self.write(MODULE.MANIFEST, path.read_bytes().replace(b"<manifest>", b'<manifest package="changed">'))
        self.pin("REVIEWED_SOURCE_SHA", self.commit())
        with self.assertRaisesRegex(ValueError, "only reviewed manifest change"):
            self.project()

    def test_existing_dependency_upgrade_is_rejected(self):
        path = self.root / "pubspec.lock"
        self.write("pubspec.lock", path.read_bytes().replace(b'"1.0.0"', b'"2.0.0"'))
        self.pin("REVIEWED_SOURCE_SHA", self.commit())
        with self.assertRaisesRegex(ValueError, "locked dependencies"):
            self.project()

    def test_package_native_resource_is_rejected_even_if_reviewed(self):
        self.write("packages/example/android/build.gradle", b"native configuration")
        self.pin("REVIEWED_SOURCE_SHA", self.commit())
        with self.assertRaisesRegex(ValueError, "bundled assets"):
            self.project()

    def test_post_projection_runtime_drift_is_rejected(self):
        overrides, _ = self.project()
        for path, value in overrides.items():
            self.write(path, value)
        self.write("lib/main.dart", b"void main() { print('drift'); }\n")
        with self.assertRaisesRegex(ValueError, "Unexpected tracked changes"):
            MODULE.verify_worktree(self.root, overrides)

    def test_untracked_source_injection_is_rejected(self):
        overrides, _ = self.project()
        for path, value in overrides.items():
            self.write(path, value)
        self.write("lib/extra.dart", b"void extra() {}\n")
        with self.assertRaisesRegex(ValueError, "Unexpected untracked"):
            MODULE.verify_worktree(self.root, overrides)

    def test_requested_source_must_match_the_checkout(self):
        with self.assertRaisesRegex(ValueError, "Checked-out commit"):
            self.project(self.baseline)


if __name__ == "__main__":
    unittest.main()
