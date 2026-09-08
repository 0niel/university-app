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
        {"data": []},
        {"data": [{
            "id": "review-123",
            "attributes": {"platform": "IOS", "state": "READY_FOR_REVIEW"},
            "relationships": {"app": {"data": {"id": "app-123"}}},
        }]},
        {"data": [item, item] if extra_item else [item]},
    ]
    return client


def replacement_client(
    initial_state="WAITING_FOR_REVIEW", extra_item=False, item_version="version-123",
    fresh_state=None, cancelled_state="DEVELOPER_REJECTED",
    fresh_build="old", extra_submission=False,
):
    old = version(state=initial_state, build_id="old")
    responses = [{"data": [{"id": "app-123"}]}, {"data": [old]}]
    if initial_state == "WAITING_FOR_REVIEW":
        review = {
            "id": "review-123",
            "attributes": {"platform": "IOS", "state": "WAITING_FOR_REVIEW"},
            "relationships": {"app": {"data": {"id": "app-123"}}},
        }
        item = {
            "attributes": {"state": "READY_FOR_REVIEW"},
            "relationships": {"appStoreVersion": {"data": {"id": item_version}}},
        }
        responses += [
            {"data": [review, review] if extra_submission else [review]},
            {"data": [item, item] if extra_item else [item]},
            {"data": version(state=fresh_state or initial_state, build_id=fresh_build)},
            {"data": version(state=cancelled_state, build_id="old")},
        ]
    else:
        if initial_state in ("REJECTED", "METADATA_REJECTED"):
            responses += [
                {"data": [{
                    "id": "review-123", "attributes": {"platform": "IOS", "state": "UNRESOLVED_ISSUES"},
                    "relationships": {"app": {"data": {"id": "app-123"}}},
                }]},
                {"data": [{
                    "id": "item-123", "attributes": {"state": "REJECTED"},
                    "relationships": {"appStoreVersion": {"data": {"id": "version-123"}}},
                }]},
            ]
        responses.append({"data": version(state=fresh_state or initial_state, build_id=fresh_build)})
    responses += [
        {"data": [{"id": "app-123"}]},
        {"data": [version(state="DEVELOPER_REJECTED", build_id="new")]},
    ]
    client = Mock()
    client.get.side_effect = responses
    return client


def rejected_client(build_id="old", item_state="REJECTED", version_state="REJECTED"):
    client = Mock()
    state = {
        "build": build_id, "item_state": item_state, "version_state": version_state,
        "submission_state": "UNRESOLVED_ISSUES", "item_id": "cmV2aWV3LWl0ZW0=",
        "item_version": "version-123", "app": "app-123", "extra_items": False,
        "extra_submissions": False, "pagination": None, "resolve_error": False,
        "empty_draft": False,
    }
    client.state = state

    def get(path, query):
        if path == "/v1/apps":
            return {"data": [{"id": "app-123"}]}
        if path == "/v1/apps/app-123/appStoreVersions":
            return {"data": [version(state=state["version_state"], build_id=state["build"])]}
        if path == "/v1/appStoreVersions/version-123":
            return {"data": version(state=state["version_state"], build_id=state["build"])}
        if path in ("/v1/reviewSubmissions", "/v1/reviewSubmissions/review-123"):
            review = {
                "id": "review-123", "attributes": {"platform": "IOS", "state": state["submission_state"]},
                "relationships": {"app": {"data": {"id": state["app"]}}},
            }
            if path.endswith("/review-123"):
                return {"data": review}
            reviews = [review] * (2 if state["extra_submissions"] else 1) if state["submission_state"] in query["filter[state]"].split(",") else []
            if state["empty_draft"] and "READY_FOR_REVIEW" in query["filter[state]"]:
                reviews.append({"id": "empty-draft", "attributes": {"state": "READY_FOR_REVIEW", "platform": "IOS"},
                                "relationships": {"app": {"data": {"id": "app-123"}}}})
            return {"data": reviews,
                    "links": {"next": "more" if state["pagination"] == "submissions" else None}}
        if path == "/v1/reviewSubmissions/empty-draft/items":
            return {"data": []}
        if path == "/v1/reviewSubmissions/review-123/items":
            item = {
                "id": state["item_id"], "attributes": {"state": state["item_state"]},
                "relationships": {"appStoreVersion": {"data": {"id": state["item_version"]}}},
            }
            return {"data": [item] * (2 if state["extra_items"] else 1),
                    "links": {"next": "more" if state["pagination"] == "items" else None}}
        raise AssertionError(path)

    def update(path, payload):
        if path == "/v1/appStoreVersions/version-123/relationships/build":
            state["build"] = payload["data"]["id"]
            state["version_state"] = "PREPARE_FOR_SUBMISSION"
        elif path.startswith("/v1/reviewSubmissionItems/"):
            if state["resolve_error"]:
                raise RuntimeError("HTTP 409")
            state["item_state"] = "READY_FOR_REVIEW"
            state["version_state"] = "READY_FOR_REVIEW"
        else:
            raise AssertionError(path)

    client.get.side_effect = get
    client.patch.side_effect = update
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


