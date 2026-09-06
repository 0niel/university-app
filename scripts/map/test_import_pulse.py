import importlib.util
import hashlib
import json
from pathlib import Path
import shutil
import tempfile
import unittest
import xml.etree.ElementTree as ET

SPEC = importlib.util.spec_from_file_location("import_pulse", Path(__file__).with_name("import_pulse.py"))
IMPORTER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(IMPORTER)


class PulseImportTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.record = json.loads((IMPORTER.SOURCE / "v-86_1.json").read_text(encoding="utf-8"))

    def test_wrong_campus_and_floor_rejected(self):
        with self.assertRaises(ValueError):
            IMPORTER.canonicalize("v-78", 1, self.record)
        with self.assertRaises(ValueError):
            IMPORTER.canonicalize("v-86", 2, self.record)

    def test_truncation_rejected(self):
        record = {**self.record, "svg": self.record["svg"][:100] + "[Truncated]"}
        with self.assertRaises(ValueError):
            IMPORTER.canonicalize("v-86", 1, record)

    def test_unreviewed_svg_elements_rejected(self):
        record = {**self.record, "svg": self.record["svg"].replace("</svg>", "<script>alert(1)</script></svg>")}
        with self.assertRaises(ValueError):
            IMPORTER.canonicalize("v-86", 1, record)

    def test_identifiers_survive_style_changes(self):
        first = IMPORTER.canonicalize("v-86", 1, self.record)[1]
        record = {**self.record, "svg": self.record["svg"].replace("#141414", "#131313")}
        second = IMPORTER.canonicalize("v-86", 1, record)[1]
        self.assertEqual([r["id"] for r in first], [r["id"] for r in second])

    def test_all_real_assets_are_bounded_and_complete(self):
        total = 0
        for campus, info in IMPORTER.CAMPUSES.items():
            ids = set()
            for level in info[3]:
                record = json.loads((IMPORTER.SOURCE / f"{campus}_{level}.json").read_text(encoding="utf-8"))
                floor, rooms, _ = IMPORTER.canonicalize(campus, level, record)
                svg = ET.fromstring(floor["svg"])
                svg_ids = {x.attrib["data-object"] for x in svg.iter() if "data-object" in x.attrib}
                self.assertEqual(svg_ids, {r["id"] for r in rooms})
                self.assertEqual(len(svg_ids), len(rooms))
                self.assertFalse(ids & svg_ids)
                ids.update(svg_ids)
                self.assertLessEqual(max(floor["width"], floor["height"]), 2000)
                self.assertFalse(any(x.tag.endswith("}text") for x in svg.iter()))
                for element in svg.iter():
                    if "stroke-width" in element.attrib:
                        self.assertGreaterEqual(float(element.attrib["stroke-width"]) * floor["source_coordinate_scale"], 1.5 - 1e-8)
                self.assertEqual(floor["anchors"], [])
                for room in rooms:
                    self.assertTrue(0 <= room["x"] <= floor["width"])
                    self.assertTrue(0 <= room["y"] <= floor["height"])
                    self.assertEqual(room["equipment"], [])
                    self.assertEqual(room["menu"], [])
                total += 1
        self.assertEqual(total, 17)

    def test_build_is_deterministic(self):
        with tempfile.TemporaryDirectory() as temporary:
            first, second = Path(temporary) / "a", Path(temporary) / "b"
            source = Path(temporary) / "source"
            source.mkdir()
            for capture in IMPORTER.SOURCE.glob("*_[0-9]*.json"):
                shutil.copyfile(capture, source / capture.name)
            IMPORTER.build(source=source, output=first)
            IMPORTER.build(source=source, output=second)
            self.assertEqual({p.name: p.read_bytes() for p in first.iterdir()}, {p.name: p.read_bytes() for p in second.iterdir()})
            provenance = json.loads((first / "provenance.json").read_text(encoding="utf-8"))
            for entry in provenance["campuses"]:
                self.assertEqual(entry["sha256"], hashlib.sha256((first / entry["asset"]).read_bytes()).hexdigest())

    def test_native_shapes_keep_geometry_and_have_stable_source_identifiers(self):
        captures = list(IMPORTER.SOURCE.glob("*_plan.json"))
        self.assertGreaterEqual(len(captures), 2)
        for path in captures:
            capture = json.loads(path.read_text(encoding="utf-8"))
            document, floors, rooms = IMPORTER.prepare_native_campus(capture["campus"], capture)
            self.assertEqual(document['source_captured_at'], capture['captured_at'])
            self.assertEqual(document['location_source']['type'], 'existing_application_catalog')
            self.assertTrue(55 < document['latitude'] < 56)
            self.assertTrue(37 < document['longitude'] < 38)
            self.assertEqual(len(document["rooms"]), len(rooms))
            self.assertEqual(len(document["floors"]), len(floors))
            metadata = {room["id"]: room for room in document["rooms"]}
            for floor in document["floors"]:
                elements = ET.fromstring(floor["svg"]).iter()
                ids = {element.attrib["data-object"] for element in elements if "data-object" in element.attrib}
                self.assertEqual(ids, {room["id"] for room in document["rooms"] if room["floor_id"] == floor["id"]})
                self.assertAlmostEqual(floor["meters_per_unit"] * floor["source_coordinate_scale"], 0.01)
                for room_id in ids:
                    room = metadata[room_id]
                    self.assertEqual(room["source_id_kind"], "native_area")
                    self.assertTrue(room["legacy_ids"][0].startswith("pulse-"))
                    self.assertEqual(rooms[(room["source_layer_id"], room["source_room_id"])], room_id)
            self.assertNotIn("graph", document)

    def test_display_floor_labels_override_internal_numbers(self):
        capture = json.loads((IMPORTER.SOURCE / "v-86_plan.json").read_text(encoding="utf-8"))
        document, mapping, _ = IMPORTER.prepare_native_campus("v-86", capture)
        self.assertEqual(mapping["floor-3"]["id"], "v-86-floor1")
        self.assertEqual(mapping["floor-3"]["level"], 1)
        floor = next(floor for floor in document["floors"] if floor["id"] == "v-86-floor1")
        self.assertEqual(floor["source_internal_level"], 3)

    def test_curved_wall_samples_retain_source_endpoints_and_direction(self):
        plan = json.loads((IMPORTER.SOURCE / "v-78_plan.json").read_text(encoding="utf-8"))["plan"]
        count = 0
        for layer in plan["layers"].values():
            for line in layer["lines"].values():
                if not line.get("properties", {}).get("isBezier"):
                    continue
                points = IMPORTER._GEOMETRY.sample_wall(layer, line)
                start, end = (layer["vertices"][key] for key in line["vertices"][:2])
                self.assertEqual(points[0], (start["x"], -start["y"]))
                self.assertEqual(points[-1], (end["x"], -end["y"]))
                self.assertGreaterEqual(len(points), 13)
                count += 1
        self.assertGreater(count, 0)

    def test_pulse_refresh_preserves_other_campuses(self):
        with tempfile.TemporaryDirectory() as temporary:
            output, source = Path(temporary) / "output", Path(temporary) / "source"
            output.mkdir()
            source.mkdir()
            for capture in IMPORTER.SOURCE.glob("*_[0-9]*.json"):
                shutil.copyfile(capture, source / capture.name)
            (output / "catalog.json").write_text(json.dumps({"campuses": [{"id": "mp-1", "title": "МП-1"}]}), encoding="utf-8")
            IMPORTER.build(source=source, output=output)
            catalog = json.loads((output / "catalog.json").read_text(encoding="utf-8"))
            self.assertEqual([entry["id"] for entry in catalog["campuses"]], ["v-78", "v-86", "s-20", "mp-1"])

    def test_sql_export_requires_initial_revision_without_running_queries(self):
        with tempfile.TemporaryDirectory() as temporary:
            destination = Path(temporary) / "publish.sql"
            IMPORTER.export_sql(IMPORTER.OUTPUT, destination)
            sql = destination.read_text(encoding="utf-8")
            catalog = json.loads((IMPORTER.OUTPUT / "catalog.json").read_text(encoding="utf-8"))
            self.assertEqual(sql.count("select app_api_v1.publish_map_campus("), len(catalog["campuses"]))
            self.assertEqual(sql.count("::jsonb, 0);"), len(catalog["campuses"]))
            for entry in catalog["campuses"]:
                self.assertIn(f"publish_map_campus('{entry['id']}', 'mirea', ", sql)
            self.assertTrue(sql.startswith("begin;"))
            self.assertTrue(sql.endswith("commit;\n"))

    def test_sql_export_rejects_unsafe_catalog_identifier(self):
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            (directory / "catalog.json").write_text(json.dumps({"campuses": [{"id": "../bad"}]}), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "Invalid publication campus ID"):
                IMPORTER.export_sql(directory, directory / "publish.sql")
            self.assertFalse((directory / "publish.sql").exists())


if __name__ == "__main__":
    unittest.main()
