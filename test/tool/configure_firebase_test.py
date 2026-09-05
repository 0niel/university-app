import importlib.util
import datetime
import json
import os
from pathlib import Path
import plistlib
import re
import tempfile
import textwrap
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location('configure_firebase', ROOT / 'tool/configure_firebase.py')
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


def config():
    return {
        'FIREBASE_ENABLED': True,
        'FIREBASE_PROJECT_ID': 'fixture-project',
        'FIREBASE_MESSAGING_SENDER_ID': '12345',
        'FIREBASE_ANDROID_APP_ID': '1:12345:android:abcdef',
        'FIREBASE_IOS_APP_ID': '1:12345:ios:123abc',
        'FIREBASE_ANDROID_API_KEY': 'android-public-key',
        'FIREBASE_IOS_API_KEY': 'ios-public-key',
        'FIREBASE_API_KEY': 'incorrect-shared-key',
        'FIREBASE_IOS_BUNDLE_ID': 'pro.oniel.it.university',
        'FIREBASE_STORAGE_BUCKET': 'fixture-project.firebasestorage.app',
        'UNRELATED_VALUE': 'must-not-be-copied',
    }


class ConfigureFirebaseTest(unittest.TestCase):
    def test_ios_workflows_require_production_push_on_app_profile_only(self):
        for workflow in ('shorebird-release.yml', 'shorebird-patch.yml'):
            content = (ROOT / '.github/workflows' / workflow).read_text()
            blocks = re.findall(r"          python3 - <<'PY'\n(.*?)          PY", content, re.S)
            block = next(textwrap.dedent(item) for item in blocks if 'App provisioning profile requires production push notifications' in item)
            for push in (None, 'development', 'production'):
                with self.subTest(workflow=workflow, push=push), tempfile.TemporaryDirectory() as directory:
                    environment = {'RUNNER_TEMP': directory, 'APPLE_TEAM_ID': 'FIXTURE',
                                   'IOS_APP_BUNDLE_ID': 'fixture.app', 'IOS_WIDGET_BUNDLE_ID': 'fixture.widget'}
                    for name, bundle in (('app', 'fixture.app'), ('widget', 'fixture.widget')):
                        profile = {'Name': name, 'ExpirationDate': datetime.datetime(2099, 1, 1),
                                   'TeamIdentifier': ['FIXTURE'],
                                   'Entitlements': {'application-identifier': 'FIXTURE.' + bundle}}
                        if name == 'app' and push:
                            profile['Entitlements']['aps-environment'] = push
                        for prefix in ('', 'patch-'):
                            (Path(directory) / f'{prefix}{name}-profile.plist').write_bytes(plistlib.dumps(profile))
                    with patch.dict(os.environ, environment):
                        if push == 'production':
                            exec(compile(block, workflow, 'exec'), {})
                        else:
                            with self.assertRaisesRegex(SystemExit, 'requires production push'):
                                exec(compile(block, workflow, 'exec'), {})

    def test_generates_native_config_matching_dart_options_and_android_package(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'firebase.json'
            output = Path(directory) / 'app/google-services.json'
            source.write_text(json.dumps(config()), encoding='utf-8')
            self.assertEqual(MODULE.main([
                '--config', str(source), '--platform', 'android',
                '--android-output', str(output),
            ]), 0)
            native = json.loads(output.read_text())
            client = native['client'][0]
            self.assertEqual(client['client_info'], {
                'mobilesdk_app_id': config()['FIREBASE_ANDROID_APP_ID'],
                'android_client_info': {'package_name': 'ninja.mirea.mireaapp'},
            })
            self.assertEqual(client['api_key'], [{'current_key': 'android-public-key'}])
            self.assertEqual(native['project_info']['project_number'], '12345')
            self.assertEqual(native['project_info']['project_id'], 'fixture-project')
            self.assertNotIn('incorrect-shared-key', output.read_text())
            self.assertNotIn('must-not-be-copied', output.read_text())
            self.assertNotIn('ios-public-key', output.read_text())

    def test_disabled_or_missing_config_is_never_a_mobile_release(self):
        for value in (None, {}, [], False):
            with self.subTest(value=value), self.assertRaises(ValueError):
                MODULE.release_config(value, 'android')
        for value in (False, 'false', 1, 'TRUE', ''):
            with self.subTest(value=value), self.assertRaises(ValueError):
                MODULE.release_config({**config(), 'FIREBASE_ENABLED': value}, 'ios')

    def test_requires_real_platform_fields_even_when_shared_key_exists(self):
        for platform in ('android', 'ios'):
            for key in ('FIREBASE_PROJECT_ID', 'FIREBASE_MESSAGING_SENDER_ID',
                        f'FIREBASE_{platform.upper()}_API_KEY', f'FIREBASE_{platform.upper()}_APP_ID'):
                for invalid in ('', ' ', None, 123):
                    with self.subTest(platform=platform, key=key, invalid=invalid), self.assertRaises(ValueError):
                        MODULE.release_config({**config(), key: invalid}, platform)

    def test_rejects_cross_project_and_cross_platform_app_ids(self):
        for value in ('1:987:android:abc', '1:12345:ios:abc', 'invalid'):
            with self.subTest(value=value), self.assertRaises(ValueError):
                MODULE.release_config({**config(), 'FIREBASE_ANDROID_APP_ID': value}, 'android')

    def test_ios_bundle_must_match_actual_release_target(self):
        MODULE.release_config({**config(), 'FIREBASE_ENABLED': 'true'}, 'ios')
        with self.assertRaises(ValueError):
            MODULE.release_config({**config(), 'FIREBASE_IOS_BUNDLE_ID': 'incorrect.bundle'}, 'ios')

    def test_invalid_config_cannot_replace_existing_native_config(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'firebase.json'
            output = Path(directory) / 'google-services.json'
            source.write_text(json.dumps({**config(), 'FIREBASE_ENABLED': False}))
            output.write_text('existing')
            with self.assertRaises(SystemExit):
                MODULE.main(['--config', str(source), '--platform', 'android', '--android-output', str(output)])
            self.assertEqual(output.read_text(), 'existing')

    def test_release_workflows_prepare_native_configuration_before_build(self):
        android = (ROOT / '.github/workflows/beta-release.yml').read_text()
        self.assertLess(android.index('--android-output android/app/google-services.json'), android.index('shorebird release android'))
        ios = (ROOT / '.github/workflows/shorebird-release.yml').read_text()
        self.assertLess(ios.index('--platform ios'), ios.index('shorebird release ios'))
        patch = (ROOT / '.github/workflows/shorebird-patch.yml').read_text()
        self.assertIn('$WORKFLOW_SHA:tool/configure_firebase.py', patch)
        self.assertNotIn('--android-output', patch)


if __name__ == '__main__':
    unittest.main()