class AppStoreRejectedSubmissionTest(unittest.TestCase):
    def submit(self, client, run):
        build = {"build_id": "new", "build_number": "2442.10.0",
                 "marketing_version": "5.2.1", "processing_state": "VALID"}
        with patch.object(submit, "wait_for_build", return_value=build), \
             patch.object(submit.subprocess, "run", run):
            return submit.submit_build(client, "app.bundle", "5.2.1", "2442.10.0", Path("key.p8"), True)

    def test_rejected_build_resolves_exact_existing_item_and_confirms_existing_submission(self):
        client, run = rejected_client(), Mock()
        result = self.submit(client, run)
        self.assertEqual(result["submission_action"], "resumed")
        self.assertEqual(client.patch.call_args_list[0].args, (
            "/v1/appStoreVersions/version-123/relationships/build",
            {"data": {"type": "builds", "id": "new"}},
        ))
        self.assertEqual(client.patch.call_args_list[1].args, (
            "/v1/reviewSubmissionItems/cmV2aWV3LWl0ZW0%3D",
            {"data": {"type": "reviewSubmissionItems", "id": "cmV2aWV3LWl0ZW0=", "attributes": {"resolved": True}}},
        ))
        self.assertEqual(client.patch.call_count, 2)
        self.assertEqual(run.call_args.args[0][:4], ["app-store-connect", "review-submissions", "confirm", "review-123"])
        self.assertNotIn("submit-to-app-store", run.call_args.args[0])

    def test_retry_after_build_replacement_does_not_replace_build_again(self):
        client, run = rejected_client(build_id="new"), Mock()
        self.submit(client, run)
        self.assertEqual(client.patch.call_count, 1)
        self.assertIn("reviewSubmissionItems", client.patch.call_args.args[0])
        run.assert_called_once()

    def test_retry_after_resolution_confirms_without_duplicate_item_mutation(self):
        for version_state in ("REJECTED", "READY_FOR_REVIEW"):
            with self.subTest(version_state=version_state):
                client, run = rejected_client("new", "READY_FOR_REVIEW", version_state), Mock()
                self.submit(client, run)
                client.patch.assert_not_called()
                self.assertEqual(run.call_args.args[0][1:4], ["review-submissions", "confirm", "review-123"])

    def test_prepare_transition_and_resolved_retries_ignore_unrelated_empty_draft(self):
        for item_state, version_state, submission_state in (
            ("REJECTED", "PREPARE_FOR_SUBMISSION", "UNRESOLVED_ISSUES"),
            ("READY_FOR_REVIEW", "PREPARE_FOR_SUBMISSION", "UNRESOLVED_ISSUES"),
            ("READY_FOR_REVIEW", "PREPARE_FOR_SUBMISSION", "READY_FOR_REVIEW"),
            ("READY_FOR_REVIEW", "READY_FOR_REVIEW", "UNRESOLVED_ISSUES"),
            ("READY_FOR_REVIEW", "READY_FOR_REVIEW", "READY_FOR_REVIEW"),
        ):
            with self.subTest(item_state=item_state, version_state=version_state, submission_state=submission_state):
                client, run = rejected_client("new", item_state, version_state), Mock()
                client.state.update(empty_draft=True, submission_state=submission_state)
                self.submit(client, run)
                self.assertEqual(client.patch.call_count, int(item_state == "REJECTED"))
                self.assertEqual(run.call_args.args[0][1:4], ["review-submissions", "confirm", "review-123"])
                self.assertFalse(any("empty-draft" in call.args[0] for call in client.patch.call_args_list))

    def test_ready_retry_rejects_nonempty_foreign_draft_or_incomplete_draft(self):
        for draft_items in (
            {"data": [{"id": "foreign", "attributes": {"state": "READY_FOR_REVIEW"},
                       "relationships": {"appStoreVersion": {"data": {"id": "other-version"}}}}]},
            {"data": [], "links": {"next": "more"}},
        ):
            client, run = rejected_client("new", "READY_FOR_REVIEW", "READY_FOR_REVIEW"), Mock()
            client.state.update(empty_draft=True, submission_state="READY_FOR_REVIEW")
            get = client.get.side_effect
            def draft_get(path, query):
                return draft_items if path == "/v1/reviewSubmissions/empty-draft/items" else get(path, query)
            client.get.side_effect = draft_get
            with self.assertRaises(RuntimeError):
                self.submit(client, run)
            client.patch.assert_not_called()
            run.assert_not_called()

    def test_prepare_without_previous_rejection_uses_normal_submission(self):
        for empty_draft in (False, True):
            with self.subTest(empty_draft=empty_draft):
                client, run = rejected_client("new", version_state="PREPARE_FOR_SUBMISSION"), Mock()
                client.state.update(submission_state="COMPLETE", empty_draft=empty_draft)
                self.submit(client, run)
                client.patch.assert_not_called()
                self.assertEqual(run.call_args.args[0][1:4], ["builds", "submit-to-app-store", "new"])

    def test_ambiguous_other_or_incomplete_review_never_resolves_or_confirms(self):
        cases = ({"extra_items": True}, {"extra_submissions": True}, {"pagination": "items"},
                 {"pagination": "submissions"}, {"item_version": "other"}, {"app": "other"},
                 {"submission_state": "IN_REVIEW"}, {"item_state": "ACCEPTED"}, {"item_id": "../other"})
        for build_id in ("old", "new"):
            for changes in cases:
                with self.subTest(build_id=build_id, changes=changes):
                    client, run = rejected_client(build_id), Mock()
                    client.state.update(changes)
                    with self.assertRaises(RuntimeError):
                        self.submit(client, run)
                    client.patch.assert_not_called()
                    run.assert_not_called()

    def test_fresh_build_or_state_change_prevents_resolving_item(self):
        for changes in ({"build": "other"}, {"version_state": "IN_REVIEW"}, {"item_id": "other-item"}):
            with self.subTest(changes=changes):
                client, run = rejected_client("new"), Mock()
                get = client.get.side_effect
                def changing_get(path, query):
                    response = get(path, query)
                    if path.endswith("/items"):
                        client.state.update(changes)
                    return response
                client.get.side_effect = changing_get
                with self.assertRaises(RuntimeError):
                    self.submit(client, run)
                client.patch.assert_not_called()
                run.assert_not_called()

    def test_failed_resolution_never_confirms_submission(self):
        client, run = rejected_client("new"), Mock()
        client.state["resolve_error"] = True
        with self.assertRaisesRegex(RuntimeError, "HTTP 409"):
            self.submit(client, run)
        self.assertEqual(client.patch.call_count, 1)
        run.assert_not_called()

    def test_resolution_timeout_preserves_retry_and_never_confirms(self):
        client, run = rejected_client("new"), Mock()
        client.patch.side_effect = None
        with patch.object(submit.time, "monotonic", side_effect=[0, 121]), \
             self.assertRaisesRegex(RuntimeError, "has not become ready"):
            self.submit(client, run)
        self.assertEqual(client.patch.call_count, 1)
        run.assert_not_called()

    def test_post_resolution_build_change_prevents_confirmation(self):
        client, run = rejected_client("new"), Mock()
        update = client.patch.side_effect
        def changing_update(path, payload):
            update(path, payload)
            client.state["build"] = "other"
        client.patch.side_effect = changing_update
        with self.assertRaisesRegex(RuntimeError, "does not select"):
            self.submit(client, run)
        run.assert_not_called()


