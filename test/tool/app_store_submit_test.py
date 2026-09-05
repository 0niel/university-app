import importlib.util
from pathlib import Path
import sys
import unittest
from unittest.mock import Mock, patch


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tool"))
SPEC = importlib.util.spec_from_file_location(
    "app_store_submit", ROOT / "tool/app_store_submit.py"
)
submit = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(submit)


def version(number="5.2.1", state="PREPARE_FOR_SUBMISSION", build_id=None):
    return {
        "id": "version-123",
        "attributes": {
            "platform": "IOS", "versionString": number, "appVersionState": state,
            "releaseType": "AFTER_APPROVAL",
        },
        "relationships": {"build": {"data": {"id": build_id} if build_id else None}},
    }


def client_for(*versions, next_page=None):
    client = Mock()
    client.get.side_effect = [
        {"data": [{"id": "app-123"}]},
        {"data": list(versions), "links": {"next": next_page}},
    ]
    return client


def pending_client(item_version="version-123", extra_item=False, release_type="AFTER_APPROVAL"):
    target = version(state="READY_FOR_REVIEW", build_id="new")
    target["attributes"]["appStoreState"] = "PREPARE_FOR_SUBMISSION"
    target["attributes"]["releaseType"] = release_type
    item = {
        "id": "item-123", "attributes": {"state": "READY_FOR_REVIEW"},
        "relationships": {"appStoreVersion": {"data": {"id": item_version}}},
    }
    client = Mock()
    client.get.side_effect = [
        {"data": [{"id": "app-123"}]}, {"data": [target]},
        {"data": [{"id": "app-123"}]}, {"data": [target]},
        {"data": [{
            "id": "review-123",
            "attributes": {"platform": "IOS", "state": "READY_FOR_REVIEW"},
            "relationships": {"app": {"data": {"id": "app-123"}}},
        }]},
        {"data": [item, item] if extra_item else [item]},
    ]
    return client


