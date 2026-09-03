import importlib.util
import json
import sys
import unittest
import urllib.parse
from pathlib import Path
from unittest.mock import patch


def load_module():
    path = Path("tool/google_play_internal_release.py")
    tool_path = str(path.parent.resolve())
    if tool_path not in sys.path:
        sys.path.insert(0, tool_path)
    spec = importlib.util.spec_from_file_location(
        "google_play_internal_release",
        path,
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class GooglePlayInternalReleaseTest(unittest.TestCase):
    def setUp(self):
        self.module = load_module()

    def test_publishes_bundle_with_fail_closed_commit(self):
        client = FakeClient()

        result = self.module.publish_internal_release(
            client,
            b"PKbundle",
            "v5.2.0-beta.1002501",
        )

        self.assertEqual(result["version_code"], 1002501)
        self.assertFalse(result["already_published"])
        self.assertEqual(
            client.updated,
            [("edit-1", "v5.2.0-beta.1002501", 1002501)],
        )
        self.assertEqual(client.committed, ["edit-1"])
        self.assertEqual(client.deleted, [])

    def test_skips_release_already_present_on_internal_track(self):
        client = FakeClient(existing_version_codes=["1002501"])

        result = self.module.publish_internal_release(
            client,
            b"PKbundle",
            "v5.2.0-beta.1002501",
        )

        self.assertTrue(result["already_published"])
        self.assertEqual(result["version_codes"], ["1002501"])
        self.assertEqual(client.uploads, [])
        self.assertEqual(client.committed, [])
        self.assertEqual(client.deleted, ["edit-1"])

    def test_fails_and_deletes_edit_when_changes_are_in_review(self):
        client = FakeClient(review_in_progress=True)

        with self.assertRaisesRegex(RuntimeError, "CHANGES_ALREADY_IN_REVIEW"):
            self.module.publish_internal_release(
                client,
                b"PKbundle",
                "v5.2.0-beta.1002501",
            )

        self.assertEqual(client.uploads, ["edit-1"])
        self.assertEqual(client.deleted, ["edit-1"])

    def test_deletes_edit_when_track_update_fails(self):
        client = FakeClient(fail_update=True)

        with self.assertRaises(RuntimeError):
            self.module.publish_internal_release(
                client,
                b"PKbundle",
                "release.1002501",
            )

        self.assertEqual(client.deleted, ["edit-1"])

    def test_commit_request_is_fail_closed(self):
        client = self.module.GooglePlayReleaseClient("token", "package.name")
        requests = []

        def record(method, path, data=None, content_type=None):
            requests.append((method, path, data, content_type))
            return {}

        client.request = record
        client.commit_release_edit("edit-id")

        self.assertEqual(requests[0][0], "POST")
        self.assertEqual(
            requests[0][1],
            "/applications/package.name/edits/edit-id:commit"
            "?changesInReviewBehavior=ERROR_IF_IN_REVIEW",
        )

    def test_commit_omits_changes_not_sent_for_review(self):
        client = self.module.GooglePlayReleaseClient("token", "package.name")

        with patch("google_play_store_icon.request_json", return_value={}) as send:
            client.commit_release_edit("edit-id")

        send.assert_called_once()
        request = send.call_args.args[0]
        query = urllib.parse.parse_qs(
            urllib.parse.urlsplit(request.full_url).query,
            keep_blank_values=True,
        )
        self.assertNotIn("changesNotSentForReview", query)
        self.assertEqual(
            query["changesInReviewBehavior"],
            ["ERROR_IF_IN_REVIEW"],
        )
        self.assertEqual(request.get_method(), "POST")
        self.assertEqual(request.data, b"")

    def test_track_payload_replaces_internal_release(self):
        client = self.module.GooglePlayReleaseClient("token", "package.name")
        requests = []

        def record(method, path, data=None, content_type=None):
            requests.append((method, path, data, content_type))
            return {}

        client.request = record
        client.update_internal_track("edit-id", "release", 1002501)
        payload = json.loads(requests[0][2])

        self.assertEqual(requests[0][0], "PUT")
        self.assertEqual(payload["track"], "internal")
        self.assertEqual(payload["releases"][0]["versionCodes"], ["1002501"])
        self.assertEqual(payload["releases"][0]["status"], "completed")

    def test_finds_existing_release_by_exact_name(self):
        client = self.module.GooglePlayReleaseClient("token", "package.name")

        def record(method, path, data=None, content_type=None):
            return {
                "releases": [
                    {
                        "name": "another-release",
                        "status": "completed",
                        "versionCodes": ["1002401"],
                    },
                    {
                        "name": "release",
                        "status": "completed",
                        "versionCodes": ["1002501"],
                    },
                ]
            }

        client.request = record

        self.assertEqual(
            client.internal_release_version_codes(
                "edit-id",
                "release",
                "1002501",
            ),
            ["1002501"],
        )

    def test_ignores_non_completed_or_wrong_version_release(self):
        client = self.module.GooglePlayReleaseClient("token", "package.name")

        def record(method, path, data=None, content_type=None):
            return {
                "releases": [
                    {
                        "name": "release",
                        "status": "draft",
                        "versionCodes": ["1002501"],
                    },
                    {
                        "name": "release",
                        "status": "completed",
                        "versionCodes": ["1002401"],
                    },
                ]
            }

        client.request = record

        self.assertEqual(
            client.internal_release_version_codes(
                "edit-id",
                "release",
                "1002501",
            ),
            [],
        )


class FakeClient:
    def __init__(
        self,
        fail_update=False,
        review_in_progress=False,
        existing_version_codes=None,
    ):
        self.fail_update = fail_update
        self.review_in_progress = review_in_progress
        self.existing_version_codes = existing_version_codes or []
        self.edit_count = 0
        self.uploads = []
        self.updated = []
        self.committed = []
        self.deleted = []

    def insert_edit(self):
        self.edit_count += 1
        return f"edit-{self.edit_count}"

    def upload_bundle(self, edit_id, bundle):
        self.uploads.append(edit_id)
        return 1002501

    def internal_release_version_codes(
        self,
        edit_id,
        release_name,
        expected_version_code,
    ):
        if expected_version_code not in self.existing_version_codes:
            return []
        return self.existing_version_codes

    def update_internal_track(self, edit_id, release_name, version_code):
        if self.fail_update:
            raise RuntimeError("track update failed")
        self.updated.append((edit_id, release_name, version_code))

    def commit_release_edit(self, edit_id):
        if self.review_in_progress:
            raise RuntimeError("CHANGES_ALREADY_IN_REVIEW")
        self.committed.append(edit_id)

    def delete_edit(self, edit_id):
        self.deleted.append(edit_id)


if __name__ == "__main__":
    unittest.main()
