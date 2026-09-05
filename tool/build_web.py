import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
from urllib.parse import unquote, urlparse


PUBLIC_FIELDS = {
    'FIREBASE_ENABLED',
    'FIREBASE_API_KEY',
    'FIREBASE_WEB_API_KEY',
    'FIREBASE_PROJECT_ID',
    'FIREBASE_MESSAGING_SENDER_ID',
    'FIREBASE_WEB_APP_ID',
    'FIREBASE_AUTH_DOMAIN',
    'FIREBASE_STORAGE_BUCKET',
    'FIREBASE_MEASUREMENT_ID',
    'FIREBASE_WEB_VAPID_KEY',
}


def public_config(source):
    if not isinstance(source, dict):
        raise ValueError('Firebase configuration must be an object')
    values = {key: value for key, value in source.items() if key in PUBLIC_FIELDS}
    enabled = values.get('FIREBASE_ENABLED', False)
    if type(enabled) is not bool and enabled not in ('true', 'false'):
        raise ValueError('FIREBASE_ENABLED must be true or false')
    values['FIREBASE_ENABLED'] = enabled is True or enabled == 'true'
    for key, value in values.items():
        if key != 'FIREBASE_ENABLED' and not isinstance(value, str):
            raise ValueError(f'{key} must be a string')
    if not values['FIREBASE_ENABLED']:
        return values, {'enabled': False}
    fields = {
        'apiKey': values.get('FIREBASE_WEB_API_KEY') or values.get('FIREBASE_API_KEY'),
        'projectId': values.get('FIREBASE_PROJECT_ID'),
        'messagingSenderId': values.get('FIREBASE_MESSAGING_SENDER_ID'),
        'appId': values.get('FIREBASE_WEB_APP_ID'),
    }
    if any(not value or not value.strip() for value in fields.values()):
        raise ValueError('Web Firebase API key, project, sender and app ID are required')
    vapid = values.get('FIREBASE_WEB_VAPID_KEY', '')
    if not re.fullmatch(r'B[A-Za-z0-9_-]{86}', vapid):
        raise ValueError('FIREBASE_WEB_VAPID_KEY must be a public P-256 VAPID key')
    for dart_key, js_key in (
        ('FIREBASE_AUTH_DOMAIN', 'authDomain'),
        ('FIREBASE_STORAGE_BUCKET', 'storageBucket'),
        ('FIREBASE_MEASUREMENT_ID', 'measurementId'),
    ):
        if values.get(dart_key):
            fields[js_key] = values[dart_key]
    return values, {'enabled': True, 'firebase': fields}


def firebase_sdk_version(root):
    package_file = root / '.dart_tool/package_config.json'
    packages = json.loads(package_file.read_text(encoding='utf-8'))['packages']
    package = next(item for item in packages if item['name'] == 'firebase_core_web')
    uri = urlparse(package['rootUri'])
    if uri.scheme == 'file':
        path = unquote(uri.path)
        if os.name == 'nt' and re.match(r'^/[A-Za-z]:', path):
            path = path[1:]
        directory = Path(path)
    elif not uri.scheme:
        directory = package_file.parent / unquote(package['rootUri'])
    else:
        raise ValueError('Unsupported firebase_core_web package location')
    source = (directory / 'lib/src/firebase_sdk_version.dart').read_text(encoding='utf-8')
    match = re.search(r"supportedFirebaseJsSdkVersion\s*=\s*'([0-9]+\.[0-9]+\.[0-9]+)'", source)
    if not match:
        raise ValueError('Cannot determine the installed Firebase web SDK version')
    return match[1]


def build(root, config_path, flutter, extra):
    if not any(
        argument in ('-t', '--target') or argument.startswith(('-t=', '--target='))
        for argument in extra
    ):
        extra = [*extra, '--target=lib/main/main_production.dart']
    for index, argument in enumerate(extra):
        if argument in ('-o', '--output') or argument.startswith(('--output=', '-o=')):
            raise ValueError('Web push build output must remain build/web')
        if argument.startswith('--base-href=') and argument != '--base-href=/':
            raise ValueError('Web push builds require base href /')
        if argument == '--base-href' and extra[index + 1:index + 2] != ['/']:
            raise ValueError('Web push builds require base href /')
        if argument.startswith('--dart-define=FIREBASE_') or (
            argument == '--dart-define' and
            extra[index + 1:index + 2] and extra[index + 1].startswith('FIREBASE_')
        ):
            raise ValueError('Supply Firebase values using --firebase-config')
    source = json.loads(config_path.read_text(encoding='utf-8-sig'))
    defines, worker_config = public_config(source)
    with tempfile.TemporaryDirectory(prefix='web-build-') as temporary:
        defines_path = Path(temporary) / 'firebase.json'
        defines_path.write_text(json.dumps(defines), encoding='utf-8')
        subprocess.run(
            [flutter, 'build', 'web', *extra, f'--dart-define-from-file={defines_path}'],
            cwd=root,
            check=True,
        )
    if worker_config['enabled']:
        worker_config['sdkVersion'] = firebase_sdk_version(root)
    output = root / 'build/web'
    if not (output / 'firebase-messaging-sw.js').is_file():
        raise ValueError('Web build did not include firebase-messaging-sw.js')
    (output / 'firebase-messaging-config.js').write_text(
        'self.firebaseMessagingConfig = ' + json.dumps(worker_config) + ';\n',
        encoding='utf-8',
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--firebase-config', type=Path, required=True)
    parser.add_argument('--flutter')
    parser.add_argument('flutter_arguments', nargs=argparse.REMAINDER)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    pinned = root / '.fvm/flutter_sdk/bin' / ('flutter.bat' if os.name == 'nt' else 'flutter')
    flutter = args.flutter or (str(pinned) if pinned.is_file() else shutil.which('flutter'))
    if not flutter:
        parser.error('Flutter is not available')
    extra = args.flutter_arguments
    if extra[:1] == ['--']:
        extra = extra[1:]
    try:
        build(root, args.firebase_config.resolve(), flutter, extra)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        parser.exit(1, f'Web push build failed: {error}\n')


if __name__ == '__main__':
    main()
