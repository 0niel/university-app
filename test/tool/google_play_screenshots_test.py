import base64
import copy
import hashlib
import importlib.util
import json
import struct
import sys
import tempfile
import unittest
import zlib
from pathlib import Path
from unittest.mock import Mock


sys.path.insert(0, str(Path("tool").resolve()))
SPEC = importlib.util.spec_from_file_location(
    "google_play_screenshots", Path("tool/google_play_screenshots.py")
)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


def chunk(kind, data):
    return (
        struct.pack(">I", len(data)) + kind + data
        + struct.pack(">I", zlib.crc32(kind + data))
    )


def png(*, width=1080, height=1920, depth=8, color=2, transparent=False, tag=b"0"):
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, depth, color, 0, 0, 0))
        + (chunk(b"tRNS", b"\x00" * 6) if transparent else b"")
        + chunk(b"tEXt", b"fixture\x00" + tag)
        + chunk(b"IDAT", zlib.compress(b"\x00\x00\x00\x00"))
        + chunk(b"IEND", b"")
    )


def assets():
    result = []
    for number in range(1, 7):
        content = png(tag=str(number).encode())
        result.append({
            "filename": f"{number:02d}-screen.png",
            "content": content,
            "sha256": hashlib.sha256(content).hexdigest(),
            "bytes": len(content),
        })
    return result


class FakeClient:
    def __init__(self, expected, *, matches=False):
        self.expected = expected
        self.current = {
            language: (
                [{"id": str(index), "sha256": asset["sha256"]}
                 for index, asset in enumerate(expected)]
                if matches else [{"id": "old", "sha256": "old", "url": "https://example.test/old.png"}]
            )
            for language in ("en-US", "ru-RU")
        }
        self.edit_count = 0
        self.edits = {}
        self.deleted_edits = []
        self.deleted_languages = []
        self.uploaded_languages = []
        self.commits = []
        self.wrong_upload_hash = False
        self.reverse_before_commit = False
        self.reverse_after_commit = False
        self.commit_error = False

    def insert_edit(self):
        self.edit_count += 1
        edit_id = f"edit-{self.edit_count}"
        self.edits[edit_id] = copy.deepcopy(self.current)
        if self.reverse_after_commit and self.commits:
            self.edits[edit_id]["ru-RU"].reverse()
        return edit_id

    def delete_edit(self, edit_id):
        self.deleted_edits.append(edit_id)
        del self.edits[edit_id]

    def listing_languages(self, edit_id):
        return sorted(self.edits[edit_id])

    def list_screenshots(self, edit_id, language):
        values = copy.deepcopy(self.edits[edit_id][language])
        if self.reverse_before_commit and self.uploaded_languages and len(values) == 6:
            values.reverse()
        return values

    def delete_screenshots(self, edit_id, language):
        self.deleted_languages.append(language)
        self.edits[edit_id][language] = []

    def upload_screenshot(self, edit_id, language, content):
        self.uploaded_languages.append(language)
        digest = hashlib.sha256(content).digest()
        value = {
            "id": str(len(self.edits[edit_id][language])),
            "sha256": base64.b64encode(digest).decode(),
        }
        self.edits[edit_id][language].append(value)
        return {**value, "sha256": "unexpected"} if self.wrong_upload_hash else value

    def commit_edit(self, edit_id, submit_for_review):
        if self.commit_error:
            raise RuntimeError("Commit rejected")
        self.commits.append((edit_id, submit_for_review))
        self.current = self.edits.pop(edit_id)