class AppStoreSubmissionWorkflowTest(unittest.TestCase):
    def test_review_replacement_is_explicit_and_passed_as_argument(self):
        workflow = (ROOT / ".github/workflows/app-store-submit.yml").read_text(encoding="utf-8")
        self.assertIn("replace_pending_review:", workflow)
        self.assertIn("default: false", workflow.split("replace_pending_review:", 1)[1])
        self.assertIn("REPLACE_PENDING_REVIEW: ${{ inputs.replace_pending_review }}", workflow)
        self.assertIn('if [[ "$REPLACE_PENDING_REVIEW" = true ]]', workflow)
        self.assertIn("arguments+=(--replace-pending-review)", workflow)

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


class AppStoreBuildReplacementTest(unittest.TestCase):
    def test_opt_in_replaces_only_exact_pending_review_and_verifies_new_selection(self):
        client = replacement_client()
        self.assertTrue(submit.should_submit(client, "app.bundle", "5.2.1", "new", True))
        self.assertEqual(client.patch.call_count, 2)
        self.assertEqual(client.patch.call_args_list[0].args, (
            "/v1/reviewSubmissions/review-123",
            {"data": {"type": "reviewSubmissions", "id": "review-123", "attributes": {"canceled": True}}},
        ))
        self.assertEqual(client.patch.call_args_list[1].args, (
            "/v1/appStoreVersions/version-123/relationships/build",
            {"data": {"type": "builds", "id": "new"}},
        ))
        self.assertEqual(client.get.call_args_list[2].args[1]["filter[state]"], "WAITING_FOR_REVIEW")

    def test_default_does_not_cancel_pending_old_build(self):
        client = replacement_client()
        with self.assertRaisesRegex(RuntimeError, "different build"):
            submit.should_submit(client, "app.bundle", "5.2.1", "new")
        client.patch.assert_not_called()

    def test_extra_review_items_submissions_and_other_versions_prevent_cancellation(self):
        for client in (
            replacement_client(extra_item=True), replacement_client(extra_submission=True),
            replacement_client(item_version="other-version"),
        ):
            with self.assertRaises(RuntimeError):
                submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
            client.patch.assert_not_called()

    def test_in_review_distributed_and_unsubmitted_states_cannot_be_replaced(self):
        for state in ("IN_REVIEW", "READY_FOR_DISTRIBUTION", "PREPARE_FOR_SUBMISSION", "READY_FOR_REVIEW"):
            client = client_for(version(state=state, build_id="old"))
            with self.subTest(state=state), self.assertRaisesRegex(RuntimeError, "Only a pending"):
                submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
            client.patch.assert_not_called()

    def test_fresh_state_or_build_change_prevents_cancellation(self):
        for client in (
            replacement_client(fresh_state="IN_REVIEW"),
            replacement_client(fresh_build="someone-elses-build"),
        ):
            with self.assertRaises(RuntimeError):
                submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
            client.patch.assert_not_called()

    def test_failed_cancellation_does_not_change_selected_build(self):
        client = replacement_client()
        client.patch.side_effect = RuntimeError("HTTP 409")
        with self.assertRaisesRegex(RuntimeError, "HTTP 409"):
            submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
        self.assertEqual(client.patch.call_count, 1)

    def test_unexpected_post_cancel_state_does_not_change_selected_build(self):
        client = replacement_client(cancelled_state="IN_REVIEW")
        with self.assertRaisesRegex(RuntimeError, "unexpected state"):
            submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
        self.assertEqual(client.patch.call_count, 1)

    def test_cancellation_timeout_does_not_change_selected_build(self):
        client = replacement_client(cancelled_state="WAITING_FOR_REVIEW")
        with patch.object(submit.time, "monotonic", side_effect=[0, 121]):
            with self.assertRaisesRegex(RuntimeError, "has not completed"):
                submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
        self.assertEqual(client.patch.call_count, 1)

    def test_explicit_retry_after_cancellation_only_changes_build(self):
        client = replacement_client(initial_state="DEVELOPER_REJECTED")
        self.assertTrue(submit.should_submit(client, "app.bundle", "5.2.1", "new", True))
        client.patch.assert_called_once_with(
            "/v1/appStoreVersions/version-123/relationships/build",
            {"data": {"type": "builds", "id": "new"}},
        )

    def test_rejected_build_replacement_changes_only_the_build_without_cancelling_review(self):
        for state in ("REJECTED", "METADATA_REJECTED"):
            with self.subTest(state=state):
                client = replacement_client(initial_state=state)
                self.assertTrue(submit.should_submit(client, "app.bundle", "5.2.1", "new", True))
                client.patch.assert_called_once_with(
                    "/v1/appStoreVersions/version-123/relationships/build",
                    {"data": {"type": "builds", "id": "new"}},
                )
                self.assertTrue(any("reviewSubmissions" in call.args[0] for call in client.get.call_args_list))

    def test_rejected_build_replacement_requires_explicit_opt_in(self):
        for state in ("REJECTED", "METADATA_REJECTED"):
            with self.subTest(state=state):
                client = replacement_client(initial_state=state)
                with self.assertRaisesRegex(RuntimeError, "different build"):
                    submit.should_submit(client, "app.bundle", "5.2.1", "new")
                client.patch.assert_not_called()

    def test_rejected_state_or_build_race_prevents_replacement(self):
        for state in ("REJECTED", "METADATA_REJECTED"):
            for changes in (
                {"fresh_state": "IN_REVIEW"},
                {"fresh_state": "WAITING_FOR_REVIEW"},
                {"fresh_state": "DEVELOPER_REJECTED"},
                {"fresh_build": "someone-elses-build"},
            ):
                with self.subTest(state=state, changes=changes):
                    client = replacement_client(initial_state=state, **changes)
                    with self.assertRaisesRegex(RuntimeError, "changed before build replacement"):
                        submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
                    client.patch.assert_not_called()

    def test_rejected_version_or_platform_race_prevents_replacement(self):
        for changes in ({"platform": "MAC_OS"}, {"versionString": "5.3.0"}):
            fresh = version(state="REJECTED", build_id="old")
            fresh["attributes"].update(changes)
            client = rejected_client()
            get = client.get.side_effect
            def changed_version(path, query):
                return {"data": fresh} if path == "/v1/appStoreVersions/version-123" else get(path, query)
            client.get.side_effect = changed_version
            with self.subTest(changes=changes), self.assertRaisesRegex(RuntimeError, "changed before build replacement"):
                submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
            client.patch.assert_not_called()

    def test_rejected_replacement_rechecks_selected_build_before_submission(self):
        client = rejected_client()
        def competing_update(path, payload):
            client.state["build"] = "someone-elses-build"
        client.patch.side_effect = competing_update
        with self.assertRaisesRegex(RuntimeError, "different build"):
            submit.should_submit(client, "app.bundle", "5.2.1", "new", True)
        self.assertEqual(client.patch.call_count, 1)

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_replacement_waits_for_valid_requested_build_before_cancellation(self, wait, run):
        client = replacement_client()
        wait.return_value = {
            "build_id": "new", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "PROCESSING",
        }
        with self.assertRaisesRegex(RuntimeError, "does not match"):
            submit.submit_build(client, "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"), True)
        client.get.assert_not_called()
        client.patch.assert_not_called()
        run.assert_not_called()

    @patch.object(submit.subprocess, "run")
    @patch.object(submit, "wait_for_build")
    def test_replaced_verified_build_is_submitted_without_stale_release_notes(self, wait, run):
        wait.return_value = {
            "build_id": "new", "build_number": "2440.1.2",
            "marketing_version": "5.2.1", "processing_state": "VALID",
        }
        client = replacement_client()
        result = submit.submit_build(client, "app.bundle", "5.2.1", "2440.1.2", Path("key.p8"), True)
        self.assertEqual(result["submission_action"], "submitted")
        self.assertEqual(run.call_args.args[0][:4], ["app-store-connect", "builds", "submit-to-app-store", "new"])
        self.assertNotIn("--whats-new", run.call_args.args[0])

    def test_patch_transport_uses_exact_authenticated_json_endpoint(self):
        client = submit.AppStoreSubmissionClient("key-id", "issuer", Path("unused.p8"))
        payload = {"data": {"type": "builds", "id": "new"}}
        with patch.object(client, "token", return_value="test-token"), patch.object(submit.urllib.request, "urlopen") as send:
            client.patch("/v1/appStoreVersions/version-123/relationships/build", payload)
        request = send.call_args.args[0]
        self.assertEqual(request.get_method(), "PATCH")
        self.assertEqual(request.full_url, "https://api.appstoreconnect.apple.com/v1/appStoreVersions/version-123/relationships/build")
        self.assertEqual(request.headers["Authorization"], "Bearer test-token")
        self.assertEqual(submit.json.loads(request.data), payload)


if __name__ == "__main__":
    unittest.main()
