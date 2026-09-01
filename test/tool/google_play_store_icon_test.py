import base64
import hashlib
import importlib.util
import struct
import unittest
from pathlib import Path


def load_module():
    path = Path("tool/google_play_store_icon.py")
    spec = importlib.util.spec_from_file_location("google_play_store_icon", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def png(width=512, height=512):
    return (
        b"\x89PNG\r\n\x1a\n"
        + struct.pack(">I", 13)
        + b"IHDR"
        + struct.pack(">II", width, height)
        + b"\x08\x02\x00\x00\x00"
    )


class GooglePlayStoreIconTest(unittest.TestCase):
    def setUp(self):
        self.module = load_module()

    def test_validate_icon_accepts_512_png(self):
        self.module.validate_icon(png())

    def test_validate_icon_rejects_wrong_dimensions(self):
        with self.assertRaises(ValueError):
            self.module.validate_icon(png(width=511))

    def test_hash_matches_hex_and_base64(self):
        digest = hashlib.sha256(b"icon").digest()
        self.assertTrue(self.module.hash_matches(digest.hex(), digest))
        self.assertTrue(
            self.module.hash_matches(base64.b64encode(digest).decode(), digest)
        )

    def test_update_store_icon_skips_matching_locales(self):
        digest = hashlib.sha256(b"icon").digest()
        client = FakeClient(digest, matches=True)

        result = self.module.update_store_icon(client, b"icon")

        self.assertFalse(result["changed"])
        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertEqual(client.uploaded_languages, [])

    def test_update_store_icon_replaces_and_verifies_all_locales(self):
        digest = hashlib.sha256(b"icon").digest()
        client = FakeClient(digest, matches=False)

        result = self.module.update_store_icon(client, b"icon", True)

        self.assertTrue(result["changed"])
        self.assertTrue(result["submitted_for_review"])
        self.assertTrue(result["verified"])
        self.assertEqual(client.committed_edits, ["edit-1"])
        self.assertEqual(client.review_submissions, [True])
        self.assertEqual(client.uploaded_languages, ["en-US", "ru-RU"])
        self.assertEqual(client.deleted_edits, ["edit-2"])

    def test_commit_edit_holds_review_unless_explicitly_submitted(self):
        client = self.module.GooglePlayClient("token", "package.name")
        paths = []

        def record(method, path, data=None, content_type=None):
            paths.append(path)
            return {}

        client.request = record

        client.commit_edit("edit-id", False)
        client.commit_edit("edit-id", True)

        self.assertIn("changesNotSentForReview=true", paths[0])
        self.assertIn("changesNotSentForReview=false", paths[1])


class FakeClient:
    def __init__(self, digest, matches):
        self.digest = digest
        self.matches = matches
        self.edit_count = 0
        self.deleted_edits = []
        self.committed_edits = []
        self.review_submissions = []
        self.uploaded_languages = []

    def insert_edit(self):
        self.edit_count += 1
        return f"edit-{self.edit_count}"

    def delete_edit(self, edit_id):
        self.deleted_edits.append(edit_id)

    def commit_edit(self, edit_id, submit_for_review):
        self.committed_edits.append(edit_id)
        self.review_submissions.append(submit_for_review)
        self.matches = True

    def listing_languages(self, edit_id):
        return ["en-US", "ru-RU"]

    def list_icons(self, edit_id, language):
        value = self.digest.hex() if self.matches else "different"
        return [{"sha256": value}]

    def delete_icons(self, edit_id, language):
        pass

    def upload_icon(self, edit_id, language, icon):
        self.uploaded_languages.append(language)
        return {"sha256": self.digest.hex()}


if __name__ == "__main__":
    unittest.main()