class GooglePlayScreenshotsTest(unittest.TestCase):
    def test_replacing_review_requires_explicit_apply_and_submission(self):
        client = Mock()
        with self.assertRaisesRegex(ValueError, "requires --apply"):
            MODULE.update_screenshots(client, assets(), Path('unused'), replace_pending_review=True)
        client.insert_edit.assert_not_called()

    def test_commit_replaces_review_only_with_explicit_flag(self):
        client = MODULE.GooglePlayScreenshotClient('token', 'package.name')
        client.request = Mock(return_value={})
        client.commit_edit('edit', True)
        self.assertIn('ERROR_IF_IN_REVIEW', client.request.call_args.args[1])
        client.commit_edit('edit', True, replace_pending_review=True)
        self.assertIn('CANCEL_IN_REVIEW_AND_SUBMIT', client.request.call_args.args[1])
        client.request.reset_mock()
        with self.assertRaises(ValueError):
            client.commit_edit('edit', False, replace_pending_review=True)
        client.request.assert_not_called()

    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.assets = assets()

    def report(self):
        return json.loads((self.root / "google-play-screenshots.json").read_text())

    def test_preview_backs_up_metadata_without_deleting_or_uploading(self):
        client = FakeClient(self.assets)

        result = MODULE.update_screenshots(client, self.assets, self.root)

        self.assertEqual(result["status"], "inspection_only")
        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertEqual(client.deleted_languages, [])
        self.assertEqual(client.uploaded_languages, [])
        self.assertEqual(client.commits, [])
        self.assertEqual(result["russian_source_fallback_languages"], ["en-US"])
        self.assertEqual(self.report()["previous_images"]["ru-RU"][0]["id"], "old")
        self.assertNotIn("content", self.report()["assets"][0])

    def test_apply_verifies_hashes_and_order_for_each_locale(self):
        client = FakeClient(self.assets)

        result = MODULE.update_screenshots(
            client, self.assets, self.root, apply=True, submit_for_review=True
        )

        self.assertTrue(result["committed"])
        self.assertTrue(result["verified"])
        self.assertEqual(result["status"], "verified_after_commit")
        self.assertEqual(client.commits, [("edit-1", True)])
        self.assertEqual(client.uploaded_languages, ["en-US"] * 6 + ["ru-RU"] * 6)
        self.assertEqual(client.deleted_edits, ["edit-2"])
        self.assertEqual(len(self.report()["previous_images"]["ru-RU"]), 1)
        self.assertTrue(MODULE.screenshots_match(client.current["en-US"], self.assets))

    def test_matching_assets_are_idempotent(self):
        client = FakeClient(self.assets, matches=True)

        result = MODULE.update_screenshots(client, self.assets, self.root, apply=True)

        self.assertEqual(result["status"], "unchanged")
        self.assertTrue(result["verified"])
        self.assertFalse(result["changed"])
        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertEqual(client.commits, [])
        self.assertEqual(client.uploaded_languages, [])

    def test_uploaded_hash_mismatch_discards_edit(self):
        client = FakeClient(self.assets)
        client.wrong_upload_hash = True

        with self.assertRaisesRegex(RuntimeError, "Uploaded screenshot hash"):
            MODULE.update_screenshots(client, self.assets, self.root, apply=True)

        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertEqual(client.commits, [])
        self.assertEqual(client.current["en-US"][0]["id"], "old")
        self.assertEqual(self.report()["status"], "failed")

    def test_reordered_hashes_abort_before_commit(self):
        client = FakeClient(self.assets)
        client.reverse_before_commit = True

        with self.assertRaisesRegex(RuntimeError, "before commit"):
            MODULE.update_screenshots(client, self.assets, self.root, apply=True)

        self.assertEqual(client.commits, [])
        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertFalse(self.report()["commit_attempted"])

    def test_failed_commit_discards_temporary_edit(self):
        client = FakeClient(self.assets)
        client.commit_error = True

        with self.assertRaisesRegex(RuntimeError, "Commit rejected"):
            MODULE.update_screenshots(client, self.assets, self.root, apply=True)

        self.assertEqual(client.deleted_edits, ["edit-1"])
        self.assertTrue(self.report()["commit_attempted"])
        self.assertFalse(self.report()["committed"])
        self.assertEqual(client.current["ru-RU"][0]["id"], "old")

    def test_post_commit_mismatch_reports_committed_without_claiming_verification(self):
        client = FakeClient(self.assets)
        client.reverse_after_commit = True

        with self.assertRaisesRegex(RuntimeError, "after commit"):
            MODULE.update_screenshots(client, self.assets, self.root, apply=True)

        self.assertTrue(self.report()["committed"])
        self.assertFalse(self.report()["verified"])
        self.assertEqual(client.deleted_edits, ["edit-2"])

    def test_language_option_only_changes_requested_existing_listing(self):
        client = FakeClient(self.assets)

        result = MODULE.update_screenshots(
            client, self.assets, self.root, apply=True, languages=["ru-RU"]
        )

        self.assertEqual(result["languages"], ["ru-RU"])
        self.assertEqual(client.uploaded_languages, ["ru-RU"] * 6)
        self.assertEqual(client.current["en-US"][0]["id"], "old")

    def test_missing_requested_listing_is_rejected_before_changes(self):
        client = FakeClient(self.assets)

        with self.assertRaisesRegex(ValueError, "existing store listing"):
            MODULE.update_screenshots(
                client, self.assets, self.root, apply=True, languages=["fr-FR"]
            )

        self.assertEqual(client.uploaded_languages, [])
        self.assertEqual(client.deleted_edits, ["edit-1"])

    def test_submit_flag_requires_explicit_apply(self):
        client = FakeClient(self.assets)

        with self.assertRaisesRegex(ValueError, "requires --apply"):
            MODULE.update_screenshots(
                client, self.assets, self.root, submit_for_review=True
            )

        self.assertEqual(client.edit_count, 0)

    def test_validation_rejects_alpha_palette_transparency_and_wrong_size(self):
        for content in (
            png(color=6), png(color=3), png(depth=16),
            png(transparent=True), png(width=1079), png()[:-1],
        ):
            with self.subTest(header=content[:29]), self.assertRaises(ValueError):
                MODULE.validate_screenshot(content)

    def test_asset_loading_requires_exact_count_and_number_order(self):
        asset_dir = self.root / "assets"
        asset_dir.mkdir()
        for asset in self.assets:
            (asset_dir / asset["filename"]).write_bytes(asset["content"])

        loaded = MODULE.load_assets(asset_dir)

        self.assertEqual([item["sha256"] for item in loaded], [item["sha256"] for item in self.assets])
        (asset_dir / "06-screen.png").rename(asset_dir / "07-screen.png")
        with self.assertRaisesRegex(ValueError, "01-name.png"):
            MODULE.load_assets(asset_dir)
        (asset_dir / "07-screen.png").unlink()
        with self.assertRaisesRegex(ValueError, "Exactly six"):
            MODULE.load_assets(asset_dir)

    def test_client_only_uses_phone_screenshots(self):
        client = MODULE.GooglePlayScreenshotClient("unused", MODULE.PACKAGE_NAME)

        path = client.image_path("edit/1", "ru-RU")

        self.assertEqual(
            path,
            "/applications/ninja.mirea.mireaapp/edits/edit%2F1/listings/ru-RU/phoneScreenshots",
        )


if __name__ == "__main__":
    unittest.main()
