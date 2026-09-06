from collections import Counter
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
import xml.etree.ElementTree as ET


SPEC = importlib.util.spec_from_file_location('import_mp1', Path(__file__).with_name('import_mp1.py'))
IMPORTER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(IMPORTER)


class Mp1ImportTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.labels = json.loads(IMPORTER.LABELS.read_text(encoding='utf-8'))['floors']

    def source(self, level):
        return (IMPORTER.SOURCE / f'{level}.svg').read_text(encoding='utf-8')

    def test_all_original_geometry_and_transcribed_labels_preserved(self):
        counts = []
        for level in IMPORTER.LEVELS:
            source = self.source(level)
            floor, rooms = IMPORTER.canonicalize(level, source, self.labels[str(level)])
            original = ET.fromstring(source)
            for element in original.iter():
                element.tag = element.tag.split('}')[-1]
            expected_paths = Counter(element.get('d') for element in original.iter('path'))
            for room in rooms:
                if room.get('source_label_path'):
                    expected_paths.subtract([room['source_label_path']])
            converted = ET.fromstring(floor['svg'])
            for element in converted.iter():
                element.tag = element.tag.split('}')[-1]
            actual_paths = Counter(element.get('d') for element in converted.iter('path'))
            self.assertTrue(all(actual_paths[d] >= count for d, count in expected_paths.items()))
            self.assertEqual(len(list(original.iter('rect'))), len(list(converted.iter('rect'))))
            self.assertEqual(len(list(converted.iter('use'))), 0)
            self.assertEqual({e.get('data-object') for e in converted.iter() if e.get('data-object')}, {r['id'] for r in rooms})
            self.assertTrue(all(0 <= r['x'] <= floor['width'] and 0 <= r['y'] <= floor['height'] for r in rooms))
            self.assertTrue(all(r['label_status'] == 'source_vector_transcription' for r in rooms if r['kind'] != 'stairs'))
            counts.append(sum(r['kind'] != 'stairs' for r in rooms))
        self.assertEqual(counts, [67, 88, 70, 72, 75, 46])

    def test_changed_glyph_requires_review(self):
        labels = [dict(label) for label in self.labels['1']]
        labels[0]['glyph_sha256'] = '0'*64
        with self.assertRaisesRegex(ValueError, 'source glyph changed'):
            IMPORTER.canonicalize(1, self.source(1), labels)

    def test_ids_survive_palette_changes(self):
        first = IMPORTER.canonicalize(1, self.source(1), self.labels['1'])[1]
        second = IMPORTER.canonicalize(1, self.source(1).replace('#8E96FF', '#778899'), self.labels['1'])[1]
        self.assertEqual([r['id'] for r in first], [r['id'] for r in second])

    def test_deterministic_bundle_has_no_inferred_graph_or_equipment(self):
        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder)
            IMPORTER.build(output)
            first = (output / 'campus_mp-1.json').read_bytes()
            IMPORTER.build(output)
            self.assertEqual(first, (output / 'campus_mp-1.json').read_bytes())
            campus = json.loads(first)
            self.assertEqual(campus['graph'], {'nodes': [], 'edges': []})
            self.assertTrue(all(not r['equipment'] and not r['menu'] for r in campus['rooms']))
            self.assertTrue(all(not floor['anchors'] for floor in campus['floors']))
            self.assertEqual(len(campus['rooms']), 488)

    def test_external_and_cyclic_references_are_rejected(self):
        for svg in ('<svg><use href="https://example.com/a"/></svg>',
                    '<svg><g id="a"><use href="#a"/></g></svg>'):
            with self.assertRaises(ValueError):
                IMPORTER.expand_uses(ET.fromstring(svg))


if __name__ == '__main__':
    unittest.main()
