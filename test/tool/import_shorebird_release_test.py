import hashlib
import copy
from contextlib import redirect_stderr, redirect_stdout
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


def automatic_origin():
    return {**origin("android"), "event": "workflow_run", "created_at": "2026-09-06T12:00:00Z",
        "repository": {"full_name": REPOSITORY, "id": 456, "owner": {"id": 789}}}


def apk_provenance(binary_digest):
    uri = f"https://github.com/{REPOSITORY}"
    workflow = f"{uri}/{MODULE.WORKFLOWS['android']}@refs/heads/master"
    invocation = f"{uri}/actions/runs/123/attempts/1"
    certificate = {
        "issuer": "https://token.actions.githubusercontent.com", "subjectAlternativeName": workflow,
        "buildSignerURI": workflow, "buildSignerDigest": SOURCE,
        "buildConfigURI": workflow, "buildConfigDigest": SOURCE,
        "sourceRepositoryURI": uri, "sourceRepositoryDigest": SOURCE,
        "sourceRepositoryRef": "refs/heads/master", "sourceRepositoryIdentifier": "456",
        "sourceRepositoryOwnerIdentifier": "789", "runnerEnvironment": "github-hosted",
        "buildTrigger": "workflow_run", "runInvocationURI": invocation,
    }
    statement = {
        "_type": "https://in-toto.io/Statement/v1", "predicateType": "https://slsa.dev/provenance/v1",
        "subject": [{"name": "release.apk", "digest": {"sha256": binary_digest}},
            {"name": "release.aab", "digest": {"sha256": "b" * 64}}],
        "predicate": {
            "buildDefinition": {
                "buildType": "https://actions.github.io/buildtypes/workflow/v1",
                "externalParameters": {"workflow": {"repository": uri,
                    "path": MODULE.WORKFLOWS["android"], "ref": "refs/heads/master"}},
                "internalParameters": {"github": {"event_name": "workflow_run"}},
                "resolvedDependencies": [{"uri": f"git+{uri}@refs/heads/master", "digest": {"gitCommit": SOURCE}}],
            },
            "runDetails": {"builder": {"id": workflow}, "metadata": {"invocationId": invocation}},
        },
    }
    return [{"verificationResult": {"signature": {"certificate": certificate}, "statement": statement}}]


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

    def test_automatic_origin_is_only_eligible_for_the_android_producer(self):
        self.assertEqual(MODULE.verify_run(automatic_origin(), REPOSITORY, 123, "android"), SOURCE)
        for mutation in ({"path": MODULE.WORKFLOWS["ios"]}, {"event": "pull_request"},
            {"head_branch": "feature"}, {"conclusion": "failure"}, {"head_repository": {"full_name": "fork/repo"}}):
            with self.subTest(mutation=mutation), self.assertRaises(ValueError):
                MODULE.verify_run({**automatic_origin(), **mutation}, REPOSITORY, 123, "android")

    def test_apk_signature_is_checked_before_matching_exact_certificate_identity(self):
        binary = self.root / "application.apk"
        binary.write_bytes(b"original APK")
        provenance = apk_provenance(MODULE.digest(binary))
        with patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, json.dumps(provenance).encode())) as execute:
            evidence = MODULE.verify_apk_attestation(binary, REPOSITORY, automatic_origin())
        self.assertEqual(evidence["sha256"], MODULE.digest(binary))
        self.assertTrue(evidence["invocation_uri"].endswith("/123/attempts/1"))
        arguments = execute.call_args.args[0]
        self.assertEqual(arguments[:4], ["gh", "attestation", "verify", str(binary)])
        for flag, value in (("--source-digest", SOURCE), ("--signer-digest", SOURCE),
            ("--source-ref", "refs/heads/master"), ("--repo", REPOSITORY)):
            self.assertEqual(arguments[arguments.index(flag) + 1], value)
        self.assertIn("--deny-self-hosted-runners", arguments)
        for key in provenance[0]["verificationResult"]["signature"]["certificate"]:
            changed = copy.deepcopy(provenance)
            changed[0]["verificationResult"]["signature"]["certificate"][key] = "wrong"
            with self.subTest(certificate_field=key), patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, json.dumps(changed).encode())), self.assertRaises(ValueError):
                MODULE.verify_apk_attestation(binary, REPOSITORY, automatic_origin())
        with patch.object(MODULE, "command", side_effect=ValueError("signature verification failed")), self.assertRaisesRegex(ValueError, "signature verification"):
            MODULE.verify_apk_attestation(binary, REPOSITORY, automatic_origin())

    def test_apk_statement_rejects_replayed_attempt_and_wrong_source_or_binary(self):
        binary = self.root / "application.apk"
        binary.write_bytes(b"APK")
        provenance = apk_provenance(MODULE.digest(binary))
        mutations = [
            lambda value: value.update(predicateType="other"),
            lambda value: value["subject"][0]["digest"].update(sha256="0" * 64),
            lambda value: value["predicate"]["buildDefinition"]["resolvedDependencies"][0]["digest"].update(gitCommit="b" * 40),
            lambda value: value["predicate"]["buildDefinition"]["externalParameters"]["workflow"].update(ref="refs/pull/1/merge"),
            lambda value: value["predicate"]["runDetails"]["metadata"].update(invocationId=f"https://github.com/{REPOSITORY}/actions/runs/123/attempts/2"),
        ]
        for mutate in mutations:
            changed = copy.deepcopy(provenance)
            mutate(changed[0]["verificationResult"]["statement"])
            with patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, json.dumps(changed).encode())), self.assertRaises(ValueError):
                MODULE.verify_apk_attestation(binary, REPOSITORY, automatic_origin())
        for changed in ([], provenance * 2, {"verificationResult": provenance[0]}):
            with patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, json.dumps(changed).encode())), self.assertRaises(ValueError):
                MODULE.verify_apk_attestation(binary, REPOSITORY, automatic_origin())

    def checkout_fixture(self, source=SOURCE):
        jobs = [{"id": index, "name": name, "run_id": 123, "run_attempt": 1, "head_sha": SOURCE,
            "conclusion": "success", "steps": [{"name": "Check out repository", "conclusion": "success",
                "started_at": "2026-09-06T11:00:00Z", "completed_at": "2026-09-06T11:00:01Z"}]}
            for index, name in enumerate(("prepare", "Android beta"), 10)]

        def logs(arguments, **kwargs):
            prefix = "2026-09-06T11:00:00.9999999Z "
            output = "\n".join(prefix + line for line in (f"##[group]Run actions/checkout@{'c' * 40}", f"  ref: {source}",
                "[command]/usr/bin/git log -1 --format=%H", source))
            return subprocess.CompletedProcess(arguments, 0, output.encode())

        return jobs, logs

    def test_actual_checkout_must_match_in_both_exact_attempt_jobs(self):
        jobs, logs = self.checkout_fixture()
        with patch.object(MODULE, "api", return_value={"jobs": jobs}) as requests, patch.object(MODULE, "command", side_effect=logs) as execute:
            evidence = MODULE.verify_automatic_checkouts(REPOSITORY, automatic_origin())
        self.assertEqual([entry["id"] for entry in evidence], [10, 11])
        self.assertIn("/attempts/1/jobs?", requests.call_args.args[0])
        self.assertEqual(execute.call_count, 2)
        self.assertEqual([call.args[0] for call in execute.call_args_list], [
            ["gh", "api", f"repos/{REPOSITORY}/actions/jobs/{job_id}/logs"] for job_id in (10, 11)
        ])
        for mutation in ({"run_attempt": 2}, {"run_id": 124}, {"head_sha": "b" * 40},
            {"conclusion": "failure"}, {"steps": []}):
            changed = [{**jobs[0], **mutation}, jobs[1]]
            with patch.object(MODULE, "api", return_value={"jobs": changed}), self.assertRaises(ValueError):
                MODULE.verify_automatic_checkouts(REPOSITORY, automatic_origin())
        for changed in (jobs[:1], jobs + [jobs[0]]):
            with patch.object(MODULE, "api", return_value={"jobs": changed}), self.assertRaises(ValueError):
                MODULE.verify_automatic_checkouts(REPOSITORY, automatic_origin())
        jobs, logs = self.checkout_fixture("b" * 40)
        with patch.object(MODULE, "api", return_value={"jobs": jobs}), patch.object(MODULE, "command", side_effect=logs), self.assertRaisesRegex(ValueError, "checkout differs"):
            MODULE.verify_automatic_checkouts(REPOSITORY, automatic_origin())

    def test_raw_checkout_logs_ignore_adjacent_native_checkout_in_the_same_second(self):
        step = {"started_at": "2026-09-06T12:24:04Z", "completed_at": "2026-09-06T12:24:07Z"}
        entries = [
            ("03.9999999", "[command]/usr/bin/git log -1 --format=%H"),
            ("03.9999999", "b" * 40),
            ("04.8364730", f"##[group]Run actions/checkout@{'c' * 40}"),
            ("04.8365565", f"  ref: {SOURCE}"),
            ("04.9365565", "##[endgroup]"),
            ("05.0000000", "##[group]Getting Git version info"),
            ("07.7937431", "[command]/usr/bin/git log -1 --format=%H"),
            ("07.7962843", SOURCE),
            ("07.9367373", f"##[group]Run actions/checkout@{'c' * 40}"),
            ("07.9368310", f"  ref: {'d' * 40}"),
            ("09.0143245", "[command]/usr/bin/git log -1 --format=%H"),
            ("09.0150000", "d" * 40),
        ]
        output = "\ufeff" + "\r\n".join(f"2026-09-06T12:24:{date}Z {message}" for date, message in entries)
        lines = MODULE.checkout_log_lines(output.encode(), step)
        self.assertIn(SOURCE, lines)
        self.assertNotIn("b" * 40, lines)
        self.assertNotIn(f"  ref: {'d' * 40}", lines)
        self.assertNotIn("d" * 40, lines)

    def test_raw_checkout_proof_requires_the_action_and_source_inside_the_api_step(self):
        jobs, logs = self.checkout_fixture()
        original = logs([]).stdout
        mutations = [
            original.replace(b"actions/checkout@", b"actions/other@"),
            original.replace(b"11:00:00.9999999", b"11:00:02.0000000"),
            original.replace(b"[command]/usr/bin/git log -1 --format=%H", b"unrelated output"),
            original.replace(SOURCE.encode(), b"b" * 40),
            original + b"\n2026-09-06T11:00:01.1000000Z   ref: " + SOURCE.encode(),
            original + b"\n2026-09-06T11:00:01.1000000Z [command]/usr/bin/git log -1 --format=%H\n2026-09-06T11:00:01.2000000Z " + SOURCE.encode(),
            original.replace(b"11:00:00.9999999Z [command]", b"11:00:02.0000000Z [command]"),
        ]
        for output in mutations:
            with patch.object(MODULE, "api", return_value={"jobs": jobs}), patch.object(MODULE, "command", return_value=subprocess.CompletedProcess([], 0, output)), self.assertRaises(ValueError):
                MODULE.verify_automatic_checkouts(REPOSITORY, automatic_origin())
        for mutation in ({"started_at": None}, {"completed_at": "2026-09-06T10:59:59Z"}):
            step = {**jobs[0]["steps"][0], **mutation}
            with self.assertRaises(ValueError):
                MODULE.checkout_log_lines(original, step)

    def test_source_ci_requires_successful_master_push_before_release(self):
        ci = {**origin(), "id": 98, "path": ".github/workflows/main.yml", "event": "push",
            "updated_at": "2026-09-06T11:59:59Z"}
        with patch.object(MODULE, "api", return_value={"workflow_runs": [ci]}):
            self.assertEqual(MODULE.verify_source_ci(REPOSITORY, automatic_origin()), {"run_id": 98, "run_attempt": 1})
        for mutation in ({"path": ".github/workflows/other.yml"}, {"event": "pull_request"},
            {"head_sha": "b" * 40}, {"head_branch": "feature"}, {"conclusion": "failure"},
            {"head_repository": {"full_name": "fork/repo"}}, {"updated_at": "2026-09-06T12:00:01Z"}):
            with self.subTest(mutation=mutation), patch.object(MODULE, "api", return_value={"workflow_runs": [{**ci, **mutation}]}), self.assertRaises(ValueError):
                MODULE.verify_source_ci(REPOSITORY, automatic_origin())
        for candidates in ([], [ci, ci]):
            with patch.object(MODULE, "api", return_value={"workflow_runs": candidates}), self.assertRaises(ValueError):
                MODULE.verify_source_ci(REPOSITORY, automatic_origin())

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

    def import_fixture(self, *, corrupt=False, live_mutation=None, schema=False, automatic=False, report=None):
        platform = "android" if automatic else "ios"
        data = zip_bytes([("release.apk", b"original APK")]) if automatic else zip_bytes([("release.ipa", ipa_bytes())])
        artifact = self.artifact(data, platform)
        app_id = "21c47e68-a64f-49c1-af6e-4a406dfe266f"
        live = {"id": 789, "app_id": app_id, "version": "5.2.1+1006601" if automatic else "5.2.1+2439.17.57", "platform_statuses": {platform: "active"}, "flutter_version": "3.44.2", "flutter_revision": "d" * 40, **(live_mutation or {})}
        built = {}

        def build_manifest(**values):
            built.update(values)
            return {"source_sha": values["source_sha"], "evidence": values["evidence"], "build_inputs": {}}

        helper = types.SimpleNamespace(
            GENERATED={"ios": ("ios/Tenant.xcconfig", "ios/Podfile.lock"), "android": ("android/app/google-services.json", "android/tenant.properties")},
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
            helper.read_private_native_ref = lambda *args: "e" * 40

        def command(arguments, **kwargs):
            if arguments[0] == "gh":
                kwargs["stdout"].write(b"corrupt" if corrupt else data)
            return subprocess.CompletedProcess(arguments, 0)

        with patch.dict(sys.modules, {"release_manifest": helper}), patch.dict(os.environ, {"GITHUB_REPOSITORY": REPOSITORY, "GITHUB_SHA": "b" * 40, "GITHUB_RUN_ID": "999", "GITHUB_RUN_ATTEMPT": "2"}), patch.object(MODULE, "api", return_value=automatic_origin() if automatic else origin()), patch.object(MODULE, "find_artifact", return_value=artifact), patch.object(MODULE, "command", side_effect=command), patch.object(MODULE, "binary_identity", return_value=live["version"] if not live_mutation else "5.2.1+2439.17.57"):
            manifest = MODULE.import_release(repo=self.root, repository=REPOSITORY, run_id=123, platform=platform, output_dir=self.root / "registry", report=report)
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

    def test_automatic_import_requires_all_evidence_and_keeps_missing_inputs_explicit(self):
        stages = []
        with patch.object(MODULE, "verify_apk_attestation", return_value={"sha256": "d" * 64}) as attest, patch.object(MODULE, "verify_automatic_checkouts", return_value=[{"id": 10}]) as checkout, patch.object(MODULE, "verify_source_ci", return_value={"run_id": 98}) as ci:
            manifest, _ = self.import_fixture(automatic=True, schema=True, report=stages.append)
        self.assertEqual(attest.call_count, 1)
        self.assertEqual(checkout.call_count, 1)
        self.assertEqual(ci.call_count, 1)
        self.assertEqual(manifest["source_sha"], SOURCE)
        self.assertEqual(manifest["evidence"]["automatic_provenance"], {
            "sha256": "d" * 64, "checkout_jobs": [{"id": 10}], "source_ci": {"run_id": 98},
        })
        self.assertEqual(manifest["build_inputs"], {})
        self.assertEqual(manifest["configuration_inputs"], {})
        self.assertEqual(manifest["private_native_sha"], "e" * 40)
        self.assertEqual(manifest["evidence"]["missing_prepared_inputs"],
            ["android/app/google-services.json", "android/tenant.properties"])
        self.assertEqual(stages, ["release origin", "source ancestry", "artifact metadata", "output directory",
            "artifact download", "artifact digest", "binary extraction", "binary identity", "APK attestation",
            "producer checkouts", "source CI", "application identity", "live Shorebird release",
            "manifest construction", "manifest validation and write"])

    def test_command_diagnostics_never_include_raw_provider_output_or_arguments(self):
        secret = "private-token-and-provider-payload"
        for stderr, expected in (
            (f"HTTP 403 {secret}", "authentication or permissions"),
            (f"rate limit {secret}", "rate limit"),
            (f"TLS timeout {secret}", "network or provider availability"),
            (f"unknown flag {secret}", "unsupported command interface"),
            (f"failed to verify {secret}", "attestation verification"),
            (secret, "command failure"),
        ):
            result = subprocess.CompletedProcess([], 17, stdout=secret.encode(), stderr=stderr.encode())
            with patch.object(MODULE.subprocess, "run", return_value=result), self.assertRaises(MODULE.RegistrationError) as error:
                MODULE.command(["gh", "api", secret], stdout=subprocess.PIPE)
            self.assertIn(f"exit 17; {expected}", str(error.exception))
            self.assertNotIn(secret, str(error.exception))
        with patch.object(MODULE.subprocess, "run", return_value=result), self.assertRaises(MODULE.RegistrationError) as error:
            MODULE.command([f"/private/{secret}", secret], stdout=subprocess.PIPE)
        self.assertIn("binary inspector", str(error.exception))
        self.assertNotIn(secret, str(error.exception))

    def test_cli_reports_stage_and_redacts_external_exception_messages(self):
        secret = "private-token-and-provider-payload"
        failures = [ValueError(secret), OSError(secret), KeyError(secret),
            subprocess.CalledProcessError(1, ["shorebird", secret], output=secret, stderr=secret)]
        for failure in failures:
            def importer(**kwargs):
                kwargs["report"]("live Shorebird release")
                raise failure

            output, errors = io.StringIO(), io.StringIO()
            with patch.object(sys, "argv", ["importer", "--run-id", "123", "--platform", "android", "--output-dir", str(self.root)]), patch.dict(os.environ, {"GITHUB_REPOSITORY": REPOSITORY}), patch.object(MODULE, "import_release", side_effect=importer), redirect_stdout(output), redirect_stderr(errors), self.assertRaises(SystemExit) as exit:
                MODULE.main()
            self.assertEqual(exit.exception.code, 1)
            self.assertIn("Checking live Shorebird release", errors.getvalue())
            self.assertIn("failed at live Shorebird release", errors.getvalue())
            self.assertIn(type(failure).__name__, errors.getvalue())
            self.assertNotIn(secret, errors.getvalue())
            self.assertEqual(output.getvalue(), "")

    def test_cli_preserves_typed_static_guard_reason(self):
        def importer(**kwargs):
            kwargs["report"]("artifact digest")
            raise MODULE.RegistrationError("Downloaded archive differs from its immutable artifact digest")

        errors = io.StringIO()
        with patch.object(sys, "argv", ["importer", "--run-id", "123", "--platform", "android", "--output-dir", str(self.root)]), patch.dict(os.environ, {"GITHUB_REPOSITORY": REPOSITORY}), patch.object(MODULE, "import_release", side_effect=importer), redirect_stderr(errors), self.assertRaises(SystemExit):
            MODULE.main()
        self.assertIn("failed at artifact digest: Downloaded archive differs from its immutable artifact digest", errors.getvalue())

    def test_automatic_import_stops_before_manifest_when_signature_is_invalid(self):
        with patch.object(MODULE, "verify_apk_attestation", side_effect=ValueError("bad signature")), patch.object(MODULE, "verify_automatic_checkouts") as checkout, self.assertRaisesRegex(ValueError, "bad signature"):
            self.import_fixture(automatic=True)
        checkout.assert_not_called()
        self.assertFalse((self.root / "registry/release-manifest.json").exists())

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
