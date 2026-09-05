import hashlib
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
        test_path = "packages/app_ui/test/src/widgets/app_horizontal_scroll_view_test.dart"
        self.assertEqual({path for path in MODULE.WORKFLOW_PATHS if path.startswith("packages/")}, {test_path})
        self.write(test_path, b"void main() {}\n")
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


class NavigationFirebaseTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name).resolve()
        self.target = self.root / "android/app/google-services.json"
        self.target.parent.mkdir(parents=True)
        self.config = b'{"project_info":{"project_id":"fixture"}}\n'
        context = patch.object(MODULE, "NAV_FIREBASE_SHA256", hashlib.sha256(self.config).hexdigest())
        context.start()
        self.addCleanup(context.stop)

    def test_exact_released_native_bytes_are_required(self):
        self.target.write_bytes(self.config)
        MODULE.verify_navigation_firebase(self.root)
        self.target.write_bytes(self.config.replace(b"\n", b"\r\n"))
        with self.assertRaisesRegex(ValueError, "differs from the verified release"):
            MODULE.verify_navigation_firebase(self.root)

    def test_missing_file_and_symlink_are_rejected(self):
        with self.assertRaisesRegex(ValueError, "Missing or invalid"):
            MODULE.verify_navigation_firebase(self.root)
        self.target.write_bytes(self.config)
        with patch.object(Path, "is_symlink", return_value=True):
            with self.assertRaisesRegex(ValueError, "Missing or invalid"):
                MODULE.verify_navigation_firebase(self.root)


class NavigationProjectionTest(unittest.TestCase):
    git = PrepareShorebirdPatchTest.git
    write = PrepareShorebirdPatchTest.write
    commit = PrepareShorebirdPatchTest.commit
    pin = PrepareShorebirdPatchTest.pin

    def setUp(self):
        PrepareShorebirdPatchTest.setUp(self)
        self.pin("NAV_BASELINE_SHA", self.reviewed)
        for path in MODULE.NAV_RUNTIME_PATHS:
            self.write(path, b"void reviewedNavigation() {}\n")
        for path in MODULE.NAV_TEST_PATHS:
            self.write(path, b"void main() {}\n")
        self.pin("NAV_REVIEWED_SOURCE_SHA", self.commit())

    def project(self):
        source = self.git("rev-parse", "HEAD")
        return MODULE.projection(self.root, source, source, MODULE.NAV_RELEASE_VERSION)

    def test_navigation_keeps_baseline_native_dependencies_and_assets_without_overlays(self):
        overrides, receipt = self.project()
        self.assertEqual(overrides, {})
        self.assertEqual(receipt["baseline_sha"], self.reviewed)
        self.assertEqual(receipt["release_version"], "5.2.1+1005801")
        MODULE.verify_worktree(self.root, overrides)
        for path in (MODULE.MANIFEST, "pubspec.yaml", "pubspec.lock", "assets/font.ttf"):
            self.assertEqual(MODULE.blob(self.root, self.reviewed, path), (self.root / path).read_bytes())

    def test_even_reviewed_native_assets_and_dependency_changes_are_rejected(self):
        reviewed = self.git("rev-parse", "HEAD")
        for path in (MODULE.MANIFEST, "pubspec.yaml", "pubspec.lock", "assets/new.ttf", "lib/unreviewed.dart"):
            with self.subTest(path=path):
                self.git("reset", "--hard", reviewed)
                self.write(path, b"unapproved change\n")
                self.pin("NAV_REVIEWED_SOURCE_SHA", self.commit())
                with self.assertRaisesRegex(ValueError, "Only the reviewed navigation"):
                    self.project()

    def test_ios_uses_the_same_unchanged_native_projection(self):
        source = self.git("rev-parse", "HEAD")
        overrides, receipt = MODULE.projection(self.root, source, source, MODULE.NAV_IOS_RELEASE_VERSION)
        self.assertEqual(overrides, {})
        self.assertEqual(receipt["release_version"], "5.2.1+2439.14.43")
        self.assertEqual(receipt["projection_sha256"], self.project()[1]["projection_sha256"])
        self.assertFalse((self.root / "android/app/google-services.json").exists())
        self.write("ios/Runner/Info.plist", b"changed native configuration")
        source = self.commit()
        self.pin("NAV_REVIEWED_SOURCE_SHA", source)
        with self.assertRaisesRegex(ValueError, "Only the reviewed navigation"):
            MODULE.projection(self.root, source, source, MODULE.NAV_IOS_RELEASE_VERSION)

    def test_runtime_tail_cannot_change_even_approved_files_after_review(self):
        self.write(sorted(MODULE.NAV_RUNTIME_PATHS)[0], b"void unreviewedTail() {}\n")
        self.commit()
        with self.assertRaisesRegex(ValueError, "explicitly reviewed snapshot"):
            self.project()

    def test_workflow_tail_has_distinct_receipt_and_runtime_drift_still_fails(self):
        _, original = self.project()
        self.write(".github/workflows/shorebird-patch.yml", b"name: Patch\n")
        self.commit()
        overrides, updated = self.project()
        self.assertNotEqual(original["projection_sha256"], updated["projection_sha256"])
        self.write(sorted(MODULE.NAV_RUNTIME_PATHS)[0], b"void drift() {}\n")
        with self.assertRaisesRegex(ValueError, "Unexpected tracked changes"):
            MODULE.verify_worktree(self.root, overrides)


