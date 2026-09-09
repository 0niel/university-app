import contextlib
import hashlib
import importlib.util
import io
import json
import plistlib
import tempfile
import unittest
import warnings
import zipfile
from pathlib import Path


class IosArtifactCheckTest(unittest.TestCase):
    def setUp(self):
        spec = importlib.util.spec_from_file_location('ios_artifact_check', Path('tool/ios_artifact_check.py'))
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        self.ipa = self.root / 'University.ipa'
        self.metadata = {
            'CFBundleIdentifier': 'pro.oniel.it.university',
            'CFBundleShortVersionString': '5.2.1',
            'CFBundleVersion': '2443.18.9',
            'UIBackgroundModes': ['fetch', 'remote-notification'],
            'NSLocationWhenInUseUsageDescription': 'Show your position on the map.',
        }

    def write_ipa(self, additions=None, binary=True):
        with zipfile.ZipFile(self.ipa, 'w') as archive:
            archive.writestr(
                'Payload/University.app/Info.plist',
                plistlib.dumps(self.metadata, fmt=plistlib.FMT_BINARY if binary else plistlib.FMT_XML),
            )
            for name, metadata in (additions or {}).items():
                archive.writestr(name, plistlib.dumps(metadata))

    def check(self, **kwargs):
        return self.module.verify_ipa(self.ipa, 'pro.oniel.it.university', **kwargs)

    def test_valid_binary_metadata_and_sanitized_output(self):
        self.write_ipa({'Payload/University.app/PlugIns/Widget.appex/Info.plist': {'CFBundleIdentifier': 'widget'}})
        result = self.check(marketing_version='5.2.1', build_number='2443.18.9')
        self.assertEqual(result, {
            'artifact_sha256': hashlib.sha256(self.ipa.read_bytes()).hexdigest(),
            'bundle_id': 'pro.oniel.it.university',
            'marketing_version': '5.2.1',
            'build_number': '2443.18.9',
            'background_modes': ['fetch', 'remote-notification'],
            'metadata_plists_checked': 2,
        })

    def test_xml_metadata_and_single_artifact_directory(self):
        self.write_ipa(binary=False)
        result = self.module.verify_ipa(self.root, 'pro.oniel.it.university')
        self.assertEqual(result['build_number'], '2443.18.9')

    def test_main_location_mode_rejected(self):
        self.metadata['UIBackgroundModes'].append('location')
        self.write_ipa()
        with self.assertRaisesRegex(ValueError, 'Persistent background location'):
            self.check()

    def test_embedded_bundle_location_mode_rejected(self):
        for embedded in ('PlugIns/Widget.appex', 'Frameworks/Dependency.framework', 'Watch/Watch.app'):
            with self.subTest(embedded=embedded):
                self.write_ipa({f'Payload/University.app/{embedded}/Info.plist': {'UIBackgroundModes': ['location']}})
                with self.assertRaisesRegex(ValueError, 'Persistent background location'):
                    self.check()

    def test_always_usage_keys_rejected_in_main_and_embedded_bundle(self):
        for key in self.module.ALWAYS_USAGE_KEYS:
            with self.subTest(key=key):
                self.metadata[key] = ''
                self.write_ipa()
                with self.assertRaisesRegex(ValueError, 'Always location'):
                    self.check()
                del self.metadata[key]
                self.write_ipa({'Payload/University.app/PlugIns/Widget.appex/Info.plist': {key: 'Background use'}})
                with self.assertRaisesRegex(ValueError, 'Always location'):
                    self.check()

    def test_missing_or_empty_foreground_purpose_rejected(self):
        for value in ('', '  ', 1, None):
            with self.subTest(value=value):
                self.metadata.pop('NSLocationWhenInUseUsageDescription', None)
                if value is not None:
                    self.metadata['NSLocationWhenInUseUsageDescription'] = value
                self.write_ipa()
                with self.assertRaisesRegex(ValueError, 'Foreground location'):
                    self.check()

    def test_wrong_bundle_id_rejected(self):
        self.metadata['CFBundleIdentifier'] = 'other.app'
        self.write_ipa()
        with self.assertRaisesRegex(ValueError, 'application identifier'):
            self.check()

    def test_expected_version_and_build_mismatch_rejected(self):
        self.write_ipa()
        for expected in ({'marketing_version': '5.2.2'}, {'build_number': '2442.11.9'}):
            with self.subTest(expected=expected), self.assertRaisesRegex(ValueError, 'Unexpected'):
                self.check(**expected)

    def test_invalid_version_fields_rejected(self):
        for key, value in (('CFBundleVersion', '1.999.0'), ('CFBundleVersion', 1), ('CFBundleShortVersionString', '5.x')):
            with self.subTest(key=key, value=value):
                original = self.metadata[key]
                self.metadata[key] = value
                self.write_ipa()
                with self.assertRaisesRegex(ValueError, 'Invalid'):
                    self.check()
                self.metadata[key] = original

    def test_malformed_background_modes_rejected(self):
        for value in ('location', ['fetch', 1], {'location': True}):
            with self.subTest(value=value):
                self.metadata['UIBackgroundModes'] = value
                self.write_ipa()
                with self.assertRaisesRegex(ValueError, 'array of strings'):
                    self.check()

    def test_no_background_modes_allowed(self):
        del self.metadata['UIBackgroundModes']
        self.write_ipa()
        self.assertEqual(self.check()['background_modes'], [])

    def test_multiple_or_missing_application_bundles_rejected(self):
        self.write_ipa({'Payload/Other.app/Info.plist': self.metadata})
        with self.assertRaisesRegex(ValueError, 'Exactly one application'):
            self.check()
        self.write_ipa({'Payload/Other.app/Resource.plist': {}})
        with self.assertRaisesRegex(ValueError, 'Exactly one application'):
            self.check()
        with zipfile.ZipFile(self.ipa, 'w') as archive:
            archive.writestr('Info.plist', plistlib.dumps(self.metadata))
        with self.assertRaisesRegex(ValueError, 'Exactly one application'):
            self.check()

    def test_duplicate_zip_entries_rejected(self):
        with warnings.catch_warnings():
            warnings.simplefilter('ignore', UserWarning)
            self.write_ipa({'Payload/University.app/Info.plist': self.metadata})
        with self.assertRaisesRegex(ValueError, 'Duplicate artifact'):
            self.check()

    def test_non_dictionary_embedded_metadata_rejected(self):
        self.write_ipa({'Payload/University.app/Frameworks/Dependency.framework/Info.plist': []})
        with self.assertRaisesRegex(ValueError, 'dictionary'):
            self.check()

    def test_directory_requires_exactly_one_ipa(self):
        with self.assertRaisesRegex(ValueError, 'Exactly one iOS artifact'):
            self.module.verify_ipa(self.root, 'pro.oniel.it.university')
        self.write_ipa()
        (self.root / 'Other.ipa').write_bytes(self.ipa.read_bytes())
        with self.assertRaisesRegex(ValueError, 'Exactly one iOS artifact'):
            self.module.verify_ipa(self.root, 'pro.oniel.it.university')

    def test_cli_success_outputs_json(self):
        self.write_ipa()
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            self.assertEqual(self.module.main(['--ipa', str(self.ipa), '--bundle-id', 'pro.oniel.it.university']), 0)
        self.assertEqual(json.loads(output.getvalue())['marketing_version'], '5.2.1')

    def test_cli_rejects_unreadable_or_invalid_ipa(self):
        for contents in (None, b'broken archive'):
            if contents is not None:
                self.ipa.write_bytes(contents)
            output = io.StringIO()
            with contextlib.redirect_stderr(output), self.assertRaises(SystemExit) as error:
                self.module.main(['--ipa', str(self.ipa), '--bundle-id', 'pro.oniel.it.university'])
            self.assertEqual(error.exception.code, 1)
            self.assertNotIn(str(self.ipa), output.getvalue())


if __name__ == '__main__':
    unittest.main()
