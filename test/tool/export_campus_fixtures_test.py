import hashlib
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location("export_campus_fixtures", ROOT / "tool/export_campus_fixtures.py")
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class ExportCampusFixturesTest(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.assets = self.root / "assets"
        self.assets.mkdir()

    def write(self, campuses, documents=None):
        (self.assets / "catalog.json").write_text(json.dumps({"campuses": [{"id": campus} for campus in campuses]}), encoding="utf-8")
        for campus, document in (documents or {campus: {"id": campus, "organization_id": "sample"} for campus in campuses}).items():
            (self.assets / f"campus_{campus}.json").write_text(json.dumps(document), encoding="utf-8")

    def test_exports_each_catalog_campus_in_one_transaction(self):
        self.write(["a-1", "b2"])
        destination = self.root / "out/fixtures.sql"
        MODULE.export_sql(self.assets, destination)
        sql = destination.read_text(encoding="utf-8")
        self.assertTrue(sql.startswith("begin;\n\nset local standard_conforming_strings = on;\n\n"))
        self.assertTrue(sql.endswith("\n\ncommit;\n"))
        self.assertEqual(sql.count("app_api_v1.publish_map_campus("), 2)
        payload = (self.assets / "campus_a-1.json").read_text(encoding="utf-8").strip()
        delimiter = "$campus_" + hashlib.sha256(payload.encode("utf-8")).hexdigest()[:16] + "$"
        self.assertIn(f"publish_map_campus('a-1', 'sample', {delimiter}{payload}{delimiter}::jsonb, 0);", sql)

    def test_rejects_invalid_catalogs_and_mismatched_documents(self):
        for campuses, documents in (
            ([], None),
            (["a", "a"], None),
            (["Bad_ID"], {"Bad_ID": {"id": "Bad_ID", "organization_id": "sample"}}),
            (["a"], {"a": {"id": "other", "organization_id": "sample"}}),
            (["a"], {"a": {"id": "a", "organization_id": "Sample Org"}}),
            (["a"], {"a": {"id": "a"}}),
        ):
            with self.subTest(campuses=campuses, documents=documents):
                self.write(campuses, documents)
                with self.assertRaises(ValueError):
                    MODULE.export_sql(self.assets, self.root / "fixtures.sql")
                self.assertFalse((self.root / "fixtures.sql").exists())

    def test_bundled_assets_export_and_cli_contract(self):
        destination = self.root / "bundled.sql"
        result = subprocess.run([sys.executable, str(ROOT / "tool/export_campus_fixtures.py"), "--output", str(destination)],
                                cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        catalog = json.loads((ROOT / MODULE.ASSETS / "catalog.json").read_text(encoding="utf-8"))
        self.assertEqual(destination.read_text(encoding="utf-8").count("publish_map_campus("), len(catalog["campuses"]))


if __name__ == "__main__":
    unittest.main()
