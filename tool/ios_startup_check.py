import datetime
import hashlib
import json
import os
import platform
import plistlib
import re
import subprocess
import tempfile
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / 'build' / 'ios-startup-evidence'
BASELINE = '101bfe7f4c08142d0969aec7230ad4f99b1904f3'
NATIVE_FILES = ('ios/Runner/AppDelegate.swift', 'ios/Runner/Info.plist',
                'ios/Runner/Base.lproj/Main.storyboard')
MARKER = 'IOS_STARTUP_PROBE_FIRST_FRAME_V1'


def command(args, log, timeout=180):
    with log.open('w', encoding='utf-8') as output:
        output.write(json.dumps(args) + '\n')
        output.flush()
        result = subprocess.run(
            args, cwd=ROOT, stdout=output, stderr=subprocess.STDOUT,
            timeout=timeout, check=False,
        )
    if result.returncode:
        raise RuntimeError(f'Command failed ({result.returncode}); see {log.name}')


def simctl(*args):
    return subprocess.check_output(
        ['xcrun', 'simctl', *args], cwd=ROOT, text=True,
        stderr=subprocess.STDOUT, timeout=180,
    )


def screenshot_colors(path):
    from PIL import Image

    with Image.open(path) as image:
        pixels = list(image.convert('RGB').resize((100, 100)).getdata())
    green = sum(abs(r) < 12 and abs(g - 200) < 12 and abs(b - 83) < 12
                for r, g, b in pixels) / len(pixels)
    magenta = sum(abs(r - 255) < 12 and g < 12 and abs(b - 255) < 12
                  for r, g, b in pixels) / len(pixels)
    return {'green_fraction': green, 'magenta_fraction': magenta,
            'visible': green > 0.2 and magenta > 0.2}


def launch_pid(output, bundle_id):
    match = re.search(rf'^{re.escape(bundle_id)}: (\d+)\s*$', output, re.MULTILINE)
    if not match:
        raise RuntimeError('simctl launch did not report an application PID')
    return int(match.group(1))


def has_first_frame(log, pid, started_at):
    process = re.compile(rf'\bRunner\[{pid}:[0-9a-fA-F]+\]')
    for line in log.splitlines():
        if MARKER not in line or not process.search(line):
            continue
        try:
            timestamp = datetime.datetime.fromisoformat(line[:23])
        except ValueError:
            continue
        if timestamp >= started_at:
            return True
    return False


def hypothesis_reproduced(baseline, fixed):
    before = baseline.get('launches', [])
    after = fixed.get('launches', [])
    return bool(before and after and 'error' not in baseline and 'error' not in fixed
                and all(not item['visible'] for item in before)
                and all(item['first_frame_marker'] and item['visible'] for item in after))


def launch(device, bundle_id, folder, attempt):
    log = folder / f'launch-{attempt}.log'
    unified = folder / f'launch-{attempt}-system.log'
    started_at = datetime.datetime.now()
    command(
        ['xcrun', 'simctl', 'launch', '--terminate-running-process', device, bundle_id],
        log, timeout=30,
    )
    pid = launch_pid(log.read_text(encoding='utf-8', errors='replace'), bundle_id)
    deadline = time.monotonic() + 60
    marker = False
    while time.monotonic() < deadline:
        command(
            ['xcrun', 'simctl', 'spawn', device, 'log', 'show', '--style', 'compact',
             '--start', started_at.strftime('%Y-%m-%d %H:%M:%S'),
             '--predicate', f'process == "Runner" AND eventMessage CONTAINS "{MARKER}"'],
            unified, timeout=15,
        )
        marker = has_first_frame(
            unified.read_text(encoding='utf-8', errors='replace'), pid, started_at,
        )
        if marker:
            break
        time.sleep(2)
    time.sleep(3)
    screenshot = folder / f'launch-{attempt}.png'
    simctl('io', device, 'screenshot', str(screenshot))
    colors = screenshot_colors(screenshot)
    return {'pid': pid, 'started_at': started_at.isoformat(),
            'first_frame_marker': marker, **colors,
            'passed': marker and colors['visible']}


