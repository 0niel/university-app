import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("release_manifest", ROOT / "tool/release_manifest.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ReleaseManifestTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        environment = patch.dict(os.environ, {
            "GITHUB_REPOSITORY": "sample/mobile",
            "GITHUB_REF": "refs/heads/master",
            "RUNNER_TEMP": str(self.root / "configuration"),
        })
        environment.start()
        self.addCleanup(environment.stop)
        self.write("configuration/firebase.json", b'{"project":"fixture","apps":{"ios":"bundle.fixture"}}')
        self.write("configuration/university.json", b'{"name":"Fixture University","features":["schedule","news"]}')

    def manifest(self, platform="ios", kind="release"):
        evidence = {
            "kind": kind, "workflow_path": MODULE.PRODUCERS[platform],
            "run_id": 7301, "run_attempt": 2, "head_sha": "a" * 40,
            "source_ref": "refs/heads/master", "signing_sha": "a" * 40,
        }
        if kind == "legacy":
            evidence.update(
                signing_workflow=MODULE.REGISTRAR, signing_sha="b" * 40,
                registration_run_id=8701, registration_run_attempt=1,
                missing_prepared_inputs=list(MODULE.GENERATED[platform]),
            )
        return {
            "schema_version": 1, "repository": "sample/mobile",
            "source_sha": "a" * 40, "source_tree": "c" * 40,
            "platform": platform, "app_id": "12345678-1234-4321-8765-123456789abc",
            "release_version": "83.27.41-rc.9+7021.8", "release_id": 6401,
            "flutter_version": "7.12.3", "flutter_revision": "d" * 40,
            "target": "lib/main/main_production.dart",
            "flavor": "production" if platform == "android" else None,
            "build_inputs": {name: "e" * 64 for name in MODULE.GENERATED[platform]} if kind == "release" else {},
            "configuration_inputs": MODULE.config_digests() if kind == "release" else {},
            "private_native_sha": "f" * 40 if platform == "android" and kind == "release" else None,
            "artifacts": [{"name": "application.ipa" if platform == "ios" else "application.apk", "sha256": "1" * 64, "size": 512}],
            "evidence": evidence,
        }

    def write(self, name, content):
        target = self.root / name
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(content)
        return target

    def run_record(self, evidence):
        return {
            "path": evidence["workflow_path"], "head_branch": "master",
            "head_sha": evidence["head_sha"], "status": "completed", "conclusion": "success",
            "event": "workflow_dispatch", "run_attempt": evidence["run_attempt"],
            "repository": {"full_name": "sample/mobile"},
            "head_repository": {"full_name": "sample/mobile"},
        }

    def git(self, repo, *arguments):
        return subprocess.check_output(
            ["git", "-C", str(repo), *arguments], stderr=subprocess.PIPE,
            env={**os.environ, "GIT_CONFIG_NOSYSTEM": "1", "GIT_CONFIG_GLOBAL": os.devnull},
            timeout=15, text=True,
        ).strip()

    def private_checkout(self, relative="android/private/nfc-pass-android"):
        private = self.root / relative
        private.mkdir(parents=True)
        self.git(private, "init", "-q")
        self.git(private, "config", "user.name", "Fixture")
        self.git(private, "config", "user.email", "fixture@example.invalid")
        (private / "native.kt").write_text("original", encoding="utf-8")
        self.git(private, "add", ".")
        self.git(private, "commit", "-qm", "Fixture")
        return private, self.git(private, "rev-parse", "HEAD")

    def source_checkout(self):
        self.git(self.root, "init", "-q")
        self.git(self.root, "config", "user.name", "Fixture")
        self.git(self.root, "config", "user.email", "fixture@example.invalid")
        self.write("shorebird.yaml", b"app_id: 12345678-1234-4321-8765-123456789abc\nflavors:\n  production: 87654321-4321-1234-5678-cba987654321\n")
        self.git(self.root, "add", "shorebird.yaml")
        self.git(self.root, "commit", "-qm", "Fixture")
        return self.git(self.root, "rev-parse", "HEAD")

    def test_app_identity_comes_from_exact_source_and_platform(self):
        source = self.source_checkout()
        self.write("shorebird.yaml", b"app_id: changed-worktree-identity\n")
        self.assertEqual(MODULE.read_app_id(self.root, source, "ios"), "12345678-1234-4321-8765-123456789abc")
        self.assertEqual(MODULE.read_app_id(self.root, source, "android"), "87654321-4321-1234-5678-cba987654321")
        self.write("shorebird.yaml", b"app_id: 12345678-1234-4321-8765-123456789abc\napp_id: 87654321-4321-1234-5678-cba987654321\n")
        self.git(self.root, "add", "shorebird.yaml")
        self.git(self.root, "commit", "-qm", "Ambiguous fixture")
        with self.assertRaises(ValueError):
            MODULE.read_app_id(self.root, self.git(self.root, "rev-parse", "HEAD"), "ios")

    def test_legacy_private_native_pin_is_read_from_original_producer_commit(self):
        self.source_checkout()
        workflow = MODULE.PRODUCERS["android"]
        original = (
            "jobs:\n  release:\n    steps:\n"
            "      - uses: actions/checkout@fixture\n"
            "        with:\n"
            "          path: android/private/nfc-pass-android\n"
            "          ref: " + "b" * 40 + "\n"
        )
        self.write(workflow, original.encode())
        self.git(self.root, "add", workflow)
        self.git(self.root, "commit", "-qm", "Pinned checkout fixture")
        source = self.git(self.root, "rev-parse", "HEAD")
        self.write(workflow, original.replace("b" * 40, "d" * 40).encode())
        self.assertEqual(MODULE.read_private_native_ref(self.root, source), "b" * 40)
        for contents in (original.replace("b" * 40, "master"), original + original,
                         original.replace("android/private/nfc-pass-android", "somewhere/else")):
            self.write(workflow, contents.encode())
            self.git(self.root, "add", workflow)
            self.git(self.root, "commit", "-qm", "Invalid checkout fixture")
            with self.subTest(contents=contents), self.assertRaises(ValueError):
                MODULE.read_private_native_ref(self.root, self.git(self.root, "rev-parse", "HEAD"))

    def test_build_manifest_captures_exact_source_artifact_and_generated_bytes(self):
        source = self.source_checkout()
        expected = self.manifest()
        evidence = {**expected["evidence"], "head_sha": source, "signing_sha": source}
        for name in MODULE.GENERATED["ios"]:
            self.write(name, (name + " generated").encode())
        artifact = self.write("artifacts/application.ipa", b"fixture release binary")
        live = {
            "id": expected["release_id"], "app_id": expected["app_id"],
            "version": expected["release_version"], "flutter_revision": expected["flutter_revision"],
            "flutter_version": expected["flutter_version"], "platform_statuses": {"ios": "active"},
        }
        args = dict(repo=self.root, platform="ios", release_version=expected["release_version"],
                    source_sha=source, artifact_dir=artifact.parent, evidence=evidence)
        manifest = MODULE.build_manifest(**args, live_release=live)
        self.assertEqual(manifest["source_sha"], source)
        self.assertEqual(manifest["source_tree"], self.git(self.root, "rev-parse", source + "^{tree}"))
        self.assertEqual(manifest["artifacts"], [{"name": artifact.name, "sha256": MODULE.sha256(artifact), "size": artifact.stat().st_size}])
        self.assertEqual(manifest["build_inputs"], {name: MODULE.sha256(self.root / name) for name in MODULE.GENERATED["ios"]})
        for field, value in (("app_id", "other"), ("version", "91.1.1+1"), ("platform_statuses", {"ios": "inactive"})):
            with self.subTest(field=field), self.assertRaises(ValueError):
                MODULE.build_manifest(**args, live_release={**live, field: value})

    def test_private_directory_cannot_inherit_parent_repository_identity(self):
        source = self.source_checkout()
        manifest = self.manifest("android")
        manifest["private_native_sha"] = source
        (self.root / "android/private/nfc-pass-android").mkdir(parents=True)
        for name in manifest["build_inputs"]:
            manifest["build_inputs"][name] = MODULE.sha256(self.write(name, name.encode()))
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)

    def test_arbitrary_future_versions_are_platform_scoped(self):
        for platform in MODULE.PRODUCERS:
            manifest = self.manifest(platform)
            self.assertIs(MODULE.validate_manifest(manifest), manifest)
            self.assertEqual(MODULE.registry_tag(platform, manifest["release_version"]),
                             f"shorebird-{platform}-83.27.41-rc.9+7021.8")

    def test_schema_and_identity_fail_closed(self):
        for field, value in [
            ("schema_version", True), ("schema_version", 2), ("platform", "web"),
            ("source_sha", "main"), ("source_tree", "a" * 39),
            ("flutter_revision", "a" * 41), ("release_id", True),
            ("release_id", 0), ("release_version", "83.2+4\ncommand"),
            ("repository", "sample/mobile/extra"), ("target", "lib/main_dev.dart"),
            ("app_id", "not-an-app-id"), ("flavor", "production"),
        ]:
            with self.subTest(field=field, value=value):
                manifest = self.manifest()
                manifest[field] = value
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(manifest)

    def test_malformed_container_types_are_validation_errors(self):
        values = [None, [], 1]
        for field in ("evidence", "artifacts", "build_inputs"):
            for value in (None, [], "invalid", 7):
                manifest = self.manifest()
                manifest[field] = value
                values.append(manifest)
        manifest = self.manifest()
        manifest["artifacts"] = [None]
        values.append(manifest)
        for value in values:
            with self.subTest(value=value):
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(value)

    def test_artifact_paths_digests_sizes_and_duplicates_are_rejected(self):
        for name in ("..", ".", "../app.ipa", "/app.ipa", "a\\b.ipa", "C:app.ipa", ""):
            with self.subTest(name=name):
                manifest = self.manifest()
                manifest["artifacts"][0]["name"] = name
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(manifest)
        for key, value in (("sha256", "bad"), ("size", True), ("size", 0), ("size", -1)):
            with self.subTest(key=key, value=value):
                manifest = self.manifest()
                manifest["artifacts"][0][key] = value
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(manifest)
        manifest = self.manifest()
        manifest["artifacts"] *= 2
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)

    def test_safe_path_rejects_traversal_and_directory_aliases(self):
        for name in ("..", "../escape", "/absolute", "C:/absolute", "a\\b", "", "."):
            with self.subTest(name=name):
                with self.assertRaises(ValueError):
                    MODULE.safe_path(self.root, name)

    def test_untrusted_evidence_is_rejected(self):
        for key, value in (
            ("workflow_path", ".github/workflows/unknown.yml"),
            ("source_ref", "refs/heads/feature"), ("run_id", True),
            ("run_attempt", 0), ("head_sha", "master"),
            ("signing_workflow", MODULE.REGISTRAR), ("signing_sha", "bad"),
        ):
            with self.subTest(key=key):
                manifest = self.manifest()
                manifest["evidence"][key] = value
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(manifest)

    def test_missing_inputs_require_an_exact_legacy_declaration(self):
        MODULE.validate_manifest(self.manifest(kind="legacy"))
        for value in (None, True, "historical", ["unknown.file"], [], [MODULE.GENERATED["ios"][0]]):
            with self.subTest(value=value):
                manifest = self.manifest(kind="legacy")
                manifest["evidence"]["missing_prepared_inputs"] = value
                with self.assertRaises(ValueError):
                    MODULE.validate_manifest(manifest)
        manifest = self.manifest()
        manifest["build_inputs"].pop("ios/Podfile.lock")
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)

    def test_legacy_registration_identity_is_required(self):
        for field in ("registration_run_id", "registration_run_attempt", "signing_sha"):
            manifest = self.manifest(kind="legacy")
            del manifest["evidence"][field]
            with self.subTest(field=field), self.assertRaises(ValueError):
                MODULE.validate_manifest(manifest)

    def test_partial_legacy_input_evidence_lists_only_actual_omissions(self):
        manifest = self.manifest(kind="legacy")
        manifest["build_inputs"]["ios/Podfile.lock"] = "e" * 64
        manifest["evidence"]["missing_prepared_inputs"] = ["ios/Flutter/Tenant.xcconfig"]
        MODULE.validate_manifest(manifest)
        manifest["evidence"]["missing_prepared_inputs"].append("ios/Podfile.lock")
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)

    def test_provider_release_records_lock_and_requires_it(self):
        manifest = self.manifest()
        manifest["provider_sha"] = "f" * 40
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)
        manifest["build_inputs"]["pubspec.lock"] = "e" * 64
        self.assertIs(MODULE.validate_manifest(manifest), manifest)
        manifest["provider_sha"] = "master"
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)
        legacy = self.manifest(kind="legacy")
        legacy["provider_sha"] = None
        MODULE.validate_manifest(legacy)

    def test_build_manifest_records_provider_checkout_and_resolved_lock(self):
        source = self.source_checkout()
        expected = self.manifest()
        evidence = {**expected["evidence"], "head_sha": source, "signing_sha": source}
        for name in MODULE.GENERATED["ios"]:
            self.write(name, (name + " generated").encode())
        lock = self.write("pubspec.lock", b"packages: {}\n")
        artifact = self.write("artifacts/application.ipa", b"fixture release binary")
        live = {
            "id": expected["release_id"], "app_id": expected["app_id"],
            "version": expected["release_version"], "flutter_revision": expected["flutter_revision"],
            "flutter_version": expected["flutter_version"], "platform_statuses": {"ios": "active"},
        }
        args = dict(repo=self.root, platform="ios", release_version=expected["release_version"],
                    source_sha=source, artifact_dir=artifact.parent, evidence=evidence)
        manifest = MODULE.build_manifest(**args, live_release=live)
        self.assertIsNone(manifest["provider_sha"])
        self.assertNotIn("pubspec.lock", manifest["build_inputs"])
        provider, sha = self.private_checkout(MODULE.PROVIDER)
        manifest = MODULE.build_manifest(**args, live_release=live)
        self.assertEqual(manifest["provider_sha"], sha)
        self.assertEqual(manifest["build_inputs"]["pubspec.lock"], MODULE.sha256(lock))
        (provider / "injected.dart").write_text("changed", encoding="utf-8")
        with self.assertRaises(ValueError):
            MODULE.build_manifest(**args, live_release=live)

    def test_provider_checkout_must_match_the_release(self):
        manifest = self.manifest()
        provider, manifest["provider_sha"] = self.private_checkout(MODULE.PROVIDER)
        for name in manifest["build_inputs"]:
            manifest["build_inputs"][name] = MODULE.sha256(self.write(name, name.encode()))
        manifest["build_inputs"]["pubspec.lock"] = MODULE.sha256(self.write("pubspec.lock", b"resolved"))
        MODULE.verify_native_config(self.root, manifest)
        self.write("pubspec.lock", b"different resolution")
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)
        self.write("pubspec.lock", b"resolved")
        (provider / "native.kt").write_text("changed", encoding="utf-8")
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)
        self.git(provider, "checkout", "--", "native.kt")
        manifest["provider_sha"] = "0" * 40
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)

    def test_resolve_restores_the_dart_lock_and_publishes_provider_output(self):
        manifest = self.manifest()
        manifest["provider_sha"] = "f" * 40
        manifest["build_inputs"]["ios/Podfile.lock"] = hashlib.sha256(b"lock").hexdigest()
        manifest["build_inputs"]["pubspec.lock"] = hashlib.sha256(b"lock").hexdigest()
        calls = []
        output = self.root / "resolved/release-manifest.json"
        workflow_output = self.root / "github-output"
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, calls)), patch.object(MODULE, "api", return_value=self.run_record(manifest["evidence"])):
            MODULE.resolve("ios", manifest["release_version"], output, workflow_output)
        downloads = [call[call.index("--pattern") + 1] for call in calls if call[:3] == ("gh", "release", "download")]
        self.assertEqual(downloads, ["release-manifest.json", "Podfile.lock", "pubspec.lock"])
        self.assertEqual((output.parent / "pubspec.lock").read_bytes(), b"lock")
        self.assertIn("provider_sha=" + "f" * 40, workflow_output.read_text())
        manifest["provider_sha"] = None
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, [])), patch.object(MODULE, "api", return_value=self.run_record(manifest["evidence"])):
            MODULE.resolve("ios", manifest["release_version"], output, workflow_output)
        self.assertIn("provider_sha=\n", workflow_output.read_text())

    def test_publish_requires_the_recorded_dart_lock_asset(self):
        manifest = self.manifest("android")
        manifest["provider_sha"] = "f" * 40
        manifest["build_inputs"]["pubspec.lock"] = hashlib.sha256(b"resolved").hexdigest()
        path = self.root / "release-manifest.json"
        MODULE.write_manifest(path, manifest)
        with patch.object(MODULE, "run") as run:
            with self.assertRaises(ValueError):
                MODULE.publish(path, self.root)
            run.assert_not_called()
        self.write("pubspec.lock", b"resolved")
        with patch.object(MODULE.subprocess, "run", return_value=subprocess.CompletedProcess([], 1)), patch.object(MODULE, "run") as run:
            MODULE.publish(path, self.root)
        created = run.call_args.args
        self.assertEqual(created[:3], ("gh", "release", "create"))
        self.assertIn(str(self.root / "pubspec.lock"), created)

    def test_android_release_requires_private_native_identity(self):
        manifest = self.manifest("android")
        manifest["private_native_sha"] = None
        with self.assertRaises(ValueError):
            MODULE.validate_manifest(manifest)

    def test_build_input_digests_are_constrained(self):
        for inputs in ({"../../outside": "e" * 64}, {"ios/Podfile.lock": "e" * 63}, {"ios/Podfile.lock": 7}):
            manifest = self.manifest()
            manifest["build_inputs"].update(inputs)
            with self.subTest(inputs=inputs), self.assertRaises(ValueError):
                MODULE.validate_manifest(manifest)

    def test_canonical_configuration_is_required_and_bounded(self):
        for configs in (None, {}, {"firebase.json": "e" * 64}, {"firebase.json": "e" * 64, "university.json": "invalid"},
                        {"firebase.json": "e" * 64, "university.json": "e" * 64, "extra": "e" * 64}):
            manifest = self.manifest()
            manifest["configuration_inputs"] = configs
            with self.subTest(configs=configs), self.assertRaises(ValueError):
                MODULE.validate_manifest(manifest)

    def test_canonical_configuration_ignores_formatting_but_detects_value_drift(self):
        manifest = self.manifest()
        for name in manifest["build_inputs"]:
            manifest["build_inputs"][name] = MODULE.sha256(self.write(name, name.encode()))
        before = MODULE.config_digests()
        self.write("configuration/firebase.json", b'{\n "apps": {"ios": "bundle.fixture"}, "project": "fixture"\n}\n')
        self.write("configuration/university.json", b'{ "features" : [ "schedule", "news" ], "name" : "Fixture University" }')
        self.assertEqual(MODULE.config_digests(), before)
        MODULE.verify_native_config(self.root, manifest)
        self.write("configuration/firebase.json", b'{"apps":{"ios":"different.bundle"},"project":"fixture"}')
        self.assertNotEqual(MODULE.config_digests()["firebase.json"], before["firebase.json"])
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)

    def test_verify_run_checks_success_origin_and_recorded_attempt(self):
        evidence = self.manifest()["evidence"]
        original = self.run_record(evidence)
        with patch.object(MODULE, "api", return_value=original):
            MODULE.verify_run("sample/mobile", evidence)
        for key, value in (
            ("conclusion", "failure"), ("status", "in_progress"),
            ("event", "pull_request"), ("head_branch", "feature"),
            ("head_sha", "b" * 40), ("run_attempt", 1),
            ("path", MODULE.REGISTRAR),
            ("repository", {"full_name": "attacker/mobile"}),
            ("head_repository", {"full_name": "attacker/mobile"}),
        ):
            with self.subTest(key=key), patch.object(MODULE, "api", return_value={**original, key: value}):
                with self.assertRaises(ValueError):
                    MODULE.verify_run("sample/mobile", evidence)

    def test_successful_same_head_rerun_preserves_original_attested_attempt(self):
        evidence = self.manifest()["evidence"]
        record = {**self.run_record(evidence), "run_attempt": evidence["run_attempt"] + 1}
        with patch.object(MODULE, "api", return_value=record):
            MODULE.verify_run("sample/mobile", evidence)
        for changes in ({"conclusion": "failure"}, {"head_sha": "b" * 40}):
            with self.subTest(changes=changes), patch.object(MODULE, "api", return_value={**record, **changes}):
                with self.assertRaises(ValueError):
                    MODULE.verify_run("sample/mobile", evidence)

    def test_live_release_mismatches_fail(self):
        manifest = self.manifest()
        live = {
            "id": manifest["release_id"], "app_id": manifest["app_id"],
            "version": manifest["release_version"], "flutter_revision": manifest["flutter_revision"],
            "flutter_version": manifest["flutter_version"], "platform_statuses": {"ios": "active"},
        }
        with patch.object(MODULE, "load_shorebird_release", return_value=live):
            MODULE.verify_live(manifest)
        for key, value in (("id", 6402), ("app_id", "other"), ("version", "84.0.0+1"),
                           ("flutter_revision", "b" * 40), ("flutter_version", "8.0.0"),
                           ("platform_statuses", {"ios": "inactive"})):
            with self.subTest(key=key), patch.object(MODULE, "load_shorebird_release", return_value={**live, key: value}):
                with self.assertRaises(ValueError):
                    MODULE.verify_live(manifest)

    def test_generated_input_drift_or_missing_file_is_rejected(self):
        manifest = self.manifest()
        for name in manifest["build_inputs"]:
            path = self.write(name, name.encode())
            manifest["build_inputs"][name] = MODULE.sha256(path)
        MODULE.verify_native_config(self.root, manifest)
        path.write_bytes(b"different generated configuration")
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)
        path.unlink()
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)

    def test_private_native_checkout_must_match_and_be_clean(self):
        manifest = self.manifest("android")
        private, manifest["private_native_sha"] = self.private_checkout()
        for name in manifest["build_inputs"]:
            manifest["build_inputs"][name] = MODULE.sha256(self.write(name, name.encode()))
        MODULE.verify_native_config(self.root, manifest)
        for name in ("native.kt", "injected.kt"):
            with self.subTest(name=name):
                path = private / name
                path.write_text("changed", encoding="utf-8")
                with self.assertRaises(ValueError):
                    MODULE.verify_native_config(self.root, manifest)
                if name == "native.kt":
                    self.git(private, "checkout", "--", name)
                else:
                    path.unlink()
        manifest["private_native_sha"] = "0" * 40
        with self.assertRaises(ValueError):
            MODULE.verify_native_config(self.root, manifest)

    def resolver_run(self, manifest, calls, *, lock=b"lock", reject_attestation=False):
        def run(*args, **kwargs):
            calls.append(args)
            if args[:3] == ("gh", "release", "download"):
                target = Path(args[args.index("--dir") + 1])
                name = args[args.index("--pattern") + 1]
                (target / name).write_bytes(json.dumps(manifest).encode() if name == "release-manifest.json" else lock)
            elif args[:3] == ("gh", "attestation", "verify") and reject_attestation:
                raise subprocess.CalledProcessError(1, args)
            return ""
        return run

    def test_resolve_pins_attestation_identity_and_publishes_outputs(self):
        manifest = self.manifest()
        manifest["build_inputs"]["ios/Podfile.lock"] = hashlib.sha256(b"lock").hexdigest()
        calls = []
        output = self.root / "resolved/release-manifest.json"
        workflow_output = self.root / "github-output"
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, calls)), patch.object(MODULE, "api", return_value=self.run_record(manifest["evidence"])):
            self.assertEqual(MODULE.resolve("ios", manifest["release_version"], output, workflow_output), manifest)
        attestation = next(call for call in calls if call[:3] == ("gh", "attestation", "verify"))
        for flag, value in (("--repo", "sample/mobile"), ("--signer-workflow", "sample/mobile/" + MODULE.PRODUCERS["ios"]),
                            ("--source-ref", "refs/heads/master"), ("--source-digest", "a" * 40)):
            self.assertEqual(attestation[attestation.index(flag) + 1], value)
        self.assertIn("--deny-self-hosted-runners", attestation)
        self.assertEqual((output.parent / "Podfile.lock").read_bytes(), b"lock")
        self.assertIn("manifest_sha256=" + MODULE.sha256(output), workflow_output.read_text())

    def test_resolve_rejects_unverified_attestation_without_output(self):
        manifest = self.manifest("android")
        output = self.root / "resolved/release-manifest.json"
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, [], reject_attestation=True)):
            with self.assertRaises(subprocess.CalledProcessError):
                MODULE.resolve("android", manifest["release_version"], output)
        self.assertFalse(output.exists())

    def test_resolve_bad_lock_does_not_replace_previous_output(self):
        manifest = self.manifest()
        output = self.write("resolved/release-manifest.json", b"previous verified result")
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, [], lock=b"tampered")), patch.object(MODULE, "api", return_value=self.run_record(manifest["evidence"])):
            with self.assertRaises(ValueError):
                MODULE.resolve("ios", manifest["release_version"], output)
        self.assertEqual(output.read_bytes(), b"previous verified result")

    def test_resolve_legacy_requires_both_producer_and_registrar(self):
        manifest = self.manifest(kind="legacy")
        output = self.root / "release-manifest.json"
        records = []
        def api(path):
            records.append(path)
            record = self.run_record(manifest["evidence"])
            if path.endswith("/8701"):
                record.update(path=MODULE.REGISTRAR, head_sha="b" * 40, run_attempt=1)
            return record
        calls = []
        with patch.object(MODULE, "run", side_effect=self.resolver_run(manifest, calls)), patch.object(MODULE, "api", side_effect=api):
            MODULE.resolve("ios", manifest["release_version"], output)
        self.assertEqual(records, ["repos/sample/mobile/actions/runs/7301", "repos/sample/mobile/actions/runs/8701"])
        attestation = next(call for call in calls if call[:3] == ("gh", "attestation", "verify"))
        self.assertEqual(attestation[attestation.index("--signer-workflow") + 1], "sample/mobile/" + MODULE.REGISTRAR)
        self.assertEqual(attestation[attestation.index("--source-digest") + 1], "b" * 40)

    def test_registry_is_idempotent_and_refuses_conflicting_replacement(self):
        manifest = self.manifest("android")
        path = self.root / "release-manifest.json"
        MODULE.write_manifest(path, manifest)
        for identical in (True, False):
            calls = []
            def download(*args):
                calls.append(args)
                directory = Path(args[args.index("--dir") + 1])
                (directory / path.name).write_bytes(path.read_bytes() if identical else b"different provenance")
                return ""
            with self.subTest(identical=identical), patch.object(MODULE.subprocess, "run", return_value=subprocess.CompletedProcess([], 0)), patch.object(MODULE, "run", side_effect=download):
                if identical:
                    MODULE.publish(path, self.root)
                else:
                    with self.assertRaisesRegex(ValueError, "write-once"):
                        MODULE.publish(path, self.root)
            self.assertTrue(all(call[:3] == ("gh", "release", "download") for call in calls))

    def test_registry_publication_requires_protected_repository(self):
        manifest = self.manifest("android")
        path = self.root / "release-manifest.json"
        MODULE.write_manifest(path, manifest)
        with patch.dict(os.environ, {"GITHUB_REF": "refs/heads/feature"}), patch.object(MODULE, "run") as run:
            with self.assertRaises(ValueError):
                MODULE.publish(path, self.root)
            run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
