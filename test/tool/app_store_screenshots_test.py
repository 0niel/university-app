import hashlib
import importlib.util
import json
import struct
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch


ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tool"))
SPEC = importlib.util.spec_from_file_location("app_store_screenshots", ROOT / "tool/app_store_screenshots.py")
screenshots = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(screenshots)


def chunk(kind, content=b""):
    return struct.pack(">I", len(content)) + kind + content + b"\0\0\0\0"


def png(width=1320, height=2868, color=2, suffix=b"test"):
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, color, 0, 0, 0)) + chunk(b"IDAT", suffix) + chunk(b"IEND")


def asset(number=1):
    content = png(suffix=str(number).encode())
    return {"filename": f"{number:02d}-screen.png", "content": content, "bytes": len(content), "md5": hashlib.md5(content).hexdigest(), "sha256": hashlib.sha256(content).hexdigest()}


def image(asset, image_id="shot-1", state="COMPLETE"):
    return {"id": image_id, "attributes": {"fileName": asset["filename"], "fileSize": asset["bytes"], "sourceFileChecksum": asset["md5"], "assetDeliveryState": {"state": state}}}


def version(state="PREPARE_FOR_SUBMISSION", build_id="build-1"):
    return {"id": "version-1", "attributes": {"platform": "IOS", "versionString": "5.4.0", "appVersionState": state}, "relationships": {"build": {"data": {"id": build_id}}}}


