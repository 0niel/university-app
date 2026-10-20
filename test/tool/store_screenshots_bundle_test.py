import hashlib
import importlib.util
import json
import tempfile
import unittest
import zipfile
from pathlib import Path


SPEC = importlib.util.spec_from_file_location("store_screenshots_bundle", "tool/store_screenshots_bundle.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class StoreScreenshotBundleTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.archive = self.root / "bundle.zip"

    def bundle(self, *, extra=None, corrupt_asset=False):
        assets = [{"path": name, "sha256": hashlib.sha256(name.encode()).hexdigest()}
                  for name in sorted(MODULE.ASSET_NAMES)]
        with zipfile.ZipFile(self.archive, "w") as archive:
            for asset in assets:
                archive.writestr(asset["path"], b"corrupt" if corrupt_asset else asset["path"].encode())
            archive.writestr("manifest.json", json.dumps({"assets": assets}))
            if extra:
                archive.writestr(extra, b"unexpected")
        return hashlib.sha256(self.archive.read_bytes()).hexdigest()

    def test_exact_bundle_is_verified_and_extracted(self):
        checksum = self.bundle()
        result = MODULE.extract_bundle(self.archive, checksum, self.root / "assets")
        self.assertEqual(len(result["assets"]), 12)
        self.assertEqual((self.root / "assets/android/01-home.png").read_bytes(), b"android/01-home.png")

    def test_checksum_mismatch_does_not_create_destination(self):
        self.bundle()
        with self.assertRaisesRegex(ValueError, "archive checksum"):
            MODULE.extract_bundle(self.archive, "0" * 64, self.root / "assets")
        self.assertFalse((self.root / "assets").exists())

    def test_unexpected_or_traversing_members_are_rejected(self):
        for extra in ("../escaped.png", "tool/script.py", "android/07-extra.png"):
            checksum = self.bundle(extra=extra)
            with self.assertRaisesRegex(ValueError, "only the twelve"):
                MODULE.extract_bundle(self.archive, checksum, self.root / "assets")
            self.assertFalse((self.root / "assets").exists())

    def test_asset_hash_mismatch_rejects_before_extraction(self):
        checksum = self.bundle(corrupt_asset=True)
        with self.assertRaisesRegex(ValueError, "Screenshot checksum"):
            MODULE.extract_bundle(self.archive, checksum, self.root / "assets")
        self.assertFalse((self.root / "assets").exists())

    def test_existing_destination_is_preserved(self):
        checksum = self.bundle()
        destination = self.root / "assets"
        destination.mkdir()
        marker = destination / "keep"
        marker.write_bytes(b"keep")
        with self.assertRaisesRegex(ValueError, "must not exist"):
            MODULE.extract_bundle(self.archive, checksum, destination)
        self.assertEqual(marker.read_bytes(), b"keep")


if __name__ == "__main__":
    unittest.main()
