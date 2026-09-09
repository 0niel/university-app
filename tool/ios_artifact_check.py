import argparse
import hashlib
import json
import plistlib
import re
import zipfile
from pathlib import Path


ALWAYS_USAGE_KEYS = (
    'NSLocationAlwaysUsageDescription',
    'NSLocationAlwaysAndWhenInUseUsageDescription',
)


def verify_ipa(ipa: Path, bundle_id: str, marketing_version=None, build_number=None) -> dict:
    ipa = Path(ipa)
    if ipa.is_dir():
        candidates = sorted(ipa.glob('*.ipa'))
        if len(candidates) != 1:
            raise ValueError('Exactly one iOS artifact is required')
        ipa = candidates[0]
    if ipa.suffix.lower() != '.ipa' or not ipa.is_file():
        raise ValueError('An existing iOS artifact is required')
    with ipa.open('rb') as source:
        digest = hashlib.file_digest(source, 'sha256').hexdigest()
        source.seek(0)
        with zipfile.ZipFile(source) as archive:
            entries = archive.infolist()
            names = [entry.filename for entry in entries]
            if len(names) != len(set(names)):
                raise ValueError('Duplicate artifact entries are not allowed')
            main_paths = [name for name in names if re.fullmatch(r'Payload/[^/]+\.app/Info\.plist', name)]
            app_roots = {name.split('/')[1] for name in names if re.match(r'Payload/[^/]+\.app/', name)}
            if len(main_paths) != 1 or len(app_roots) != 1:
                raise ValueError('Exactly one application bundle is required')
            metadata_paths = [name for name in names if name.startswith('Payload/') and name.endswith('/Info.plist')]
            main = None
            for name in metadata_paths:
                metadata = plistlib.loads(archive.read(name))
                if not isinstance(metadata, dict):
                    raise ValueError('Bundle metadata must be a dictionary')
                modes = metadata.get('UIBackgroundModes', [])
                if not isinstance(modes, list) or any(not isinstance(mode, str) for mode in modes):
                    raise ValueError('Background modes must be an array of strings')
                if 'location' in modes:
                    raise ValueError('Persistent background location is not permitted')
                if any(key in metadata for key in ALWAYS_USAGE_KEYS):
                    raise ValueError('Always location usage declarations are not permitted')
                if name == main_paths[0]:
                    main = metadata
    if main.get('CFBundleIdentifier') != bundle_id:
        raise ValueError('Unexpected application identifier')
    version = main.get('CFBundleShortVersionString')
    build = main.get('CFBundleVersion')
    if not isinstance(version, str) or not re.fullmatch(r'[0-9]+(?:\.[0-9]+){1,2}', version):
        raise ValueError('Invalid marketing version')
    if not isinstance(build, str) or not re.fullmatch(r'[0-9]{1,4}(?:\.[0-9]{1,2}){0,2}', build):
        raise ValueError('Invalid build number')
    if marketing_version is not None and version != marketing_version:
        raise ValueError('Unexpected marketing version')
    if build_number is not None and build != build_number:
        raise ValueError('Unexpected build number')
    when_in_use = main.get('NSLocationWhenInUseUsageDescription')
    if not isinstance(when_in_use, str) or not when_in_use.strip():
        raise ValueError('Foreground location usage description is required')
    return {
        'artifact_sha256': digest,
        'bundle_id': bundle_id,
        'marketing_version': version,
        'build_number': build,
        'background_modes': main.get('UIBackgroundModes', []),
        'metadata_plists_checked': len(metadata_paths),
    }


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--ipa', type=Path, required=True)
    parser.add_argument('--bundle-id', required=True)
    parser.add_argument('--marketing-version')
    parser.add_argument('--build-number')
    args = parser.parse_args(argv)
    try:
        result = verify_ipa(args.ipa, args.bundle_id, args.marketing_version, args.build_number)
    except (ValueError, OSError, KeyError, zipfile.BadZipFile, plistlib.InvalidFileException):
        parser.exit(1, 'iOS artifact failed foreground location and identity validation\n')
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
