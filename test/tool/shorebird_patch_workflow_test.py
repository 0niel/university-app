import ast
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

import yaml


ROOT = Path(__file__).resolve().parents[2]
PATCH = yaml.safe_load((ROOT / ".github/workflows/shorebird-patch.yml").read_text(encoding="utf-8"))
PROMOTE = yaml.safe_load((ROOT / ".github/workflows/shorebird-promote.yml").read_text(encoding="utf-8"))


def step(workflow, job, name):
    return next(item for item in workflow["jobs"][job]["steps"] if item["name"] == name)


def approved_paths(name):
    source = step(PATCH, "validate", "Verify hotfix boundary")["run"]
    tree = ast.parse(source.split("python3 - <<'PY'\n", 1)[1].rsplit("\nPY", 1)[0])
    return next(ast.literal_eval(node.value) for node in tree.body
                if isinstance(node, ast.Assign) and any(
                    isinstance(target, ast.Name) and target.id == name for target in node.targets))


class ShorebirdPatchWorkflowTest(unittest.TestCase):
    def bash(self, script, **values):
        bash = os.environ.get("TEST_BASH") or shutil.which("bash")
        self.assertIsNotNone(bash, "Bash is required to test patch workflows")
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "output"
            environment = {
                **os.environ,
                "GITHUB_ENV": output.as_posix(),
                "GITHUB_OUTPUT": output.as_posix(),
                "WORKFLOW_REF": "refs/heads/master",
                "SOURCE_SHA": "a" * 40,
                "BASELINE_SHA": "b" * 40,
                "STAGING_RUN_ID": "123",
                "PATCH_NUMBER": "2",
                **values,
            }
            result = subprocess.run(
                [bash, "--noprofile", "--norc", "-e", "-o", "pipefail", "-c", script],
                env=environment, capture_output=True, text=True, timeout=30,
            )
            return result, output.read_text() if output.exists() else ""

    def test_latest_android_release_can_be_promoted(self):
        result, output = self.bash(
            step(PROMOTE, "promote", "Validate requested promotion")["run"],
            PLATFORM="android", RELEASE_VERSION="5.2.0+1004201",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(output, "APP_ID=c55a7a80-2fcb-4565-833e-fb442dbe4e34\n")

    def test_verified_android_runtime_release_is_available_for_patch_and_promotion(self):
        result, output = self.bash(
            step(PATCH, "validate", "Validate requested target")["run"],
            PLATFORM="android", RELEASE_VERSION="5.2.1+1005301", TARGET_TRACK="staging",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("baseline_sha=892c735ac0b46f3b8f6621b1d67d12342c45cc84", output)
        result, output = self.bash(
            step(PROMOTE, "promote", "Validate requested promotion")["run"],
            PLATFORM="android", RELEASE_VERSION="5.2.1+1005301",
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("APP_ID=c55a7a80-2fcb-4565-833e-fb442dbe4e34", output)

    def test_projection_uses_trusted_workflow_helper_in_both_jobs(self):
        for job in ("validate", "patch"):
            preparation = step(PATCH, job, "Prepare verified runtime projection")
            self.assertIn('git show "$WORKFLOW_SHA:tool/prepare_shorebird_patch.py"', preparation["run"])
            self.assertIn("--apply", preparation["run"])
            self.assertIn('5.2.1+1005801', preparation['if'])
            self.assertIn('5.2.1+2439.14.43', preparation['if'])
            self.assertIn('--release-version "$RELEASE_VERSION"', preparation['run'])
            self.assertIn("--verify-worktree", step(PATCH, job, "Verify locked workspace")["run"])
        self.assertIn("--expected-projection", step(PATCH, "patch", "Prepare verified runtime projection")["run"])
        publish = step(PATCH, "patch", "Publish staging patch")["run"]
        self.assertNotIn("--allow-native-diffs", publish)
        self.assertNotIn("--allow-asset-diffs", publish)
        self.assertIn("projection_sha256", step(PROMOTE, "promote", "Verify receipt")["run"])

    def test_unsupported_platform_release_combinations_fail(self):
        for platform, version in (("ios", "5.2.0+1004201"), ("ios", "5.2.1+1005801"), ("android", "5.2.1+2439.14.43"), ("android", "99.0.0+1")):
            with self.subTest(platform=platform, version=version):
                result, output = self.bash(
                    step(PROMOTE, "promote", "Validate requested promotion")["run"],
                    PLATFORM=platform, RELEASE_VERSION=version,
                )
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("Unsupported platform and release combination", result.stderr)
                self.assertEqual(output, "")

    def test_analysis_covers_the_verified_dart_files_for_each_boundary(self):
        script = step(PATCH, "validate", "Analyze hotfix")["run"]
        mocks = 'git() { printf "%s\\n" "$TEST_SOURCES"; }; flutter() { printf "%s\\n" "$@"; };\n'
        for boundary in ("current_allowed", "legacy_allowed"):
            paths = sorted(path for path in approved_paths(boundary) if path.endswith(".dart"))
            result, _ = self.bash(mocks + script, TEST_SOURCES="\n".join(paths))
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout.splitlines(), ["analyze", "--no-pub", *paths])

    def test_failed_diff_cannot_run_an_unscoped_analysis(self):
        script = step(PATCH, "validate", "Analyze hotfix")["run"]
        result, _ = self.bash('git() { return 42; }; flutter() { echo unexpected; };\n' + script)
        self.assertEqual(result.returncode, 42)
        self.assertEqual(result.stdout, "")

    def test_latest_tests_cover_schedule_and_discussions_and_keep_legacy_separate(self):
        current = step(PATCH, "validate", "Test schedule and discussions")
        self.assertEqual(current["if"], "steps.inputs.outputs.release_version == '5.2.0+1004201'")
        result, _ = self.bash('flutter() { printf "%s\\n" "$@"; };\n' + current["run"])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.splitlines(), ["test", "--no-pub", "test/schedule", "test/top_discussions"])
        for name in ("Test user initialization", "Test academic profile initialization"):
            legacy = step(PATCH, "validate", name)
            self.assertEqual(legacy["if"], "steps.inputs.outputs.release_version != '5.2.0+1004201' && steps.inputs.outputs.release_version != '5.2.1+1005301' && steps.inputs.outputs.release_version != '5.2.1+1005801' && steps.inputs.outputs.release_version != '5.2.1+2439.14.43' && steps.inputs.outputs.release_version != '5.2.1+1006201' && steps.inputs.outputs.release_version != '5.2.1+2439.15.54'")
            self.assertIn("test/src/", legacy["run"])

    def test_new_android_baseline_is_available_for_patch_and_promotion(self):
        for workflow, job, name in (
            (PATCH, 'validate', 'Validate requested target'),
            (PROMOTE, 'promote', 'Validate requested promotion'),
        ):
            result, output = self.bash(step(workflow, job, name)['run'],
                PLATFORM='android', RELEASE_VERSION='5.2.1+1005801', TARGET_TRACK='staging')
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('c55a7a80-2fcb-4565-833e-fb442dbe4e34', output)
            if workflow is PATCH:
                self.assertIn('baseline_sha=506602c5d8da2cac5a6180d26b753f415d381819', output)

    def test_new_ios_baseline_is_available_for_patch_and_promotion(self):
        for workflow, job, name in (
            (PATCH, 'validate', 'Validate requested target'),
            (PROMOTE, 'promote', 'Validate requested promotion'),
        ):
            result, output = self.bash(step(workflow, job, name)['run'],
                PLATFORM='ios', RELEASE_VERSION='5.2.1+2439.14.43', TARGET_TRACK='staging')
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('21c47e68-a64f-49c1-af6e-4a406dfe266f', output)
            if workflow is PATCH:
                self.assertIn('baseline_sha=506602c5d8da2cac5a6180d26b753f415d381819', output)

    def test_only_new_android_base_reconstructs_google_services_from_pinned_generator(self):
        script = step(PATCH, 'patch', 'Configure release parameters')['run'].split("python3 - <<'PY'", 1)[0]
        mocks = 'git() { printf "%s\\n" "$*" >> "$GITHUB_OUTPUT"; }; python3() { printf "%s\\n" "$*" >> "$GITHUB_OUTPUT"; }; dart() { :; };\n'
        with tempfile.TemporaryDirectory() as temporary:
            for platform, version in (('android', '5.2.1+1006201'), ('ios', '5.2.1+2439.15.54'), ('android', '5.2.1+1005801'), ('android', '5.2.1+1005301'), ('android', '5.2.0+1004201'), ('ios', '5.2.0+2435.13.10'), ('ios', '5.2.1+2439.14.43')):
                with self.subTest(platform=platform, version=version):
                    result, output = self.bash(mocks + script, PLATFORM=platform, RELEASE_VERSION=version,
                        RUNNER_TEMP=Path(temporary).as_posix(), WORKFLOW_SHA='c' * 40,
                        UNIVERSITY_CONFIG_JSON='{}', FIREBASE_CONFIG_JSON='{}')
                    self.assertEqual(result.returncode, 0, result.stderr)
                    new_base = version in ('5.2.1+1005801', '5.2.1+1006201')
                    self.assertEqual('--android-output android/app/google-services.json' in output, new_base)
                    self.assertEqual('--verify-native-firebase' in output, new_base)
                    self.assertIn(('b' if new_base else 'c') * 40 + ':tool/configure_firebase.py', output)

    def test_new_release_promotion_rejects_wrong_projection_identity(self):
        script = step(PROMOTE, 'promote', 'Verify receipt')['run'].split("python3 - <<'PY'\n", 1)[1].rsplit('\nPY', 1)[0]
        projections = next(ast.literal_eval(node.value) for node in ast.parse(script).body
            if isinstance(node, ast.Assign) and any(isinstance(target, ast.Name) and target.id == 'projections' for target in node.targets))
        baseline, reviewed = projections['5.2.1+1005801']
        self.assertEqual(projections['5.2.1+2439.14.43'], (baseline, reviewed))
        tool_tree = ast.parse((ROOT / 'tool/prepare_shorebird_patch.py').read_text())
        tool_pins = {node.targets[0].id: ast.literal_eval(node.value) for node in tool_tree.body
            if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name)
            and node.targets[0].id in ('NAV_BASELINE_SHA', 'NAV_REVIEWED_SOURCE_SHA')}
        self.assertEqual((baseline, reviewed), (tool_pins['NAV_BASELINE_SHA'], tool_pins['NAV_REVIEWED_SOURCE_SHA']))
        receipt = dict(source_sha='a' * 40, app_id='app', platform='android', release_version='5.2.1+1005801',
            patch_number=1, staging_run_id='123', track='staging', patch_id=1, artifacts=[{'hash': 'artifact'}],
            baseline_sha=baseline, reviewed_source_sha=reviewed, projection_sha256='b' * 64)
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / 'promotion-receipt'
            directory.mkdir()
            for mutation in ({}, {'baseline_sha': 'c' * 40}, {'reviewed_source_sha': 'c' * 40}, {'projection_sha256': 'invalid'}):
                with self.subTest(mutation=mutation):
                    (directory / 'shorebird-patch-receipt.json').write_text(json.dumps({**receipt, **mutation}))
                    result = subprocess.run([sys.executable, '-c', script], env={**os.environ,
                        'RUNNER_TEMP': temporary, 'SOURCE_SHA': 'a' * 40, 'APP_ID': 'app', 'PLATFORM': 'android',
                        'RELEASE_VERSION': '5.2.1+1005801', 'PATCH_NUMBER': '1', 'STAGING_RUN_ID': '123'},
                        capture_output=True, text=True, timeout=15)
                    self.assertEqual(result.returncode == 0, not mutation, result.stderr)


    def test_latest_read_state_releases_are_available_with_exact_baselines(self):
        targets = (
            ("android", "5.2.1+1006201", "781b2ff4a14c9888331eb61b156a2cb0c7e4515b"),
            ("ios", "5.2.1+2439.15.54", "ee51aeee41bf3c48925c6a524e9e9e90c40b0dd1"),
        )
        for platform, version, baseline in targets:
            with self.subTest(version=version):
                for workflow, job, name in ((PATCH, "validate", "Validate requested target"), (PROMOTE, "promote", "Validate requested promotion")):
                    result, output = self.bash(step(workflow, job, name)["run"], PLATFORM=platform, RELEASE_VERSION=version, TARGET_TRACK="staging")
                    self.assertEqual(result.returncode, 0, result.stderr)
                    if workflow is PATCH:
                        self.assertIn("baseline_sha=" + baseline, output)
                for job in ("validate", "patch"):
                    self.assertIn(version, step(PATCH, job, "Prepare verified runtime projection")["if"])
                    self.assertIn(version, step(PATCH, job, "Verify locked workspace")["run"])
                self.assertIn(version, step(PATCH, "validate", "Test reviewed runtime changes")["if"])
                result, _ = self.bash(step(PATCH, "validate", "Validate requested target")["run"], PLATFORM="ios" if platform == "android" else "android", RELEASE_VERSION=version, TARGET_TRACK="staging")
                self.assertNotEqual(result.returncode, 0)

    def test_read_state_promotion_checks_pinned_runtime_and_baseline(self):
        script = step(PROMOTE, 'promote', 'Verify receipt')['run'].split("python3 - <<'PY'\n", 1)[1].rsplit('\nPY', 1)[0]
        assignments = {node.targets[0].id: ast.literal_eval(node.value) for node in ast.parse(script).body
            if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name)
            and node.targets[0].id in ('read_state_reviewed', 'read_state_baselines')}
        tool_tree = ast.parse((ROOT / 'tool/prepare_shorebird_patch.py').read_text())
        tool_pins = {node.targets[0].id: ast.literal_eval(node.value) for node in tool_tree.body
            if isinstance(node, ast.Assign) and isinstance(node.targets[0], ast.Name)
            and node.targets[0].id in ('READ_STATE_BASELINES', 'READ_STATE_REVIEWED_SHA')}
        self.assertEqual(assignments['read_state_reviewed'], tool_pins['READ_STATE_REVIEWED_SHA'])
        self.assertEqual(assignments['read_state_baselines'], tool_pins['READ_STATE_BASELINES'])
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary) / 'promotion-receipt'
            directory.mkdir()
            for version, baseline in tool_pins['READ_STATE_BASELINES'].items():
                receipt = dict(source_sha='a' * 40, app_id='app', platform='android', release_version=version,
                    patch_number=1, staging_run_id='123', track='staging', patch_id=1, artifacts=[{'hash': 'artifact'}],
                    baseline_sha=baseline, reviewed_source_sha=tool_pins['READ_STATE_REVIEWED_SHA'], projection_sha256='b' * 64)
                for mutation in ({}, {'baseline_sha': 'c' * 40}, {'reviewed_source_sha': 'c' * 40}, {'projection_sha256': 'invalid'}):
                    with self.subTest(version=version, mutation=mutation):
                        (directory / 'shorebird-patch-receipt.json').write_text(json.dumps({**receipt, **mutation}))
                        result = subprocess.run([sys.executable, '-c', script], env={**os.environ,
                            'RUNNER_TEMP': temporary, 'SOURCE_SHA': 'a' * 40, 'APP_ID': 'app', 'PLATFORM': 'android',
                            'RELEASE_VERSION': version, 'PATCH_NUMBER': '1', 'STAGING_RUN_ID': '123'},
                            capture_output=True, text=True, timeout=15)
                        self.assertEqual(result.returncode == 0, not mutation, result.stderr)


if __name__ == "__main__":
    unittest.main()
