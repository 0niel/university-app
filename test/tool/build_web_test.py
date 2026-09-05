import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location('build_web', ROOT / 'tool/build_web.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


def configuration():
    return {
        'FIREBASE_ENABLED': True,
        'FIREBASE_API_KEY': 'shared-public-key',
        'FIREBASE_WEB_API_KEY': 'web-public-key',
        'FIREBASE_PROJECT_ID': 'test-project',
        'FIREBASE_MESSAGING_SENDER_ID': '123',
        'FIREBASE_WEB_APP_ID': '1:123:web:test',
        'FIREBASE_WEB_VAPID_KEY': 'B' + 'A' * 86,
        'UNRELATED_PRIVATE_VALUE': 'must-not-be-published',
    }


class BuildWebTest(unittest.TestCase):
    def test_only_public_web_fields_are_exposed(self):
        defines, worker = MODULE.public_config(configuration())
        self.assertNotIn('UNRELATED_PRIVATE_VALUE', defines)
        self.assertEqual(worker['firebase']['apiKey'], 'web-public-key')
        self.assertNotIn('vapidKey', worker)
        self.assertEqual(defines['FIREBASE_WEB_VAPID_KEY'], 'B' + 'A' * 86)

    def test_shared_api_key_fallback(self):
        values = configuration()
        del values['FIREBASE_WEB_API_KEY']
        _, worker = MODULE.public_config(values)
        self.assertEqual(worker['firebase']['apiKey'], 'shared-public-key')

    def test_disabled_firebase_needs_no_credentials(self):
        defines, worker = MODULE.public_config({'FIREBASE_ENABLED': 'false'})
        self.assertEqual(defines, {'FIREBASE_ENABLED': False})
        self.assertEqual(worker, {'enabled': False})

    def test_invalid_configuration_fails_before_build(self):
        for key, value in (
            ('FIREBASE_ENABLED', 1),
            ('FIREBASE_WEB_APP_ID', ''),
            ('FIREBASE_WEB_VAPID_KEY', ''),
            ('FIREBASE_WEB_VAPID_KEY', 'private-key'),
            ('FIREBASE_PROJECT_ID', 12),
        ):
            with self.subTest(key=key, value=value):
                values = configuration()
                values[key] = value
                with self.assertRaises(ValueError):
                    MODULE.public_config(values)

    def test_build_uses_same_public_values_and_matching_sdk(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            config = root / 'input.json'
            config.write_text(json.dumps(configuration()), encoding='utf-8')
            output = root / 'build/web'
            output.mkdir(parents=True)
            worker = output / 'firebase-messaging-sw.js'
            worker.write_text('worker-source', encoding='utf-8')
            package = root / 'package/lib/src'
            package.mkdir(parents=True)
            (package / 'firebase_sdk_version.dart').write_text(
                "const String supportedFirebaseJsSdkVersion = '12.14.0';",
                encoding='utf-8',
            )
            (root / '.dart_tool').mkdir()
            (root / '.dart_tool/package_config.json').write_text(json.dumps({
                'packages': [{'name': 'firebase_core_web', 'rootUri': '../package'}],
            }), encoding='utf-8')

            def run(command, **kwargs):
                self.assertEqual(command[:3], ['flutter', 'build', 'web'])
                self.assertIn('--release', command)
                self.assertIn('--target=lib/main/main_production.dart', command)
                self.assertTrue((ROOT / 'lib/main/main_production.dart').is_file())
                self.assertEqual(kwargs, {'cwd': root, 'check': True})
                define_path = Path(command[-1].split('=', 1)[1])
                defines = json.loads(define_path.read_text(encoding='utf-8'))
                self.assertEqual(defines, MODULE.public_config(configuration())[0])

            with patch.object(MODULE.subprocess, 'run', side_effect=run):
                MODULE.build(root, config, 'flutter', ['--release'])
            generated = (output / 'firebase-messaging-config.js').read_text(encoding='utf-8')
            self.assertNotIn('must-not-be-published', generated)
            self.assertIn('12.14.0', generated)
            self.assertIn('web-public-key', generated)
            self.assertEqual(worker.read_text(encoding='utf-8'), 'worker-source')

    def test_explicit_target_overrides_production_default(self):
        for options in (
            ['-t', 'lib/custom.dart'],
            ['--target', 'lib/custom.dart'],
            ['-t=lib/custom.dart'],
            ['--target=lib/custom.dart'],
        ):
            with self.subTest(options=options), tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary)
                config = root / 'input.json'
                config.write_text('{"FIREBASE_ENABLED":false}', encoding='utf-8')
                output = root / 'build/web'
                output.mkdir(parents=True)
                (output / 'firebase-messaging-sw.js').write_text('worker', encoding='utf-8')
                with patch.object(MODULE.subprocess, 'run') as run:
                    MODULE.build(root, config, 'flutter', options)
                command = run.call_args.args[0]
                self.assertEqual(command[:-1], ['flutter', 'build', 'web', *options])
                self.assertTrue(command[-1].startswith('--dart-define-from-file='))
                self.assertNotIn('--target=lib/main/main_production.dart', command)

    def test_conflicting_build_options_fail_before_reading_config(self):
        for options in (
            ['--output=other'], ['-o', 'other'], ['--base-href=/other/'],
            ['--base-href', '/other/'], ['--dart-define=FIREBASE_ENABLED=false'],
        ):
            with self.subTest(options=options), self.assertRaises(ValueError):
                MODULE.build(Path('.'), Path('missing'), 'flutter', options)


if __name__ == '__main__':
    unittest.main()
