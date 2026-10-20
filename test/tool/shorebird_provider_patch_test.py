import copy
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tool"))
import prepare_shorebird_patch as public
import release_manifest
import shorebird_provider_patch as provider


class ProviderPatchTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.directory = Path(self.temporary.name)
        self.app = self.directory / "app"
        self.provider = self.directory / "provider"
        self.output = self.directory / "projection"
        for root in (self.app, self.provider):
            root.mkdir()
            self.git(root, "init", "-q")
            self.git(root, "config", "user.name", "Test")
            self.git(root, "config", "user.email", "test@example.invalid")
            self.git(root, "config", "core.autocrlf", "false")
        for name, value in {
            "pubspec.yaml": "name: university_provider\n",
            "pubspec.lock": "packages: {}\n",
            "lib/auth.dart": "const cookie = 'old';\n",
            "test/auth_test.dart": "void main() {}\n",
            "android/Native.kt": "class Native\n",
            "assets/icon.png": "unchanged asset",
            ".gitignore": ".dart_tool/\nbuild/\nlib/injected.dart\n",
        }.items():
            self.write(self.provider, name, value)
        self.provider_baseline = self.commit(self.provider)
        self.write(self.app, "config/university_provider.json", json.dumps(self.pin(self.provider_baseline)))
        self.write(self.app, "pubspec.yaml", "name: app\n")
        self.write(self.app, "pubspec.lock", "packages: {}\n")
        self.write(self.app, "lib/main.dart", "void main() {}\n")
        self.write(self.app, ".gitignore", "/private/\n/build/\n/.dart_tool/\n")
        self.baseline = self.commit(self.app)
        self.write(self.provider, "lib/auth.dart", "const cookie = 'Pulse.Auth.Cookie';\n")
        self.write(self.provider, "test/auth_test.dart", "void main() { print('updated'); }\n")
        self.provider_source = self.commit(self.provider)
        self.set_source(self.provider_source)
        self.manifest = {"source_sha": self.baseline, "provider_sha": self.provider_baseline, "build_inputs": {}}

    def git(self, root, *args):
        return subprocess.check_output(
            ["git", "-C", str(root), *args], stderr=subprocess.PIPE,
            env={**os.environ, "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": os.devnull},
        ).decode().strip()

    def write(self, root, name, value):
        path = root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(value, encoding="utf-8")

    def commit(self, root):
        self.git(root, "add", "-A")
        self.git(root, "commit", "-qm", "Fixture")
        return self.git(root, "rev-parse", "HEAD")

    def pin(self, revision):
        return {"repository": "owner/provider", "ref": revision, "path": "."}

    def set_source(self, revision):
        self.write(self.app, "config/university_provider.json", json.dumps(self.pin(revision)))
        self.source = self.commit(self.app)

    def prepare(self):
        return provider.prepare(self.app, self.baseline, self.source, self.manifest, self.provider)

    def materialize(self):
        identity = self.prepare()
        entries, receipt = public.projection(self.app, self.baseline, self.source, identity)
        public.materialize(self.app, self.output, entries, receipt)
        provider.materialize(self.provider, self.output, self.provider_source)
        return entries, receipt

    def test_dart_hotfix_keeps_baseline_manifest_pin_dependencies_and_native_inputs(self):
        entries, receipt = self.materialize()

        public.verify_worktree(self.output, entries, receipt, self.manifest)
        release_manifest.verify_native_config(self.output, self.manifest, receipt)
        self.assertEqual(json.loads((self.output / provider.PIN).read_text())["ref"], self.provider_baseline)
        self.assertEqual(self.git(self.output / provider.CHECKOUT, "rev-parse", "HEAD"), self.provider_source)
        self.assertEqual(receipt["provider_projection"]["baseline_sha"], self.provider_baseline)
        self.assertEqual(receipt["provider_projection"]["source_sha"], self.provider_source)
        self.assertEqual(receipt["provider_projection"]["runtime_paths"], ["lib/auth.dart"])
        self.assertEqual(receipt["provider_projection"]["test_paths"], ["test/auth_test.dart"])
        self.assertEqual((self.output / "pubspec.lock").read_bytes(), (self.app / "pubspec.lock").read_bytes())
        for name in ("pubspec.yaml", "pubspec.lock", "android/Native.kt", "assets/icon.png"):
            expected = public.git(self.provider, "show", f"{self.provider_baseline}:{name}")
            self.assertEqual((self.output / provider.CHECKOUT / name).read_bytes(), expected)
        with self.assertRaisesRegex(ValueError, "differs from the release"):
            release_manifest.verify_native_config(self.output, self.manifest)

    def test_changed_pin_without_verified_provider_still_requires_full_release(self):
        with self.assertRaisesRegex(ValueError, "full release"):
            public.projection(self.app, self.baseline, self.source)

    def test_dependency_native_asset_and_unknown_changes_are_rejected(self):
        original = self.provider_source
        for name in ("pubspec.yaml", "pubspec.lock", "android/Native.kt", "assets/icon.png", "README.md"):
            with self.subTest(name=name):
                self.git(self.provider, "reset", "--hard", original)
                self.write(self.provider, name, "changed\n")
                revision = self.commit(self.provider)
                self.set_source(revision)
                with self.assertRaisesRegex(ValueError, "require a full release"):
                    self.prepare()

    def test_dirty_and_ignored_runtime_inputs_are_rejected(self):
        self.write(self.provider, "lib/auth.dart", "unrecorded\n")
        with self.assertRaisesRegex(ValueError, "unrecorded"):
            self.prepare()
        self.git(self.provider, "checkout", "--", "lib/auth.dart")
        self.write(self.provider, "lib/injected.dart", "ignored\n")
        with self.assertRaisesRegex(ValueError, "ignored provider input"):
            self.prepare()

    def test_registered_baseline_and_source_pin_must_match(self):
        self.manifest["provider_sha"] = "a" * 40
        with self.assertRaisesRegex(ValueError, "registered release"):
            self.prepare()
        self.manifest["provider_sha"] = self.provider_baseline
        self.git(self.provider, "checkout", "--detach", self.provider_baseline)
        with self.assertRaisesRegex(ValueError, "approved source pin"):
            self.prepare()

    def test_provider_baseline_must_be_an_ancestor(self):
        self.git(self.provider, "checkout", "--orphan", "unrelated")
        self.write(self.provider, "lib/auth.dart", "unrelated\n")
        self.provider_source = self.commit(self.provider)
        self.set_source(self.provider_source)
        with self.assertRaisesRegex(ValueError, "must be an ancestor"):
            self.prepare()

    def test_receipt_tampering_is_rejected_against_source_pin_and_checkout(self):
        entries, receipt = self.materialize()
        for field, value in (("source_sha", "a" * 40), ("public_source_sha", "b" * 40)):
            altered = copy.deepcopy(receipt)
            altered["provider_projection"][field] = value
            with self.subTest(field=field), self.assertRaisesRegex(ValueError, "approved pin"):
                provider.verify_receipt(self.output, self.manifest, altered)
        altered = copy.deepcopy(receipt)
        altered["provider_projection"]["source_tree_sha"] = "c" * 40
        data = {key: value for key, value in altered["provider_projection"].items() if key != "projection_sha256"}
        altered["provider_projection"]["projection_sha256"] = hashlib.sha256(json.dumps(data, sort_keys=True, separators=(",", ":")).encode()).hexdigest()
        with self.assertRaisesRegex(ValueError, "combined projection identity"):
            provider.verify_receipt(self.output, self.manifest, altered)
        _, combined = public.projection(self.output, self.baseline, self.source, altered["provider_projection"])
        altered["projection_sha256"] = combined["projection_sha256"]
        with self.assertRaisesRegex(ValueError, "validated projection receipt"):
            provider.verify_workspace(self.output, self.manifest, altered)
        (self.output / provider.CHECKOUT / "lib/auth.dart").write_text("drift")
        with self.assertRaisesRegex(ValueError, "unrecorded"):
            public.verify_worktree(self.output, entries, receipt, self.manifest)

    def test_provider_identity_participates_in_public_projection_digest(self):
        identity = self.prepare()
        _, receipt = public.projection(self.app, self.baseline, self.source, identity)
        altered = copy.deepcopy(identity)
        altered["source_tree_sha"] = "a" * 40
        _, changed = public.projection(self.app, self.baseline, self.source, altered)
        self.assertNotEqual(receipt["projection_sha256"], changed["projection_sha256"])

    def test_legacy_without_a_registered_provider_retains_existing_behavior(self):
        manifest = {"source_sha": self.source, "provider_sha": None}
        selected = provider.request(self.app, self.source, self.source, manifest)
        self.assertEqual(selected, {"repository": "", "ref": "", "changed": False})

    def test_unchanged_provider_retains_strict_baseline_verification(self):
        self.git(self.provider, "checkout", "--detach", self.provider_baseline)
        self.set_source(self.provider_baseline)
        self.assertIsNone(self.prepare())
        entries, receipt = public.projection(self.app, self.baseline, self.source)
        public.materialize(self.app, self.output, entries, receipt)
        provider.materialize(self.provider, self.output, self.provider_baseline)
        self.assertNotIn("provider_projection", receipt)
        public.verify_worktree(self.output, entries, receipt, self.manifest)
        release_manifest.verify_native_config(self.output, self.manifest)


if __name__ == "__main__":
    unittest.main()
