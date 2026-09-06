import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import types
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
        self.directory = Path(temporary.name)
        self.root = self.directory / "source"
        self.root.mkdir()
        self.output = self.directory / "projected"
        self.git("init", "-q")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        self.git("config", "core.autocrlf", "false")
        for path, data in {
            "pubspec.yaml": b"name: example\nversion: 92.17.6+8675309\n",
            "pubspec.lock": b"packages: {}\n",
            "android/app/build.gradle": b"baseline native\n",
            "android/app/google-services.json": b"baseline config\n",
            "assets/font.ttf": b"baseline asset",
            "lib/main.dart": b"void main() {}\n",
            "lib/remove.dart": b"const removed = true;\n",
            "packages/nested/client/pubspec.yaml": b"name: nested_client\n",
            "packages/nested/client/lib/client.dart": b"class Client {}\n",
            "test/main_test.dart": b"void main() {}\n",
            "test/tool/configuration_test.dart": b"baseline tool contract\n",
            "test/tool/removed_check.py": b"baseline tool check\n",
            "tool/generator.py": b"print('baseline generator')\n",
            ".github/workflows/test.yml": b"name: baseline\n",
            ".gitignore": b"/build/\n/.dart_tool/\n/lib/ignored.dart\n",
        }.items():
            self.write(path, data)
        self.baseline = self.commit()
        self.write("lib/main.dart", b"void main() { print('new'); }\n")
        self.source = self.commit()

    def git(self, *args, input=None):
        return subprocess.check_output(
            ["git", "-C", str(self.root), *args], input=input,
            stderr=subprocess.PIPE,
            env={**os.environ, "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": os.devnull},
        ).decode().strip()

    def write(self, path, data):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)

    def commit(self):
        self.git("add", "-A")
        self.git("commit", "-qm", "Fixture")
        return self.git("rev-parse", "HEAD")

    def project(self):
        return MODULE.projection(self.root, self.baseline, self.source)

    def materialize(self):
        entries, receipt = self.project()
        MODULE.materialize(self.root, self.output, entries, receipt)
        return entries, receipt

    def test_future_arbitrary_release_projects_without_version_or_sha_pins(self):
        entries, receipt = self.materialize()
        self.assertEqual((self.output / "lib/main.dart").read_bytes(), b"void main() { print('new'); }\n")
        self.assertEqual((self.output / "pubspec.yaml").read_bytes(), (self.root / "pubspec.yaml").read_bytes())
        self.assertEqual(MODULE.git(self.output, "rev-parse", "HEAD").decode().strip(), self.baseline)
        self.assertEqual(MODULE.git(self.output, "write-tree").decode().strip(), receipt["projected_tree_sha"])
        self.assertEqual(receipt["runtime_paths"], ["lib/main.dart"])
        self.assertEqual(receipt["source_tree_sha"], self.git("rev-parse", f"{self.source}^{{tree}}"))
        expected = hashlib.sha256(json.dumps(entries, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
        self.assertEqual(receipt["projection_sha256"], expected)

    def test_new_dart_arb_nested_package_and_test_files_are_projected(self):
        paths = ["lib/feature/new.dart", "lib/l10n/arb/app_new.arb",
                 "packages/nested/client/lib/new.dart", "test/feature/new_test.dart",
                 "packages/nested/client/test/client_test.dart", "test/goldens/new.png"]
        for path in paths:
            self.write(path, b"fixture\n")
        self.source = self.commit()
        entries, _ = self.materialize()
        for path in paths:
            self.assertIn(path, entries)
            self.assertEqual((self.output / path).read_bytes(), b"fixture\n")

    def test_runtime_and_test_deletions_are_materialized(self):
        for path in ["lib/remove.dart", "test/main_test.dart"]:
            (self.root / path).unlink()
        self.source = self.commit()
        entries, _ = self.materialize()
        for path in ["lib/remove.dart", "test/main_test.dart"]:
            self.assertNotIn(path, entries)
            self.assertFalse((self.output / path).exists())

    def test_support_changes_are_excluded_and_baseline_generators_remain(self):
        _, before = self.project()
        for path in ["tool/generator.py", ".github/workflows/test.yml", "supabase/migrations/new.sql", "docs/new.md", "README.md"]:
            self.write(path, b"new support\n")
        self.source = self.commit()
        _, receipt = self.materialize()
        self.assertEqual(receipt["projection_sha256"], before["projection_sha256"])
        self.assertEqual((self.output / "tool/generator.py").read_bytes(), b"print('baseline generator')\n")
        self.assertFalse((self.output / "supabase/migrations/new.sql").exists())
        self.assertEqual(len(receipt["excluded_paths"]), 5)

    def test_support_deletion_keeps_baseline_file(self):
        (self.root / "tool/generator.py").unlink()
        self.source = self.commit()
        self.materialize()
        self.assertTrue((self.output / "tool/generator.py").exists())

    def test_tool_tests_remain_at_baseline_and_leave_runtime_test_receipt(self):
        runtime_tests = ["test/feature/screen_test.dart", "packages/nested/client/test/client_test.dart",
                         "test/toolbox/runtime_test.dart"]
        for path in runtime_tests:
            self.write(path, b"new runtime test\n")
        self.source = self.commit()
        _, before = self.project()
        self.write("test/tool/configuration_test.dart", b"new tool contract\n")
        (self.root / "test/tool/removed_check.py").unlink()
        new_tool_tests = ["test/tool/new_contract_test.dart", "test/tool/new_policy_test.py"]
        for path in new_tool_tests:
            self.write(path, b"new tooling test\n")
        self.source = self.commit()
        entries, receipt = self.materialize()
        self.assertEqual(receipt["projection_sha256"], before["projection_sha256"])
        self.assertEqual(receipt["projected_tree_sha"], before["projected_tree_sha"])
        self.assertEqual(receipt["test_paths"], sorted(runtime_tests))
        self.assertEqual(receipt["runtime_paths"], ["lib/main.dart"])
        self.assertEqual(set(receipt["excluded_paths"]), {
            "test/tool/configuration_test.dart", "test/tool/removed_check.py", *new_tool_tests,
        })
        self.assertEqual((self.output / "test/tool/configuration_test.dart").read_bytes(), b"baseline tool contract\n")
        self.assertEqual((self.output / "test/tool/removed_check.py").read_bytes(), b"baseline tool check\n")
        for path in new_tool_tests:
            self.assertNotIn(path, entries)
            self.assertFalse((self.output / path).exists())
        for path in runtime_tests:
            self.assertEqual((self.output / path).read_bytes(), b"new runtime test\n")

    def test_each_protected_path_is_rejected(self):
        for path in ["pubspec.yaml", "pubspec.lock", "packages/nested/client/pubspec.yaml",
                     "android/app/build.gradle", "ios/Runner/Info.plist", "web/index.html",
                     "assets/new.png", "packages/nested/client/assets/new.png", ".fvmrc",
                     "shorebird.yaml", "l10n.yaml", "lib/new.json", "unknown/file.dart",
                     "packages/nested/client/android/lib/native.dart", "packages/nested/client/android/test/Native.java", "test/pubspec.yaml"]:
            with self.subTest(path=path):
                self.git("reset", "--hard", self.source)
                self.write(path, b"changed\n")
                changed = self.commit()
                with self.assertRaisesRegex(ValueError, "full release"):
                    MODULE.projection(self.root, self.baseline, changed)
        self.git("reset", "--hard", self.source)

    def test_dependency_version_only_change_is_not_normalized(self):
        self.write("pubspec.yaml", b"name: example\nversion: 93.0.0+9999999\n")
        self.source = self.commit()
        with self.assertRaisesRegex(ValueError, "Dependency changes"):
            self.project()

    def test_unknown_package_root_requires_full_release(self):
        self.write("packages/unknown/lib/new.dart", b"new\n")
        self.source = self.commit()
        with self.assertRaisesRegex(ValueError, "full release"):
            self.project()

    def test_deleted_protected_file_is_rejected(self):
        (self.root / "assets/font.ttf").unlink()
        self.source = self.commit()
        with self.assertRaisesRegex(ValueError, "full release"):
            self.project()

    def test_unrelated_history_is_rejected(self):
        self.git("checkout", "--orphan", "other")
        self.git("rm", "-rf", ".")
        self.write("lib/main.dart", b"other\n")
        self.source = self.commit()
        with self.assertRaisesRegex(ValueError, "ancestor"):
            self.project()

    def test_short_sha_and_revision_expressions_are_rejected(self):
        for revision in ["HEAD", self.source[:12], f"{self.source}~1", "-" * 40]:
            with self.subTest(revision=revision), self.assertRaisesRegex(ValueError, "full commit"):
                MODULE.projection(self.root, self.baseline, revision)

    def test_changed_file_mode_is_rejected(self):
        self.git("update-index", "--chmod=+x", "lib/main.dart")
        self.git("commit", "-qm", "Mode")
        self.source = self.git("rev-parse", "HEAD")
        with self.assertRaisesRegex(ValueError, "mode changes"):
            self.project()

    def test_symlink_and_gitlink_sources_are_rejected_without_following(self):
        original = self.source
        for mode, path, identity in [
            ("120000", "lib/link.dart", self.git("hash-object", "-w", "--stdin", input=b"../../outside")),
            ("160000", "packages/submodule", self.baseline),
        ]:
            with self.subTest(mode=mode):
                self.git("reset", "--hard", original)
                self.git("update-index", "--add", "--cacheinfo", mode, identity, path)
                self.git("commit", "-qm", "Special file")
                self.source = self.git("rev-parse", "HEAD")
                with self.assertRaisesRegex(ValueError, "Symlinks, gitlinks"):
                    self.project()

    def test_unchanged_baseline_symlink_is_also_rejected(self):
        identity = self.git("hash-object", "-w", "--stdin", input=b"../../outside")
        self.git("update-index", "--add", "--cacheinfo", "120000", identity, "docs/link")
        self.git("commit", "-qm", "Link baseline")
        self.baseline = self.git("rev-parse", "HEAD")
        self.source = self.baseline
        with self.assertRaisesRegex(ValueError, "Symlinks, gitlinks"):
            self.project()

    def test_worktree_injection_and_tracked_drift_are_rejected(self):
        entries, receipt = self.materialize()
        target = self.output / "lib/main.dart"
        expected = target.read_bytes()
        target.write_bytes(b"injected\n")
        with self.assertRaisesRegex(ValueError, "Projection drift"):
            MODULE.verify_worktree(self.output, entries, receipt)
        target.write_bytes(expected)
        (self.output / "unexpected.dart").write_bytes(b"injected\n")
        with self.assertRaisesRegex(ValueError, "Unexpected untracked"):
            MODULE.verify_worktree(self.output, entries, receipt)

    def test_ignored_runtime_injection_is_rejected(self):
        entries, receipt = self.materialize()
        (self.output / "lib/ignored.dart").write_bytes(b"injected\n")
        with self.assertRaisesRegex(ValueError, "ignored runtime"):
            MODULE.verify_worktree(self.output, entries, receipt)

    def private_checkout(self):
        self.write(".gitignore", (self.root / ".gitignore").read_bytes() + b"/android/private/\n/other-private/\n")
        self.baseline = self.commit()
        self.source = self.baseline
        entries, receipt = self.materialize()
        private = self.output / "android/private/nfc-pass-android"
        private.mkdir(parents=True)
        env = {**os.environ, "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": os.devnull}
        MODULE.git(private, "init", "-q", env=env)
        (private / "Native.kt").write_bytes(b"class Native\n")
        MODULE.git(private, "add", "Native.kt", env=env)
        MODULE.git(private, "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "-qm", "Fixture", env=env)
        manifest = {"platform": "android", "private_native_sha": MODULE.git(private, "rev-parse", "HEAD").decode().strip(), "build_inputs": {}}
        spec = importlib.util.spec_from_file_location("release_manifest", ROOT / "tool/release_manifest.py")
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        replacement = patch.dict(sys.modules, {"release_manifest": module})
        replacement.start()
        self.addCleanup(replacement.stop)
        return private, entries, receipt, manifest

    def test_pinned_clean_ignored_native_repository_is_verified_before_exemption(self):
        private, entries, receipt, manifest = self.private_checkout()
        ignored = MODULE.git(self.output, "ls-files", "--others", "--ignored", "--exclude-standard", "-z").decode().split("\0")
        self.assertIn("android/private/nfc-pass-android/", ignored)
        MODULE.verify_worktree(self.output, entries, receipt, manifest)
        MODULE.verify_worktree(self.output, entries, receipt, manifest, verify_native_inputs=True)
        for provided in (None, {**manifest, "platform": "ios"}, {**manifest, "private_native_sha": None},
                         {**manifest, "private_native_sha": "0" * 40}):
            with self.subTest(manifest=provided), self.assertRaises(ValueError):
                MODULE.verify_worktree(self.output, entries, receipt, provided)
        self.assertTrue(private.is_dir())

    def test_ignored_native_repository_rejects_dirty_and_untracked_content(self):
        private, entries, receipt, manifest = self.private_checkout()
        target = private / "Native.kt"
        target.write_bytes(b"changed native source\n")
        with self.assertRaisesRegex(ValueError, "unrecorded changes"):
            MODULE.verify_worktree(self.output, entries, receipt, manifest)
        target.write_bytes(b"class Native\n")
        (private / "Untracked.kt").write_bytes(b"untracked native source\n")
        with self.assertRaisesRegex(ValueError, "unrecorded changes"):
            MODULE.verify_worktree(self.output, entries, receipt, manifest)

    def test_ignored_native_checkout_rejects_symlink_ancestors(self):
        private, _, _, manifest = self.private_checkout()
        original = Path.is_symlink
        for ancestor in (self.output / "android", private.parent, private):
            with self.subTest(ancestor=ancestor), patch.object(Path, "is_symlink", lambda path: path == ancestor or original(path)), self.assertRaisesRegex(ValueError, "Unsafe private"):
                MODULE.verify_ignored_private_checkout(self.output, manifest)

    def test_other_ignored_nested_repository_is_not_exempted(self):
        _, entries, receipt, manifest = self.private_checkout()
        other = self.output / "other-private"
        other.mkdir()
        MODULE.git(other, "init", "-q")
        (other / "source.dart").write_bytes(b"untrusted\n")
        with self.assertRaisesRegex(ValueError, "Unsafe repository path"):
            MODULE.verify_worktree(self.output, entries, receipt, manifest)

    def test_staged_changes_are_rejected(self):
        entries, receipt = self.materialize()
        (self.output / "lib/main.dart").write_bytes(b"injected\n")
        MODULE.git(self.output, "add", "lib/main.dart")
        with self.assertRaisesRegex(ValueError, "index differs"):
            MODULE.verify_worktree(self.output, entries, receipt)

    def test_output_cannot_replace_source_or_nonempty_directory(self):
        entries, receipt = self.project()
        for output in [self.root, self.root / "projection"]:
            with self.assertRaisesRegex(ValueError, "separate directory"):
                MODULE.materialize(self.root, output, entries, receipt)
        self.output.mkdir()
        (self.output / "keep.txt").write_text("keep")
        with self.assertRaisesRegex(ValueError, "must be empty"):
            MODULE.materialize(self.root, self.output, entries, receipt)
        self.assertEqual((self.output / "keep.txt").read_text(), "keep")

    def test_manifest_must_match_baseline_and_verify_native_inputs(self):
        calls = []
        manifest = {"source_sha": self.baseline, "source_tree": self.git("rev-parse", f"{self.baseline}^{{tree}}"), "platform": "android", "app_id": "example-app", "build_inputs": {"android/app/google-services.json": hashlib.sha256(b"prepared\n").hexdigest()}}
        def verify(root, value):
            calls.append(root)
            for path, digest in value["build_inputs"].items():
                if hashlib.sha256((root / path).read_bytes()).hexdigest() != digest:
                    raise ValueError("Native fingerprint mismatch")
        module = types.SimpleNamespace(load_manifest=lambda _: manifest, read_app_id=lambda *_: "example-app", verify_native_config=verify)
        with patch.dict(sys.modules, {"release_manifest": module}):
            self.assertEqual(MODULE.manifest_for(Path("manifest.json"), self.baseline, self.root), manifest)
            with self.assertRaisesRegex(ValueError, "does not match"):
                MODULE.manifest_for(Path("manifest.json"), self.source, self.root)
            with patch.dict(manifest, {"source_tree": "0" * 40}), self.assertRaisesRegex(ValueError, "tree does not match"):
                MODULE.manifest_for(Path("manifest.json"), self.baseline, self.root)
            with patch.dict(manifest, {"app_id": "other-app"}), self.assertRaisesRegex(ValueError, "app identity"):
                MODULE.manifest_for(Path("manifest.json"), self.baseline, self.root)
            entries, receipt = self.materialize()
            target = self.output / "android/app/google-services.json"
            MODULE.verify_worktree(self.output, entries, receipt, manifest)
            self.assertEqual(calls, [])
            target.write_bytes(b"prepared\n")
            MODULE.verify_worktree(self.output, entries, receipt, manifest, verify_native_inputs=True)
            self.assertEqual(calls, [self.output])
            target.write_bytes(b"wrong config\n")
            with self.assertRaisesRegex(ValueError, "fingerprint mismatch"):
                MODULE.verify_worktree(self.output, entries, receipt, manifest)

    def test_manifest_cannot_override_projected_dart(self):
        entries, receipt = self.materialize()
        (self.output / "lib/main.dart").write_bytes(b"other\n")
        with self.assertRaisesRegex(ValueError, "Projection drift"):
            MODULE.verify_worktree(self.output, entries, receipt, {"build_inputs": {"lib/main.dart": "ignored"}})

    def test_projection_uses_commit_objects_not_ambient_checkout(self):
        self.git("checkout", "--detach", self.baseline)
        self.write("lib/main.dart", b"ambient dirty content")
        _, receipt = self.materialize()
        self.assertEqual(receipt["source_sha"], self.source)
        self.assertEqual((self.output / "lib/main.dart").read_bytes(), b"void main() { print('new'); }\n")

    def test_unsafe_paths_are_rejected(self):
        for path in ["/tmp/file.dart", "lib/../file.dart", "lib/.git/config", "lib\\file.dart", "C:/file.dart", "lib//file.dart", "lib/file\n.dart"]:
            with self.subTest(path=path), self.assertRaisesRegex(ValueError, "Unsafe repository path"):
                MODULE.classification(path)

    def test_generated_inputs_are_optional_before_preparation_but_validated_when_present(self):
        entries, receipt = self.materialize()
        manifest = {"build_inputs": {"android/app/generated.json": hashlib.sha256(b"prepared").hexdigest()}}
        MODULE.verify_worktree(self.output, entries, receipt, manifest)
        target = self.output / "android/app/generated.json"
        target.write_bytes(b"prepared")
        MODULE.verify_worktree(self.output, entries, receipt, manifest)
        target.write_bytes(b"other")
        with self.assertRaisesRegex(ValueError, "fingerprint mismatch"):
            MODULE.verify_worktree(self.output, entries, receipt, manifest)

    def test_cli_receipt_and_verification_contract(self):
        receipt = self.directory / "receipt.json"
        github_output = self.directory / "github-output"
        arguments = [sys.executable, str(ROOT / "tool/prepare_shorebird_patch.py"),
                     "--repo", str(self.root), "--baseline", self.baseline, "--source", self.source,
                     "--output", str(self.output), "--receipt", str(receipt)]
        result = subprocess.run([*arguments, "--github-output", str(github_output)], capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(result.stdout)
        self.assertEqual(json.loads(receipt.read_text()), data)
        self.assertIn(f"projection_sha256={data['projection_sha256']}", github_output.read_text())
        verified = subprocess.run([*arguments, "--verify-worktree", "--expected-projection", data["projection_sha256"]], capture_output=True, text=True)
        self.assertEqual(verified.returncode, 0, verified.stderr)
        failed = subprocess.run([*arguments, "--verify-worktree", "--expected-projection", "0" * 64], capture_output=True, text=True)
        self.assertNotEqual(failed.returncode, 0)
        data["source_sha"] = "0" * 40
        receipt.write_text(json.dumps(data))
        failed = subprocess.run([*arguments, "--verify-worktree"], capture_output=True, text=True)
        self.assertNotEqual(failed.returncode, 0)
        self.assertIn("receipt identity mismatch", failed.stderr)


if __name__ == "__main__":
    unittest.main()
