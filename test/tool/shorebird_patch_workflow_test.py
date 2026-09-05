import ast
import os
from pathlib import Path
import shutil
import subprocess
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

    def test_unsupported_platform_release_combinations_fail(self):
        for platform, version in (("ios", "5.2.0+1004201"), ("android", "99.0.0+1")):
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
            self.assertEqual(legacy["if"], "steps.inputs.outputs.release_version != '5.2.0+1004201'")
            self.assertIn("test/src/", legacy["run"])


if __name__ == "__main__":
    unittest.main()