class ReadStateProjectionTest(unittest.TestCase):
    git = PrepareShorebirdPatchTest.git
    write = PrepareShorebirdPatchTest.write
    commit = PrepareShorebirdPatchTest.commit
    pin = PrepareShorebirdPatchTest.pin

    def setUp(self):
        NavigationProjectionTest.setUp(self)
        baseline = self.git("rev-parse", "HEAD")
        self.pin("READ_STATE_BASELINES", {version: baseline for version in MODULE.READ_STATE_BASELINES})
        for path in MODULE.READ_STATE_RUNTIME_PATHS | MODULE.READ_STATE_SUPPORT_PATHS:
            self.write(path, b"reviewed read state\n")
        self.pin("READ_STATE_REVIEWED_SHA", self.commit())

    def project(self):
        source = self.git("rev-parse", "HEAD")
        return MODULE.projection(self.root, source, source, "5.2.1+1006201")

    def test_all_current_releases_keep_native_files_identical(self):
        source = self.git("rev-parse", "HEAD")
        for version, baseline in MODULE.READ_STATE_BASELINES.items():
            with self.subTest(version=version):
                overrides, receipt = MODULE.projection(self.root, source, source, version)
                self.assertEqual(overrides, {})
                self.assertEqual(receipt["baseline_sha"], baseline)
                self.assertEqual(receipt["reviewed_source_sha"], MODULE.READ_STATE_REVIEWED_SHA)
                self.assertEqual(receipt["release_version"], version)
                MODULE.verify_worktree(self.root, overrides)
                for path in (MODULE.MANIFEST, "pubspec.yaml", "pubspec.lock", "assets/font.ttf"):
                    self.assertEqual(MODULE.blob(self.root, baseline, path), (self.root / path).read_bytes())

    def test_read_state_snapshot_rejects_even_reviewed_native_or_dependency_changes(self):
        for path in (MODULE.MANIFEST, "pubspec.yaml", "pubspec.lock", "assets/font.ttf", "packages/promo_repository/android/build.gradle"):
            with self.subTest(path=path):
                previous = self.git("rev-parse", "HEAD")
                self.write(path, b"unreviewed native change\n")
                self.pin("READ_STATE_REVIEWED_SHA", self.commit())
                with self.assertRaisesRegex(ValueError, "Only the reviewed read-state"):
                    self.project()
                self.git("reset", "--hard", previous)

    def test_migration_cannot_change_after_review(self):
        path = next(path for path in MODULE.READ_STATE_SUPPORT_PATHS if path.startswith("supabase/migrations/"))
        self.write(path, b"changed migration\n")
        self.commit()
        with self.assertRaisesRegex(ValueError, "explicitly reviewed read-state"):
            self.project()

    def test_policy_only_tail_is_supported(self):
        self.write("tool/prepare_shorebird_patch.py", b"policy support\n")
        self.commit()
        self.project()


if __name__ == "__main__":
    unittest.main()