class AssetTest(unittest.TestCase):
    def test_error_retains_api_detail_without_signed_urls_or_jwt(self):
        value = screenshots.safe_error(RuntimeError('HTTP 400 invalid enum https://store.apple.com/path?Signature=secret Bearer secret eyJheader.payload.signature'))
        self.assertIn("HTTP 400 invalid enum", value)
        self.assertNotIn("secret", value)
        self.assertNotIn("eyJheader", value)
        self.assertLessEqual(len(screenshots.safe_error(RuntimeError("x" * 2000))), 1000)

    def test_jpeg_backup_dimensions(self):
        content = b"\xff\xd8\xff\xc0\x00\x08\x08\x0b\x34\x05\x28\x03\xff\xd9"
        self.assertEqual(screenshots.jpeg_dimensions(content), (1320, 2868))
        with self.assertRaises(ValueError):
            screenshots.jpeg_dimensions(content[:-2])

    def test_real_dimensions_and_no_alpha_are_required(self):
        self.assertEqual(screenshots.png_dimensions(png()), (1320, 2868))
        with self.assertRaises(ValueError):
            screenshots.png_dimensions(png(color=6))
        with self.assertRaises(ValueError):
            screenshots.png_dimensions(png()[:-3])

    def test_six_unique_assets_and_numeric_order(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            for number in reversed(range(1, 7)):
                (directory / f"{number:02d}-screen.png").write_bytes(png(suffix=str(number).encode()))
            self.assertEqual([item["filename"] for item in screenshots.load_assets(directory)], [f"{number:02d}-screen.png" for number in range(1, 7)])
            (directory / "06-screen.png").write_bytes(png(suffix=b"1"))
            with self.assertRaisesRegex(ValueError, "different content"):
                screenshots.load_assets(directory)

    def test_order_checksums_and_processing_state_must_match(self):
        assets = [asset(1), asset(2)]
        images = [image(assets[0]), image(assets[1], "shot-2")]
        self.assertTrue(screenshots.matches(images, assets))
        self.assertFalse(screenshots.matches(list(reversed(images)), assets))
        images[1]["attributes"]["sourceFileChecksum"] = "bad"
        self.assertFalse(screenshots.matches(images, assets))
        self.assertFalse(screenshots.matches([image(assets[0], state="UPLOAD_COMPLETE")], assets[:1]))

    def test_upload_must_cover_source_before_any_request(self):
        operations = [{"offset": 0, "length": 2, "method": "PUT", "url": "https://store.blobstore.apple.com/path?secret=test"}]
        with patch.object(screenshots.urllib.request, "urlopen") as request:
            with self.assertRaisesRegex(RuntimeError, "cover the source"):
                screenshots.upload_parts(b"three", operations)
            request.assert_not_called()

    def test_signed_upload_urls_are_never_sent_authorization(self):
        operations = [{"offset": 0, "length": 3, "method": "PUT", "url": "https://store.blobstore.apple.com/path", "requestHeaders": [{"name": "Authorization", "value": "secret"}]}]
        with patch.object(screenshots.urllib.request, "urlopen") as request:
            with self.assertRaisesRegex(RuntimeError, "credentials"):
                screenshots.upload_parts(b"abc", operations)
            request.assert_not_called()


class ScopeTest(unittest.TestCase):
    def test_in_review_withdrawal_keeps_exact_build(self):
        client = Mock()
        client.get.side_effect = [{"data": version("IN_REVIEW")}, {"data": version("DEVELOPER_REJECTED")}]
        with patch.object(screenshots, "pending_review_submission", return_value="submission-1") as pending:
            screenshots.withdraw_review(client, "app-1", version("IN_REVIEW"), "5.4.0", "build-1")
        self.assertEqual(pending.call_args.args[3], "IN_REVIEW")
        self.assertEqual(client.patch.call_args.args, ("/v1/reviewSubmissions/submission-1", {"data": {"type": "reviewSubmissions", "id": "submission-1", "attributes": {"canceled": True}}}))
        self.assertEqual(client.patch.call_count, 1)

    def test_withdrawal_rejects_changed_build_before_cancel(self):
        client = Mock()
        client.get.return_value = {"data": version("IN_REVIEW", build_id="different")}
        with patch.object(screenshots, "pending_review_submission", return_value="submission-1"):
            with self.assertRaisesRegex(RuntimeError, "version changed"):
                screenshots.withdraw_review(client, "app-1", version("IN_REVIEW"), "5.4.0", "build-1")
        client.patch.assert_not_called()

    def test_in_review_apply_without_flag_is_blocked(self):
        client = Mock()
        build = {"build_id": "build-1", "build_number": "2483.12.49", "marketing_version": "5.4.0", "processing_state": "VALID"}
        with tempfile.TemporaryDirectory() as temporary, patch.object(screenshots, "wait_for_build", return_value=build), patch.object(screenshots, "find_version", return_value=("app-1", version("IN_REVIEW"))), patch.object(screenshots, "inspect_locales", return_value=[{"id": "locale-1", "locale": "ru", "sets": []}]), patch.object(screenshots, "withdraw_review") as withdraw:
            with self.assertRaisesRegex(RuntimeError, "explicit replacement"):
                screenshots.update_screenshots(client, [asset(n) for n in range(1, 7)], Path(temporary), "ninja.test", "5.4.0", "2483.12.49", apply=True)
            withdraw.assert_not_called()

    def test_other_phone_sizes_require_explicit_migration(self):
        client = Mock()
        build = {"build_id": "build-1", "build_number": "2483.12.49", "marketing_version": "5.4.0", "processing_state": "VALID"}
        locales = [{"id": "ru", "locale": "ru", "sets": [{"id": "other-phone", "display_type": "APP_IPHONE_65", "images": [screenshots.screenshot_summary(image(asset()))]}, {"id": "ipad", "display_type": "APP_IPAD_PRO_129", "images": [screenshots.screenshot_summary(image(asset()))]}]}, {"id": "en", "locale": "en-US", "sets": [{"id": "english-phone", "display_type": "APP_IPHONE_65", "images": [screenshots.screenshot_summary(image(asset()))]}]}]
        with tempfile.TemporaryDirectory() as temporary, patch.object(screenshots, "wait_for_build", return_value=build), patch.object(screenshots, "find_version", return_value=("app-1", version())), patch.object(screenshots, "inspect_locales", return_value=locales), patch.object(screenshots, "backup_assets") as backup:
            with self.assertRaisesRegex(RuntimeError, "replace-other-iphone-sizes"):
                screenshots.update_screenshots(client, [asset(n) for n in range(1, 7)], Path(temporary), "ninja.test", "5.4.0", "2483.12.49", apply=True)
            report = json.loads((Path(temporary) / "app-store-screenshots.json").read_text())
            self.assertEqual(report["other_phone_sets"], [{"locale": "ru", "id": "other-phone", "display_type": "APP_IPHONE_65"}])
            backup.assert_not_called()
            client.delete.assert_not_called()

    def test_wrong_build_is_rejected(self):
        client = Mock()
        client.get.side_effect = [{"data": [{"id": "app-1", "attributes": {"bundleId": "ninja.test"}}]}, {"data": [version(build_id="different")]}]
        with self.assertRaisesRegex(RuntimeError, "verified build"):
            screenshots.find_version(client, "ninja.test", "5.4.0", "build-1")
        client.patch.assert_not_called()

    def test_pagination_cannot_silently_skip_old_assets(self):
        client = Mock()
        client.get.return_value = {"data": [], "links": {"next": "https://secret.invalid"}}
        with self.assertRaisesRegex(RuntimeError, "incomplete"):
            screenshots.listed(client, "/v1/appScreenshotSets/set-1/appScreenshots")

    def test_inspection_never_mutates_or_cancels_review(self):
        client = Mock()
        build = {"build_id": "build-1", "build_number": "2483.12.49", "marketing_version": "5.4.0", "processing_state": "VALID"}
        localizations = [{"id": "locale-1", "locale": "ru", "sets": []}, {"id": "locale-en", "locale": "en-US", "sets": []}]
        with tempfile.TemporaryDirectory() as temporary, patch.object(screenshots, "wait_for_build", return_value=build), patch.object(screenshots, "find_version", return_value=("app-1", version("IN_REVIEW"))), patch.object(screenshots, "inspect_locales", return_value=localizations), patch.object(screenshots, "withdraw_review") as replace:
            result = screenshots.update_screenshots(client, [asset(n) for n in range(1, 7)], Path(temporary), "ninja.test", "5.4.0", "2483.12.49")
            self.assertEqual(result["locales_requiring_update"], ["ru"])
            self.assertFalse(result["needs_resubmit"])
            client.post.assert_not_called()
            client.patch.assert_not_called()
            client.delete.assert_not_called()
            replace.assert_not_called()

    def test_pending_review_needs_explicit_cancellation_permission(self):
        client = Mock()
        build = {"build_id": "build-1", "build_number": "2483.12.49", "marketing_version": "5.4.0", "processing_state": "VALID"}
        with tempfile.TemporaryDirectory() as temporary, patch.object(screenshots, "wait_for_build", return_value=build), patch.object(screenshots, "find_version", return_value=("app-1", version("WAITING_FOR_REVIEW"))), patch.object(screenshots, "inspect_locales", return_value=[{"id": "locale-1", "locale": "ru", "sets": []}]):
            with self.assertRaisesRegex(RuntimeError, "explicit replacement"):
                screenshots.update_screenshots(client, [asset(n) for n in range(1, 7)], Path(temporary), "ninja.test", "5.4.0", "2483.12.49", apply=True)
            report = json.loads((Path(temporary) / "app-store-screenshots.json").read_text())
            self.assertEqual(report["status"], "failed")
            self.assertNotIn("secret", json.dumps(report))
            client.patch.assert_not_called()


class ReplacementTest(unittest.TestCase):
    def test_success_uploads_before_deleting_and_verifies_order(self):
        client = Mock()
        old, assets = image(asset(), "old-1"), [asset(2), asset(3)]
        events = []
        def upload(unused_client, set_id, selected, created):
            image_id = "new-" + selected["filename"][:2]
            created.append(image_id)
            events.append("upload")
            return image_id
        client.delete.side_effect = lambda path: events.append("delete")
        client.get.return_value = {"data": [image(assets[0], "new-02"), image(assets[1], "new-03")]}
        with patch.object(screenshots, "upload_asset", side_effect=upload):
            screenshots.replace_set(client, "set-1", assets, [old], [asset()], {})
        self.assertEqual(events, ["upload", "upload", "delete"])
        self.assertEqual(client.patch.call_args.args[1]["data"], [{"type": "appScreenshots", "id": "new-02"}, {"type": "appScreenshots", "id": "new-03"}])

    def test_backup_restore_when_six_assets_exceed_capacity(self):
        client, report = Mock(), {}
        old = [image(asset(n), f"old-{n}") for n in range(1, 6)]
        backups = [asset(n) for n in range(1, 6)]
        client.get.side_effect = [{"data": []}, {"data": [image(backup, "restored-" + backup["filename"][:2]) for backup in backups]}]
        attempts = []
        def upload(unused_client, set_id, selected, created):
            attempts.append(selected["filename"])
            if len(attempts) == 1:
                raise RuntimeError("failed")
            created.append("restored-" + selected["filename"][:2])
        with patch.object(screenshots, "upload_asset", side_effect=upload):
            with self.assertRaises(RuntimeError):
                screenshots.replace_set(client, "set-1", [asset(n) for n in range(7, 13)], old, backups, report)
        self.assertEqual(client.delete.call_count, 5)
        self.assertEqual(attempts[1:], [item["filename"] for item in backups])
        self.assertTrue(report["rollback_succeeded"])

    def test_rollback_success_requires_verified_remote_order_and_hashes(self):
        client, report = Mock(), {}
        old = image(asset(), "old-1")
        client.get.side_effect = [{"data": [old]}, {"data": [image(asset(2), "old-1")]}]
        with patch.object(screenshots, "upload_asset", side_effect=RuntimeError("failed")):
            with self.assertRaises(RuntimeError):
                screenshots.replace_set(client, "set-1", [asset(2)], [old], [asset()], report)
        self.assertFalse(report["rollback_succeeded"])


class MigrationTest(unittest.TestCase):
    def stateful_client(self, fail_id=None):
        target_asset, previous_target = asset(2), asset(1)
        other_assets = [asset(3), asset(4)]
        old_target = [image(previous_target, "old-target")]
        old_other = [image(other_assets[0], "old-other-1"), image(other_assets[1], "old-other-2")]
        remote = {"target": [image(target_asset, "new-target")], "other": list(old_other), "ipad": [image(asset(5), "ipad-shot")], "english": [image(asset(6), "english-shot")]}
        client = Mock()
        client.get.side_effect = lambda path, query: {"data": list(remote[path.split("/")[3]])}
        failed = []
        def delete(path):
            image_id = path.split("/")[-1]
            if image_id == fail_id and not failed:
                failed.append(True)
                raise RuntimeError("Delete failed")
            for images in remote.values():
                images[:] = [item for item in images if item["id"] != image_id]
        def reorder(path, payload):
            set_id = path.split("/")[3]
            by_id = {item["id"]: item for item in remote[set_id]}
            remote[set_id] = [by_id[item["id"]] for item in payload["data"]]
        client.delete.side_effect = delete
        client.patch.side_effect = reorder
        def upload(unused_client, set_id, selected, created):
            image_id = "restored-" + selected["filename"][:2]
            remote[set_id].append(image(selected, image_id))
            created.append(image_id)
        return client, remote, target_asset, old_target, previous_target, old_other, other_assets, upload

    def test_success_removes_only_other_phone_assets_after_target_verification(self):
        client, remote, target, old_target, backup, old_other, other_backups, _ = self.stateful_client()
        report = {}
        screenshots.remove_other_phone_assets(client, "target", [target], old_target, [backup], [("other", old_other, other_backups)], report)
        self.assertEqual(remote["other"], [])
        self.assertEqual(remote["target"][0]["id"], "new-target")
        self.assertEqual(remote["ipad"][0]["id"], "ipad-shot")
        self.assertEqual(remote["english"][0]["id"], "english-shot")
        self.assertEqual(report["cleared_phone_sets"], ["other"])

    def test_partial_delete_failure_restores_old_other_sizes_and_target(self):
        client, remote, target, old_target, backup, old_other, other_backups, upload = self.stateful_client(fail_id="old-other-2")
        report = {}
        with patch.object(screenshots, "upload_asset", side_effect=upload):
            with self.assertRaisesRegex(RuntimeError, "Delete failed"):
                screenshots.remove_other_phone_assets(client, "target", [target], old_target, [backup], [("other", old_other, other_backups)], report)
        self.assertTrue(report["rollback_succeeded"])
        self.assertTrue(screenshots.matches(remote["target"], [backup]))
        self.assertTrue(screenshots.matches(remote["other"], other_backups))
        self.assertEqual(remote["ipad"][0]["id"], "ipad-shot")
        self.assertEqual(remote["english"][0]["id"], "english-shot")

    def test_unverified_target_prevents_deleting_other_sizes(self):
        client, remote, target, old_target, backup, old_other, other_backups, _ = self.stateful_client()
        remote["target"][0]["attributes"]["sourceFileChecksum"] = "wrong"
        with self.assertRaisesRegex(RuntimeError, "verified before"):
            screenshots.remove_other_phone_assets(client, "target", [target], old_target, [backup], [("other", old_other, other_backups)], {})
        client.delete.assert_not_called()

    def test_deletion_requires_complete_backup(self):
        client = Mock()
        with self.assertRaisesRegex(RuntimeError, "complete backup"):
            screenshots.replace_set(client, "set-1", [asset()], [image(asset())], [], {})
        client.delete.assert_not_called()

    def test_old_assets_survive_upload_failure_when_capacity_allows(self):
        client, report = Mock(), {}
        old = image(asset(), "old-1")
        client.get.return_value = {"data": [old]}
        with patch.object(screenshots, "upload_asset", side_effect=RuntimeError("failed")):
            with self.assertRaises(RuntimeError):
                screenshots.replace_set(client, "set-1", [asset(2)], [old], [asset()], report)
        client.delete.assert_not_called()
        self.assertTrue(report["rollback_succeeded"])
        self.assertEqual(client.patch.call_args.args[1]["data"], [{"type": "appScreenshots", "id": "old-1"}])

    def test_concurrent_unknown_asset_blocks_destructive_rollback(self):
        client, report = Mock(), {}
        client.get.return_value = {"data": [image(asset(3), "unknown")]}
        with patch.object(screenshots, "upload_asset", side_effect=RuntimeError("failed")):
            with self.assertRaises(RuntimeError):
                screenshots.replace_set(client, "set-1", [asset(2)], [image(asset(), "old-1")], [asset()], report)
        client.delete.assert_not_called()
        self.assertFalse(report["rollback_succeeded"])


if __name__ == "__main__":
    unittest.main()