def variant(name, sources, device):
    folder = EVIDENCE / name
    folder.mkdir(parents=True, exist_ok=True)
    for relative, data in sources.items():
        (ROOT / relative).write_bytes(data)
        (folder / Path(relative).name).write_bytes(data)
    result = {'source_sha256': {
        relative: hashlib.sha256(data).hexdigest()
        for relative, data in sources.items()
    }}
    try:
        command(
            ['xcodebuild', '-workspace', 'ios/Runner.xcworkspace',
             '-scheme', 'Runner', '-configuration', 'Debug',
             '-sdk', 'iphonesimulator', '-destination', f'id={device}',
             '-derivedDataPath', str(ROOT / 'build' / 'ios-startup-derived'),
             'CODE_SIGNING_ALLOWED=NO', 'CODE_SIGNING_REQUIRED=NO',
             'CODE_SIGN_IDENTITY=', 'PROVISIONING_PROFILE_SPECIFIER=',
             'TENANT_APP_DISPLAY_NAME=Startup Probe',
             'TENANT_APP_DEEP_LINK_SCHEME=startupprobe',
             'ONLY_ACTIVE_ARCH=YES', f'ARCHS={platform.machine()}', 'build'],
            folder / 'build.log', timeout=600,
        )
        for relative, data in sources.items():
            if (ROOT / relative).read_bytes() != data:
                raise RuntimeError(f'Build modified {relative}; comparison invalid')
        app = ROOT / 'build/ios-startup-derived/Build/Products/Debug-iphonesimulator/Runner.app'
        with (app / 'Info.plist').open('rb') as source:
            metadata = plistlib.load(source)
        (folder / 'built-info.json').write_text(
            json.dumps(metadata, indent=2, default=str), encoding='utf-8',
        )
        bundle_id = metadata['CFBundleIdentifier']
        subprocess.run(
            ['xcrun', 'simctl', 'uninstall', device, bundle_id],
            capture_output=True, timeout=60, check=False,
        )
        simctl('install', device, str(app))
        result['launches'] = [launch(device, bundle_id, folder, n) for n in range(1, 4)]
        result['passed'] = all(item['passed'] for item in result['launches'])
    except Exception as error:
        result.update(passed=False, error=str(error))
    finally:
        try:
            command(
                ['xcrun', 'simctl', 'spawn', device, 'log', 'show',
                 '--last', '5m', '--style', 'compact', '--predicate',
                 'process == "Runner"'], folder / 'system.log', timeout=90,
            )
        except Exception as error:
            result['system_log_error'] = str(error)
    (folder / 'result.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(f'{name}: {json.dumps(result)}', flush=True)
    return result


def main():
    global ROOT
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    repository = ROOT
    probe = (repository / 'tool/ios_startup_probe.dart').read_bytes()
    fixed = {relative: (ROOT / relative).read_bytes() for relative in NATIVE_FILES}
    baseline = {relative: subprocess.check_output(
        ['git', 'show', f'{BASELINE}:{relative}'], cwd=ROOT,
    ) for relative in NATIVE_FILES}
    report = {'baseline_commit': BASELINE, 'scope':
              'Minimal generated Flutter iOS host with exact repository AppDelegate, '
              'Info.plist and Main storyboard, empty plugin registrant and isolated '
              'Dart first-frame probe. Debug simulator only; no production plugins, '
              'production Dart, Shorebird or signed device release.'}
    try:
        command(['flutter', '--version'], EVIDENCE / 'flutter-version.log')
        generated = Path(tempfile.mkdtemp(prefix='ios-window-')) / 'startup_probe'
        command(
            ['flutter', 'create', '--platforms=ios', '--no-pub',
             '--project-name', 'startup_probe', '--ios-language', 'swift', str(generated)],
            EVIDENCE / 'create.log', timeout=180,
        )
        ROOT = generated
        (ROOT / 'tool').mkdir()
        (ROOT / 'tool/ios_startup_probe.dart').write_bytes(probe)
        for relative, data in fixed.items():
            (ROOT / relative).write_bytes(data)
        command(['flutter', 'pub', 'get'], EVIDENCE / 'pub-get.log', timeout=600)
        command(
            ['flutter', 'build', 'ios', '--simulator', '--debug', '--no-codesign',
             '--config-only', '--target', 'tool/ios_startup_probe.dart'],
            EVIDENCE / 'configure.log', timeout=1200,
        )
        devices = json.loads(simctl('list', 'devices', 'available', '--json'))
        (EVIDENCE / 'devices.json').write_text(json.dumps(devices, indent=2), encoding='utf-8')
        candidates = [(runtime, device) for runtime, group in devices['devices'].items()
                      if '.iOS-' in runtime for device in group
                      if device.get('isAvailable') and device['name'].startswith('iPhone')]
        if not candidates:
            raise RuntimeError('No available iPhone simulator')
        preferred = [item for item in candidates if item[0].endswith('.iOS-18-5')]
        runtime, selected = max(
            preferred or candidates,
            key=lambda item: tuple(int(part) for part in item[0].split('.iOS-')[1].split('-')),
        )
        device = selected['udid']
        report['simulator'] = {
            'preferred_runtime': 'iOS 18.5', 'preferred_runtime_available': bool(preferred),
            'runtime': runtime, **selected, 'host_arch': platform.machine(),
        }
        if selected['state'] != 'Booted':
            simctl('boot', device)
        simctl('bootstatus', device, '-b')
        report['baseline'] = variant('baseline', baseline, device)
        report['fixed'] = variant('fixed', fixed, device)
        report['hypothesis_reproduced'] = hypothesis_reproduced(
            report['baseline'], report['fixed'],
        )
    except Exception as error:
        report['error'] = str(error)
    finally:
        for relative, data in fixed.items():
            (ROOT / relative).write_bytes(data)
        ROOT = repository
        output = json.dumps(report, indent=2)
        (EVIDENCE / 'result.json').write_text(output, encoding='utf-8')
        print(output, flush=True)
        if os.environ.get('GITHUB_STEP_SUMMARY'):
            with open(os.environ['GITHUB_STEP_SUMMARY'], 'a', encoding='utf-8') as summary:
                summary.write('```json\n' + output + '\n```\n')
    return 0 if (report.get('fixed', {}).get('passed')
                 and 'error' not in report.get('baseline', {})
                 and 'error' not in report) else 1


if __name__ == '__main__':
    raise SystemExit(main())
