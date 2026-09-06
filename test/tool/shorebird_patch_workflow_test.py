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
            self.assertIn('release_manifest.py resolve', step(PATCH, job, 'Resolve registered release')['run'])
            self.assertIn('release_manifest.py verify-live', step(PATCH, job, 'Verify live registered release')['run'])
            self.assertLess(names.index('Install pinned Shorebird'), names.index('Verify live registered release'))
            self.assertEqual(step(PATCH, job, 'Set up Flutter')['with']['flutter-version'], '${{ steps.release.outputs.flutter_version }}')
            self.assertIn('--enforce-lockfile', step(PATCH, job, 'Resolve locked workspace')['run'])
            preparation = step(PATCH, job, 'Prepare verified runtime projection')['run']
            self.assertIn('$GITHUB_WORKSPACE/tool/prepare_shorebird_patch.py', preparation)
            self.assertIn('--repo "$GITHUB_WORKSPACE/source"', preparation)
            self.assertIn('--manifest "$RUNNER_TEMP/release-manifest.json"', preparation)
            self.assertEqual(step(PATCH, job, 'Check out requested source')['with']['path'], 'source')
        self.assertIn('--expected-projection "$PROJECTION_SHA256"', step(PATCH, 'patch', 'Prepare verified runtime projection')['run'])

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
