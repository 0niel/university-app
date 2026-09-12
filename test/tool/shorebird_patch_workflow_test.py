import contextlib
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import yaml

ROOT = Path(__file__).resolve().parents[2]
PATCH = yaml.safe_load((ROOT / '.github/workflows/shorebird-patch.yml').read_text(encoding='utf-8'))
PROMOTE = yaml.safe_load((ROOT / '.github/workflows/shorebird-promote.yml').read_text(encoding='utf-8'))


def step(workflow, job, name):
    return next(item for item in workflow['jobs'][job]['steps'] if item['name'] == name)


def python_body(item):
    return item['run'].split("python3 - <<'PY'\n", 1)[1].split('\nPY', 1)[0]


class ShorebirdPatchWorkflowTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.environment = {
            'RUNNER_TEMP': str(self.root), 'SOURCE_SHA': 'a' * 40,
            'BASELINE_SHA': 'b' * 40, 'WORKFLOW_SHA': 'c' * 40,
            'MANIFEST_SHA256': 'd' * 64, 'APP_ID': 'future-app',
            'PLATFORM': 'android', 'RELEASE_VERSION': '8.7.6+987654',
            'STAGING_RUN_ID': '123', 'PATCH_NUMBER': '2',
            'DEFAULT_BRANCH': 'master', 'GITHUB_REPOSITORY': 'owner/app',
            'WORKFLOW_REF': 'refs/heads/master', 'TARGET_TRACK': 'staging',
            'GITHUB_OUTPUT': str(self.root / 'github-output'),
            'PATCH_WORKSPACE': str(self.root / 'projection'),
        }

    def execute(self, item, values=None, check_output=None):
        environment = {**self.environment, **(values or {})}
        with patch.dict(os.environ, environment), patch('subprocess.check_output', return_value=check_output or 'e' * 40):
            exec(compile(python_body(item), '<workflow>', 'exec'), {})

    def bash(self, item, **values):
        executable = os.environ.get('TEST_BASH') or shutil.which('bash')
        self.assertIsNotNone(executable, 'Bash is required to verify workflow validation')
        return subprocess.run(
            [executable, '--noprofile', '--norc', '-e', '-o', 'pipefail', '-c', item['run']],
            env={**os.environ, **self.environment, **values}, capture_output=True, text=True, timeout=20,
        )

    def write(self, path, value):
        target = self.root / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(value), encoding='utf-8')

    def ci(self, **changes):
        run = {
            'head_sha': self.environment['SOURCE_SHA'], 'head_branch': 'master',
            'event': 'push', 'path': '.github/workflows/main.yml',
            'status': 'completed', 'conclusion': 'success',
            'head_repository': {'full_name': 'owner/app'}, **changes,
        }
        self.write('source-ci.json', {'workflow_runs': [run]})

    def receipt(self, **changes):
        receipt = {
            'source_sha': 'a' * 40, 'baseline_sha': 'b' * 40, 'workflow_sha': 'c' * 40,
            'manifest_sha256': 'd' * 64, 'source_tree_sha': 'e' * 40,
            'projected_tree_sha': 'f' * 40, 'projection_sha256': '1' * 64,
            'app_id': 'future-app', 'platform': 'android', 'release_version': '8.7.6+987654',
            'patch_number': 2, 'patch_id': 44, 'staging_run_id': '123', 'staging_run_attempt': 3,
            'track': 'staging', 'artifacts': [{'arch': 'aarch64', 'platform': 'android', 'hash': 'digest', 'size': 10, 'patch_id': 44}],
            **changes,
        }
        self.write('promotion-receipt/shorebird-patch-receipt.json', receipt)
        self.write('staging-run.json', {'head_sha': 'c' * 40, 'run_attempt': 3})
        return receipt

    def test_arbitrary_registered_versions_need_no_workflow_edit(self):
        for workflow, job, name in ((PATCH, 'validate', 'Validate requested target'), (PROMOTE, 'promote', 'Validate requested promotion')):
            self.assertEqual(workflow.get('on', workflow.get(True))['workflow_dispatch']['inputs']['release_version']['type'], 'string')
            self.assertNotIn('options', workflow.get('on', workflow.get(True))['workflow_dispatch']['inputs']['release_version'])
            for platform in ('android', 'ios'):
                result = self.bash(step(workflow, job, name), PLATFORM=platform)
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_untrusted_dispatch_inputs_are_rejected(self):
        for workflow, job, name in ((PATCH, 'validate', 'Validate requested target'), (PROMOTE, 'promote', 'Validate requested promotion')):
            for values in ({'SOURCE_SHA': 'master'}, {'PLATFORM': 'web'}, {'WORKFLOW_REF': 'refs/heads/feature'}, {'RELEASE_VERSION': '../bad'}, {'RELEASE_VERSION': 'x; echo bad'}):
                with self.subTest(values=values, job=job):
                    self.assertNotEqual(self.bash(step(workflow, job, name), **values).returncode, 0)
        self.assertNotEqual(self.bash(step(PATCH, 'validate', 'Validate requested target'), TARGET_TRACK='stable').returncode, 0)
        for values in ({'STAGING_RUN_ID': '0'}, {'PATCH_NUMBER': '-1'}):
            self.assertNotEqual(self.bash(step(PROMOTE, 'promote', 'Validate requested promotion'), **values).returncode, 0)

    def test_ci_requires_exact_successful_default_branch_source(self):
        for workflow, job in ((PATCH, 'validate'), (PROMOTE, 'promote')):
            item = step(workflow, job, 'Verify approved source')
            self.ci()
            self.execute(item)
            for change in ({'head_sha': '0' * 40}, {'head_branch': 'feature'}, {'event': 'pull_request'}, {'path': '.github/workflows/other.yml'}, {'status': 'in_progress'}, {'conclusion': 'failure'}, {'head_repository': {'full_name': 'fork/app'}}):
                self.ci(**change)
                with self.subTest(change=change), self.assertRaises(SystemExit):
                    self.execute(item)
            self.assertLess(item['run'].index('git merge-base --is-ancestor'), item['run'].index('gh api'))

    def test_missing_ci_is_not_accepted(self):
        self.write('source-ci.json', {'workflow_runs': []})
        with self.assertRaises(SystemExit):
            self.execute(step(PATCH, 'validate', 'Verify approved source'))

    def test_source_gate_precedes_release_resolution(self):
        for workflow, job in ((PATCH, 'validate'), (PROMOTE, 'promote')):
            names = [s['name'] for s in workflow['jobs'][job]['steps']]
            self.assertLess(names.index('Verify approved source'), names.index('Resolve registered release'))
            checkout = step(workflow, job, 'Check out trusted release tools')
            self.assertEqual(checkout['with']['ref'], '${{ github.workflow_sha }}')
            self.assertFalse(checkout['with']['persist-credentials'])

    def test_both_patch_jobs_use_registered_manifest_and_dynamic_sdk(self):
        for job in ('validate', 'patch'):
            self.assertEqual(PATCH['jobs'][job]['environment'], 'beta')
            steps = PATCH['jobs'][job]['steps']
            names = [s['name'] for s in steps]
            manifest_tool = 'tool/release_manifest.py' if job == 'validate' else '"$RELEASE_TOOLS/tool/release_manifest.py"'
            self.assertIn(f'{manifest_tool} resolve', step(PATCH, job, 'Resolve registered release')['run'])
            self.assertIn(f'{manifest_tool} verify-live', step(PATCH, job, 'Verify live registered release')['run'])
            self.assertLess(names.index('Install pinned Shorebird'), names.index('Verify live registered release'))
            self.assertEqual(step(PATCH, job, 'Set up Flutter')['with']['flutter-version'], '${{ steps.release.outputs.flutter_version }}')
            self.assertIn('--enforce-lockfile', step(PATCH, job, 'Resolve locked workspace')['run'])
            preparation = step(PATCH, job, 'Prepare verified runtime projection')['run']
            tools = '$GITHUB_WORKSPACE' if job == 'validate' else '$RELEASE_TOOLS'
            source = '$GITHUB_WORKSPACE/source' if job == 'validate' else '$SOURCE_WORKSPACE'
            self.assertIn(f'{tools}/tool/prepare_shorebird_patch.py', preparation)
            self.assertIn(f'--repo "{source}"', preparation)
            self.assertIn('--manifest "$RUNNER_TEMP/release-manifest.json"', preparation)
            self.assertEqual(step(PATCH, job, 'Check out requested source')['with']['path'], 'source')
        self.assertIn('--expected-projection "$PROJECTION_SHA256"', step(PATCH, 'patch', 'Prepare verified runtime projection')['run'])

    def test_native_patch_build_preserves_producer_root_and_isolates_verifiers(self):
        job = PATCH['jobs']['patch']
        self.assertEqual(job['env']['PATCH_WORKSPACE'], '${{ github.workspace }}')
        isolation = step(PATCH, 'patch', 'Isolate build verification inputs')
        self.assertEqual(isolation['env']['RELEASE_TOOLS'], '${{ runner.temp }}/shorebird-release-tools')
        self.assertEqual(isolation['env']['SOURCE_WORKSPACE'], '${{ runner.temp }}/shorebird-source')
        names = [item['name'] for item in job['steps']]
        for name, revision, location in (
            ('Check out trusted release tools', '${{ github.workflow_sha }}', 'release-tools'),
            ('Check out requested source', '${{ inputs.source_sha }}', 'source'),
        ):
            checkout = step(PATCH, 'patch', name)['with']
            self.assertEqual(checkout['ref'], revision)
            self.assertEqual(checkout['path'], location)
            self.assertEqual(checkout['fetch-depth'], 0)
            self.assertFalse(checkout['persist-credentials'])
            self.assertLess(names.index(name), names.index('Isolate build verification inputs'))
        self.assertLess(names.index('Isolate build verification inputs'), names.index('Resolve registered release'))
        self.assertLess(names.index('Resolve registered release'), names.index('Prepare verified runtime projection'))
        for name in ('Resolve registered release', 'Verify live registered release'):
            self.assertEqual(step(PATCH, 'patch', name)['working-directory'], '${{ env.RELEASE_TOOLS }}')
        for item in job['steps']:
            command = item.get('run', '')
            self.assertNotIn('$GITHUB_WORKSPACE/tool/', command)
            self.assertNotIn('$GITHUB_WORKSPACE/source', command)
            self.assertNotIn('build-projection', str(item))
            if item['name'] in ('Prepare verified runtime projection', 'Verify projected workspace'):
                self.assertIn('"$RELEASE_TOOLS/tool/prepare_shorebird_patch.py"', command)
                self.assertIn('--repo "$SOURCE_WORKSPACE"', command)
                self.assertIn('--output "$PATCH_WORKSPACE"', command)
                self.assertIn('--expected-projection "$PROJECTION_SHA256"', command)
        self.assertIn('git -C "$SOURCE_WORKSPACE" rev-parse HEAD', step(PATCH, 'patch', 'Verify patch configuration')['run'])
        self.assertEqual(step(PATCH, 'patch', 'Check out private NFC module')['with']['path'], 'android/private/nfc-pass-android')
        self.assertEqual(step(PATCH, 'patch', 'Publish staging patch')['working-directory'], '${{ env.PATCH_WORKSPACE }}')

    def build_layout(self, root):
        workspace, temporary = root / 'workspace', root / 'runner-temp'
        workspace.mkdir(parents=True)
        temporary.mkdir()
        environment = {**os.environ, 'GIT_CONFIG_NOSYSTEM': '1', 'GIT_CONFIG_GLOBAL': os.devnull}

        def git(directory, *args):
            return subprocess.check_output(['git', '-C', str(directory), *args], env=environment, text=True).strip()

        revisions = {}
        for name in ('release-tools', 'source'):
            checkout = workspace / name
            checkout.mkdir()
            git(checkout, 'init', '-q')
            (checkout / 'lib').mkdir()
            (checkout / 'lib/main.dart').write_text('const value = 1;\n')
            (checkout / 'pubspec.yaml').write_text('name: example\nversion: 9.8.7+654321\n')
            (checkout / 'tool').mkdir()
            (checkout / 'tool/marker.py').write_text('trusted tooling\n')
            git(checkout, 'add', '.')
            git(checkout, '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-qm', 'Fixture')
            revisions[name] = git(checkout, 'rev-parse', 'HEAD')
        baseline = revisions['source']
        (workspace / 'source/lib/main.dart').write_text('const value = 2;\n')
        git(workspace / 'source', 'add', '.')
        git(workspace / 'source', '-c', 'user.name=Test', '-c', 'user.email=test@example.invalid', 'commit', '-qm', 'Source')
        revisions['source'] = git(workspace / 'source', 'rev-parse', 'HEAD')
        values = {
            'GITHUB_WORKSPACE': str(workspace), 'PATCH_WORKSPACE': str(workspace),
            'RUNNER_TEMP': str(temporary), 'RELEASE_TOOLS': str(temporary / 'shorebird-release-tools'),
            'SOURCE_WORKSPACE': str(temporary / 'shorebird-source'),
            'SOURCE_SHA': revisions['source'], 'WORKFLOW_SHA': revisions['release-tools'],
            'GITHUB_ENV': str(temporary / 'github-env'),
        }
        return workspace, temporary, values, baseline

    def isolate_inputs(self, values):
        item = step(PATCH, 'patch', 'Isolate build verification inputs')
        with patch.dict(os.environ, values):
            exec(compile(python_body(item), '<workflow>', 'exec'), {})

    def test_isolated_inputs_materialize_the_same_projection_at_original_build_root(self):
        workspace, temporary, values, baseline = self.build_layout(self.root)
        spec = importlib.util.spec_from_file_location('build_root_projection', ROOT / 'tool/prepare_shorebird_patch.py')
        projection = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(projection)
        _, expected = projection.projection(workspace / 'source', baseline, values['SOURCE_SHA'])
        self.isolate_inputs(values)
        self.assertTrue(workspace.is_dir())
        self.assertEqual(list(workspace.iterdir()), [])
        self.assertEqual(Path(values['GITHUB_ENV']).read_text(),
            f"RELEASE_TOOLS={values['RELEASE_TOOLS']}\nSOURCE_WORKSPACE={values['SOURCE_WORKSPACE']}\n")
        self.assertEqual((temporary / 'shorebird-release-tools/tool/marker.py').read_text(), 'trusted tooling\n')
        source = Path(values['SOURCE_WORKSPACE'])
        entries, receipt = projection.projection(source, baseline, values['SOURCE_SHA'])
        self.assertEqual(receipt, expected)
        projection.materialize(source, workspace, entries, receipt)
        projection.verify_worktree(workspace, entries, receipt)
        self.assertEqual((workspace / 'lib/main.dart').read_text(), 'const value = 2;\n')
        self.assertFalse((workspace / 'source').exists())
        self.assertFalse((workspace / 'release-tools').exists())

    def test_input_isolation_rejects_unapproved_or_dirty_checkouts_before_moving(self):
        for change in ('wrong-source', 'wrong-tools', 'dirty-source', 'untracked-tools'):
            with self.subTest(change=change), tempfile.TemporaryDirectory(dir=self.root) as directory:
                workspace, _, values, _ = self.build_layout(Path(directory))
                if change == 'wrong-source':
                    values['SOURCE_SHA'] = '0' * 40
                elif change == 'wrong-tools':
                    values['WORKFLOW_SHA'] = '0' * 40
                elif change == 'dirty-source':
                    (workspace / 'source/lib/main.dart').write_text('injected\n')
                else:
                    (workspace / 'release-tools/untracked.py').write_text('injected\n')
                with self.assertRaises(SystemExit):
                    self.isolate_inputs(values)
                self.assertTrue((workspace / 'source/.git').is_dir())
                self.assertTrue((workspace / 'release-tools/.git').is_dir())

    def test_input_isolation_rejects_unsafe_destinations_and_root_leftovers(self):
        for change in ('inside-workspace', 'existing-target', 'outside-temp', 'leftover'):
            with self.subTest(change=change), tempfile.TemporaryDirectory(dir=self.root) as directory:
                workspace, temporary, values, _ = self.build_layout(Path(directory))
                if change == 'inside-workspace':
                    values['RUNNER_TEMP'] = str(workspace)
                elif change == 'existing-target':
                    (temporary / 'shorebird-source').mkdir()
                elif change == 'outside-temp':
                    values['SOURCE_WORKSPACE'] = str(Path(directory) / 'outside')
                else:
                    (workspace / 'unexpected.txt').write_text('keep\n')
                with self.assertRaises(SystemExit):
                    self.isolate_inputs(values)
                self.assertTrue((workspace / 'source/.git').is_dir())
                self.assertTrue((workspace / 'release-tools/.git').is_dir())

    def test_build_rejects_registry_replacement_after_validation(self):
        self.write('release-manifest.json', {'changed': True})
        with self.assertRaises(SystemExit):
            self.execute(step(PATCH, 'patch', 'Resolve registered release'))

    def test_restore_registered_dependency_lock_checks_digest(self):
        import hashlib
        data = b'PODS: []\n'
        self.write('release-manifest.json', {'build_inputs': {'ios/Podfile.lock': hashlib.sha256(data).hexdigest()}})
        (self.root / 'Podfile.lock').write_bytes(data)
        (self.root / 'projection/ios').mkdir(parents=True)
        item = step(PATCH, 'patch', 'Restore registered dependency lock')
        self.execute(item)
        self.assertEqual((self.root / 'projection/ios/Podfile.lock').read_bytes(), data)
        (self.root / 'Podfile.lock').write_bytes(b'changed')
        with self.assertRaises(SystemExit):
            self.execute(item)

    def test_legacy_lock_absence_is_explicitly_supported(self):
        self.write('release-manifest.json', {'build_inputs': {}})
        self.execute(step(PATCH, 'patch', 'Restore registered dependency lock'))
        self.assertFalse((self.root / 'projection/ios/Podfile.lock').exists())

    def test_patch_rebuilds_with_the_registered_university_provider(self):
        names = [item['name'] for item in PATCH['jobs']['patch']['steps']]
        for name in ('Read university provider pin', 'Check out university provider', 'Resolve registered provider workspace'):
            self.assertGreater(names.index(name), names.index('Resolve locked workspace'))
            self.assertLess(names.index(name), names.index('Verify projected workspace'))
        self.assertIn('"$RELEASE_TOOLS/tool/university_provider_pin.py"', step(PATCH, 'patch', 'Read university provider pin')['run'])
        checkout = step(PATCH, 'patch', 'Check out university provider')
        self.assertEqual(checkout['if'], "steps.release.outputs.provider_sha != ''")
        self.assertEqual(checkout['with']['repository'], '${{ steps.provider.outputs.repository }}')
        self.assertEqual(checkout['with']['ref'], '${{ steps.release.outputs.provider_sha }}')
        self.assertEqual(checkout['with']['path'], 'private/university_provider')
        self.assertFalse(checkout['with']['persist-credentials'])
        resolve = step(PATCH, 'patch', 'Resolve registered provider workspace')
        self.assertEqual(resolve['if'], "steps.release.outputs.provider_sha != ''")
        self.assertEqual(resolve['working-directory'], '${{ env.PATCH_WORKSPACE }}')
        self.assertIn('tool/configure_university_provider.dart --local private/university_provider', resolve['run'])
        self.assertLess(resolve['run'].index('configure_university_provider.dart'), resolve['run'].index("python3 - <<'PY'"))
        self.assertLess(resolve['run'].index('\nPY'), resolve['run'].index('flutter pub get --enforce-lockfile'))
        self.assertNotIn('Check out university provider', [item['name'] for item in PATCH['jobs']['validate']['steps']])

    def test_registered_dart_lock_is_restored_only_with_its_digest(self):
        import hashlib
        data = b'packages:\n  university_provider: resolved\n'
        self.write('release-manifest.json', {'build_inputs': {'pubspec.lock': hashlib.sha256(data).hexdigest()}})
        (self.root / 'pubspec.lock').write_bytes(data)
        (self.root / 'projection').mkdir(parents=True)
        item = step(PATCH, 'patch', 'Resolve registered provider workspace')
        self.execute(item)
        self.assertEqual((self.root / 'projection/pubspec.lock').read_bytes(), data)
        (self.root / 'pubspec.lock').write_bytes(b'changed')
        with self.assertRaises(SystemExit):
            self.execute(item)
        self.write('release-manifest.json', {'build_inputs': {}})
        with self.assertRaises(KeyError):
            self.execute(item)

    def test_native_generators_come_from_projected_baseline(self):
        configure = step(PATCH, 'patch', 'Configure release parameters')
        self.assertEqual(configure['working-directory'], '${{ env.PATCH_WORKSPACE }}')
        self.assertIn('python3 tool/configure_firebase.py', configure['run'])
        self.assertIn('dart run tool/configure_university.dart', configure['run'])
        self.assertIn('release_manifest.py" verify-inputs', configure['run'])
        self.assertNotIn('git show', configure['run'])
        nfc = step(PATCH, 'patch', 'Check out private NFC module')
        self.assertEqual(nfc['with']['ref'], '${{ steps.release.outputs.private_native_sha }}')

    def test_native_and_asset_guards_are_never_bypassed(self):
        publish = step(PATCH, 'patch', 'Publish staging patch')['run']
        self.assertNotIn('--allow-native', publish)
        self.assertNotIn('--allow-asset', publish)
        self.assertIn('--track staging', publish)
        guard = step(PATCH, 'patch', 'Enforce strict iOS native diff rejection')['run']
        self.assertIn('confirmNativeChanges: true,', guard)
        self.assertIn('original.count(before) != 1', guard)
        self.assertIn('stat != f"1\\t1\\t{relative}"', guard)
        self.assertIn('fetch --depth 1 origin "$shorebird_revision"', step(PATCH, 'patch', 'Install pinned Shorebird')['run'])

    def test_only_existing_projected_runtime_and_tests_are_validated(self):
        self.write('shorebird-projection.json', {'runtime_paths': ['lib/deleted.dart'], 'test_paths': ['test/deleted_test.dart'], 'excluded_paths': ['tool/excluded.dart']})
        for name in ('Analyze hotfix', 'Test changed runtime'):
            with patch('subprocess.run') as run:
                self.execute(step(PATCH, 'validate', name))
                run.assert_not_called()

    def test_translation_only_patch_uses_successful_source_ci(self):
        self.write('shorebird-projection.json', {'runtime_paths': ['lib/l10n/app_ru.arb'], 'test_paths': []})
        for name in ('Analyze hotfix', 'Test changed runtime'):
            with patch('subprocess.run') as run:
                self.execute(step(PATCH, 'validate', name))
                run.assert_not_called()

    def test_projected_analysis_preserves_ci_severity_and_generated_exclusions(self):
        handwritten = ['lib/schedule/change.dart', 'packages/schedule/lib/src/change.dart', 'test/change_test.dart']
        generated = ['packages/schedule/lib/src/change' + suffix for suffix in
                     ('.freezed.dart', '.g.dart', '.gen.dart', '.pb.dart', '.pbgrpc.dart', '.pbjson.dart')]
        generated += ['lib/l10n/generated/app_localizations.dart', 'wear/lib/l10n/generated/app_localizations.dart']
        self.write('shorebird-projection.json', {'runtime_paths': handwritten[:2] + generated, 'test_paths': handwritten[2:]})
        for name in handwritten + generated:
            path = self.root / 'projection' / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('', encoding='utf-8')
        with contextlib.chdir(self.root / 'projection'), patch('subprocess.run') as run:
            self.execute(step(PATCH, 'validate', 'Analyze hotfix'))
            run.assert_called_once_with([
                'flutter', 'analyze', '--no-pub', '--no-fatal-infos', '--fatal-warnings', *sorted(handwritten),
            ], check=True)
        with contextlib.chdir(self.root / 'projection'), patch('subprocess.run', side_effect=subprocess.CalledProcessError(1, ['flutter', 'analyze'])):
            with self.assertRaises(subprocess.CalledProcessError):
                self.execute(step(PATCH, 'validate', 'Analyze hotfix'))

    def test_receipt_accepts_future_version_with_verified_provenance(self):
        self.receipt()
        self.execute(step(PROMOTE, 'promote', 'Verify receipt'))

    def test_receipt_rejects_wrong_provenance(self):
        for change in ({'source_sha': '0' * 40}, {'baseline_sha': '0' * 40}, {'manifest_sha256': '0' * 64}, {'source_tree_sha': '0' * 40}, {'workflow_sha': '0' * 40}, {'staging_run_attempt': 2}, {'projection_sha256': ''}, {'platform': 'ios'}, {'patch_number': 3}, {'track': 'stable'}, {'artifacts': []}):
            self.receipt(**change)
            with self.subTest(change=change), self.assertRaises(SystemExit):
                self.execute(step(PROMOTE, 'promote', 'Verify receipt'))

    def test_receipt_rejects_extra_files(self):
        self.receipt()
        self.write('promotion-receipt/unexpected.json', {})
        with self.assertRaises(SystemExit):
            self.execute(step(PROMOTE, 'promote', 'Verify receipt'))

    def test_staging_run_must_have_trusted_workflow_identity(self):
        run = {'path': '.github/workflows/shorebird-patch.yml', 'head_branch': 'master', 'event': 'workflow_dispatch', 'conclusion': 'success', 'status': 'completed', 'id': 123, 'repository': {'full_name': 'owner/app'}}
        item = step(PROMOTE, 'promote', 'Verify staging workflow')
        self.write('staging-run.json', run)
        self.execute(item)
        for change in ({'path': '.github/workflows/other.yml'}, {'event': 'pull_request'}, {'conclusion': 'failure'}, {'id': 124}, {'repository': {'full_name': 'fork/app'}}):
            self.write('staging-run.json', {**run, **change})
            with self.assertRaises(SystemExit):
                self.execute(item)

    def test_live_artifacts_must_match_receipt(self):
        receipt = self.receipt()
        live = {'id': 44, 'number': 2, 'channel': 'staging', 'is_rolled_back': False, 'artifacts': receipt['artifacts']}
        self.write('live-staging.json', {'status': 'success', 'data': {'patches': [live]}})
        item = step(PROMOTE, 'promote', 'Verify live staging patch')
        self.execute(item)
        for change in ({'is_rolled_back': True}, {'id': 45}, {'channel': 'beta'}, {'artifacts': []}):
            self.write('live-staging.json', {'status': 'success', 'data': {'patches': [{**live, **change}]}})
            with self.assertRaises(SystemExit):
                self.execute(item)

    def test_stable_verification_checks_unchanged_artifacts(self):
        receipt = self.receipt()
        live = {'id': 44, 'number': 2, 'channel': 'stable', 'is_rolled_back': False, 'artifacts': receipt['artifacts']}
        self.write('live-stable.json', {'status': 'success', 'data': {'patches': [live]}})
        item = step(PROMOTE, 'promote', 'Promote verified patch')
        self.execute(item, {'CURRENT_TRACK': 'stable'})
        live['artifacts'] = []
        self.write('live-stable.json', {'status': 'success', 'data': {'patches': [live]}})
        with self.assertRaises(SystemExit):
            self.execute(item, {'CURRENT_TRACK': 'stable'})

    def test_cleanup_does_not_depend_on_successful_projection_creation(self):
        cleanup = step(PATCH, 'patch', 'Remove signing material')
        self.assertNotIn('working-directory', cleanup)
        self.assertEqual(cleanup['if'], 'always()')
        self.assertIn('$PATCH_WORKSPACE/android/key.properties', cleanup['run'])


if __name__ == '__main__':
    unittest.main()
