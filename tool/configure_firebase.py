import argparse
import json
from pathlib import Path
import re


def release_config(source, platform):
    if not isinstance(source, dict):
        raise ValueError('Firebase configuration must be an object')
    if source.get('FIREBASE_ENABLED') is not True and source.get('FIREBASE_ENABLED') != 'true':
        raise ValueError('FIREBASE_ENABLED must be true for mobile releases')
    if platform not in ('android', 'ios'):
        raise ValueError('Unsupported Firebase release platform')
    keys = (
        'FIREBASE_PROJECT_ID',
        'FIREBASE_MESSAGING_SENDER_ID',
        f'FIREBASE_{platform.upper()}_APP_ID',
        f'FIREBASE_{platform.upper()}_API_KEY',
    )
    for key in keys:
        value = source.get(key)
        if not isinstance(value, str) or not value.strip() or value != value.strip():
            raise ValueError(f'{key} is required for mobile releases')
    sender = source['FIREBASE_MESSAGING_SENDER_ID']
    app_id = source[f'FIREBASE_{platform.upper()}_APP_ID']
    if not sender.isascii() or not sender.isdecimal():
        raise ValueError('FIREBASE_MESSAGING_SENDER_ID must be numeric')
    if not re.fullmatch(rf'1:{re.escape(sender)}:{platform}:[a-fA-F0-9]+', app_id):
        raise ValueError('Firebase app ID must match its platform and sender')
    if platform == 'ios' and source.get('FIREBASE_IOS_BUNDLE_ID') != 'pro.oniel.it.university':
        raise ValueError('FIREBASE_IOS_BUNDLE_ID must match the release bundle')
    values = {key: source[key] for key in keys}
    bucket = source.get('FIREBASE_STORAGE_BUCKET')
    if bucket:
        if not isinstance(bucket, str) or bucket != bucket.strip():
            raise ValueError('FIREBASE_STORAGE_BUCKET must be a string')
        values['FIREBASE_STORAGE_BUCKET'] = bucket
    return values


def android_config(values):
    project = {
        'project_number': values['FIREBASE_MESSAGING_SENDER_ID'],
        'project_id': values['FIREBASE_PROJECT_ID'],
    }
    if values.get('FIREBASE_STORAGE_BUCKET'):
        project['storage_bucket'] = values['FIREBASE_STORAGE_BUCKET']
    return {
        'project_info': project,
        'client': [{
            'client_info': {
                'mobilesdk_app_id': values['FIREBASE_ANDROID_APP_ID'],
                'android_client_info': {'package_name': 'ninja.mirea.mireaapp'},
            },
            'api_key': [{'current_key': values['FIREBASE_ANDROID_API_KEY']}],
            'oauth_client': [],
            'services': {},
        }],
        'configuration_version': '1',
    }


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', type=Path, required=True)
    parser.add_argument('--platform', choices=('android', 'ios'), required=True)
    parser.add_argument('--android-output', type=Path)
    args = parser.parse_args(argv)
    try:
        source = json.loads(args.config.read_text(encoding='utf-8-sig'))
        values = release_config(source, args.platform)
        if args.android_output:
            if args.platform != 'android':
                raise ValueError('Android output requires the Android platform')
            args.android_output.parent.mkdir(parents=True, exist_ok=True)
            args.android_output.write_text(
                json.dumps(android_config(values), indent=2) + '\n',
                encoding='utf-8',
            )
    except (ValueError, OSError):
        parser.exit(1, 'Invalid or unavailable mobile Firebase configuration\n')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
