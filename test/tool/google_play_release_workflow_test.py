import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import textwrap
import unittest


ROOT = Path(__file__).resolve().parents[2]
WORKFLOW = (ROOT / ".github/workflows/google-play-release.yml").read_text(
    encoding="utf-8"
)


def step(name):
    return WORKFLOW.split(f"      - name: {name}\n", 1)[1].split(
        "\n      - name:", 1
    )[0]


class GooglePlayReleaseWorkflowTest(unittest.TestCase):
    def resolve(self, event, requested_tag="", found_tag="", api_status=0):
        script = textwrap.dedent(step("Resolve beta release").split("run: |\n", 1)[1])
        bash = os.environ.get("TEST_BASH") or shutil.which("bash")
        self.assertIsNotNone(bash, "Bash is required to test the release workflow")
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "output"
            environment = {
                **os.environ,
                "GITHUB_EVENT_NAME": event,
                "GITHUB_REPOSITORY": "example/application",
                "GITHUB_OUTPUT": output.as_posix(),
                "RELEASE_SHA": "a" * 40,
                "REQUESTED_TAG": requested_tag,
                "TEST_FOUND_TAG": found_tag,
                "TEST_API_STATUS": str(api_status),
            }
            result = subprocess.run(
                [bash, "--noprofile", "--norc", "-e", "-o", "pipefail", "-c",
                 'gh() { printf "%s\\n" "$TEST_FOUND_TAG"; return "$TEST_API_STATUS"; }\n'
                 + script],
                env=environment,
                capture_output=True,
                text=True,
                timeout=10,
            )
            values = output.read_text(encoding="utf-8") if output.exists() else ""
            return result, values

    def test_upstream_matching_release_is_available(self):
        result, values = self.resolve("workflow_run", found_tag="v5.2.0-beta.1003501")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(values, "tag=v5.2.0-beta.1003501\navailable=true\n")

    def test_upstream_missing_release_is_an_error(self):
        result, values = self.resolve("workflow_run")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Matching beta release is unavailable", result.stderr)
        self.assertEqual(values, "")

    def test_manual_missing_tag_is_an_error(self):
        result, values = self.resolve("workflow_dispatch", found_tag="older-release")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("A release tag is required", result.stderr)
        self.assertEqual(values, "")

    def test_manual_tag_is_preserved_without_lookup(self):
        result, values = self.resolve(
            "workflow_dispatch", requested_tag="v5.2.0-beta.1003501", api_status=42
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(values, "tag=v5.2.0-beta.1003501\navailable=true\n")

    def test_api_failure_stops_release_resolution(self):
        result, values = self.resolve("workflow_run", api_status=42)
        self.assertEqual(result.returncode, 42)
        self.assertEqual(values, "")

    def test_publishing_is_event_driven_and_serialized(self):
        self.assertNotIn("schedule:", WORKFLOW)
        self.assertIn("group: google-play-internal\n", WORKFLOW)
        self.assertIn("cancel-in-progress: false", WORKFLOW)
        self.assertIn("github.event.workflow_run.conclusion == 'success'", WORKFLOW)
        self.assertIn("github.event.workflow_run.event == 'workflow_run'", WORKFLOW)
        self.assertIn("github.event.workflow_run.event == 'workflow_dispatch'", WORKFLOW)
        self.assertIn("github.event.workflow_run.head_branch == 'master'", WORKFLOW)

    def test_upload_and_credentials_are_gated(self):
        gate = "if: ${{ steps.release.outputs.available == 'true' }}"
        self.assertIn(gate, step("Download signed Android bundle"))
        self.assertIn(gate, step("Upload beta to Google Play"))
        self.assertIn(
            "if: ${{ steps.release.outputs.available == 'true' || "
            "(github.event_name == 'workflow_dispatch' && inputs.update_icon_only == true) }}",
            step("Prepare Google Play credentials"),
        )

    def test_lookup_remains_bound_to_source_revision(self):
        self.assertIn('.target_commitish == \\\"$RELEASE_SHA\\\"',
                      step("Resolve beta release"))


if __name__ == "__main__":
    unittest.main()