class AppStoreSubmissionTest(unittest.TestCase):
    def test_new_version_can_be_submitted_without_replacing_distributed_version(self):
        client = client_for(version("5.2.0", "READY_FOR_DISTRIBUTION", "older"))
        self.assertTrue(submit.should_submit(client, "app.bundle", "5.2.1", "new"))
        self.assertEqual(client.get.call_args_list[0].args[1]["filter[bundleId]"], "app.bundle")

    def test_repeated_submission_skips_matching_build_in_review_or_distribution(self):
        for state in submit.SUBMITTED_STATES:
            with self.subTest(state=state):
                self.assertFalse(submit.should_submit(
                    client_for(version(state=state, build_id="new")),
                    "app.bundle", "5.2.1", "new",
                ))

    def test_conflicting_editable_version_blocks_cli_version_replacement(self):
        for state in submit.EDITABLE_STATES:
            with self.subTest(state=state), self.assertRaisesRegex(RuntimeError, "Another editable"):
                submit.should_submit(
                    client_for(version("5.3.0", state)), "app.bundle", "5.2.1", "new"
                )

    def test_legacy_editable_state_also_blocks_replacement(self):
        other = version("5.3.0", "READY_FOR_REVIEW")
        other["attributes"]["appStoreState"] = "PREPARE_FOR_SUBMISSION"
        with self.assertRaisesRegex(RuntimeError, "Another editable"):
            submit.should_submit(client_for(other), "app.bundle", "5.2.1", "new")

    def test_different_selected_build_fails_closed(self):
        for state in ("PREPARE_FOR_SUBMISSION", "WAITING_FOR_REVIEW"):
            with self.subTest(state=state), self.assertRaisesRegex(RuntimeError, "different build"):
                submit.should_submit(
                    client_for(version(state=state, build_id="other")),
                    "app.bundle", "5.2.1", "new",
                )

    def test_incomplete_or_ambiguous_version_metadata_fails_closed(self):
        cases = [client_for(next_page="more"), client_for(version(), version())]
        for client in cases:
            with self.assertRaises(RuntimeError):
                submit.should_submit(client, "app.bundle", "5.2.1", "new")

    def test_unknown_state_cannot_trigger_mutation(self):
        with self.assertRaisesRegex(RuntimeError, "cannot be submitted"):
            submit.should_submit(
                client_for(version(state="FUTURE_STATE")), "app.bundle", "5.2.1", "new"
            )

    def test_bad_input_is_rejected_before_network(self):
        for marketing, build in [("5.2.1;evil", "2440.1.2"), ("5.2.1", "$(evil)")]:
            client = Mock()
            with self.assertRaises(ValueError):
                submit.submit_build(client, "app.bundle", marketing, build, Path("key.p8"))
            client.get.assert_not_called()

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_only_verified_build_is_passed_to_submission(self, wait, run):
        wait.return_value = {
            "build_id": "build-123", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        result = submit.submit_build(
            client_for(), "app.bundle", "5.2.1", "2440.1.2", Path("key.p8")
        )
        command = run.call_args.args[0]
        self.assertEqual(command[:4], ["app-store-connect", "builds", "submit-to-app-store", "build-123"])
        self.assertIn("--disable-jwt-cache", command)
        self.assertIn("--no-phased-release", command)
        self.assertEqual(command[command.index("--release-type") + 1], "AFTER_APPROVAL")
        self.assertNotIn("--cancel-previous-submissions", command)
        self.assertEqual(result["submission_action"], "submitted")
        self.assertTrue(run.call_args.kwargs["check"])

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_mismatched_verified_build_prevents_submission(self, wait, run):
        wait.return_value = {
            "build_id": "build-123", "build_number": "2440.1.3",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        with self.assertRaisesRegex(RuntimeError, "does not match"):
            submit.submit_build(Mock(), "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"))
        run.assert_not_called()

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_rerun_does_not_resubmit(self, wait, run):
        wait.return_value = {
            "build_id": "new", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        result = submit.submit_build(
            client_for(version(state="WAITING_FOR_REVIEW", build_id="new")),
            "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"),
        )
        self.assertEqual(result["submission_action"], "already_submitted")
        run.assert_not_called()

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_partial_submission_resumes_only_existing_matching_review(self, wait, run):
        wait.return_value = {
            "build_id": "new", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        client = pending_client()
        result = submit.submit_build(
            client, "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"),
        )
        self.assertEqual(result["submission_action"], "resumed")
        run.assert_called_once()
        command = run.call_args.args[0]
        self.assertEqual(command[:4], ["app-store-connect", "review-submissions", "confirm", "review-123"])
        self.assertNotIn("submit-to-app-store", command)
        self.assertNotIn("create", command)
        self.assertNotIn("cancel", command)
        self.assertEqual(client.get.call_args_list[-1].args[0], "/v1/reviewSubmissions/review-123/items")
        self.assertEqual(client.get.call_args_list[-1].args[1], {"include": "appStoreVersion", "limit": "200"})
        self.assertIn("--disable-jwt-cache", command)

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_resume_refuses_other_version_extra_items_or_manual_release(self, wait, run):
        wait.return_value = {
            "build_id": "new", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        cases = [
            pending_client(item_version="another-version"),
            pending_client(extra_item=True),
            pending_client(release_type="MANUAL"),
        ]
        for client in cases:
            with self.assertRaises(RuntimeError):
                submit.submit_build(client, "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"))
        run.assert_not_called()


class AppStoreSubmissionWorkflowTest(unittest.TestCase):
    def test_manual_protected_submission_without_rebuilding_or_uploading(self):
        workflow = (ROOT / ".github/workflows/app-store-submit.yml").read_text(encoding="utf-8")
        self.assertIn("workflow_dispatch:", workflow)
        self.assertIn("github.ref == 'refs/heads/master'", workflow)
        self.assertIn("environment: beta", workflow)
        self.assertIn("group: shorebird-ios-release", workflow)
        self.assertIn("cancel-in-progress: false", workflow)
        self.assertIn("codemagic-cli-tools==0.69.0", workflow)
        self.assertIn("--release-status", workflow)
        self.assertIn("if: always()", workflow)
        self.assertIn('rm -f "$RUNNER_TEMP/app-store-submit.p8"', workflow)
        self.assertLess(workflow.index("tool/app_store_submit.py"), workflow.index("--release-status"))
        self.assertNotIn("--upload-app", workflow)
        self.assertNotIn("shorebird release", workflow)
        self.assertNotIn("${{ inputs.", workflow.split("    steps:", 1)[1])


if __name__ == "__main__":
    unittest.main()
