import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import align_campus_maps as alignment


class AlignmentPublicationTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.assets = Path(self.temporary.name)
        self.registrations = json.loads(
            (alignment.ROOT / 'scripts/map/source/georeference_registration.json').read_text(encoding='utf-8')
        )['campuses']
        for source in alignment.ASSETS.glob('*.json'):
            payload = source.read_text(encoding='utf-8').replace('\n', '\r\n')
            (self.assets / source.name).write_bytes(payload.encode('utf-8'))

    def test_cross_platform_hashes_and_original_mp1_credit(self):
        with patch.object(alignment, 'ASSETS', self.assets):
            alignment.apply_registrations(self.registrations)
            before = {path.name: path.read_bytes() for path in self.assets.glob('*.json')}
            alignment.apply_registrations(self.registrations)
        provenance = json.loads((self.assets / 'provenance.json').read_bytes())
        for entry in provenance['campuses']:
            payload = (self.assets / entry['asset']).read_bytes()
            self.assertEqual(hashlib.sha256(payload).hexdigest(), entry['sha256'])
            self.assertNotIn(b'\r\n', payload)
            self.assertEqual(payload, before[entry['asset']])
        mp1 = json.loads((self.assets / 'campus_mp-1.json').read_bytes())
        for floor in mp1['floors']:
            source = floor['georeference']['sources'][-1]
            self.assertEqual(source['url'], mp1['source_url'])
            self.assertEqual(source['label'], mp1['source_label'])

    def test_changed_last_floor_preserves_all_files(self):
        campus_id = self.registrations[-1]['campus_id']
        path = self.assets / f'campus_{campus_id}.json'
        campus = json.loads(path.read_bytes())
        campus['floors'][-1]['width'] += 1
        path.write_text(json.dumps(campus), encoding='utf-8')
        before = {path.name: path.read_bytes() for path in self.assets.glob('*.json')}
        with patch.object(alignment, 'ASSETS', self.assets), self.assertRaises(ValueError):
            alignment.apply_registrations(self.registrations)
        self.assertEqual(before, {path.name: path.read_bytes() for path in self.assets.glob('*.json')})


if __name__ == '__main__':
    unittest.main()
