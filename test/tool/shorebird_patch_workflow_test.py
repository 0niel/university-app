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
        for job in ('validate', 'patch'):
            names = [item['name'] for item in PATCH['jobs'][job]['steps']]
            for name in ('Read university provider pin', 'Check out approved provider source', 'Isolate approved provider source'):
                self.assertGreater(names.index(name), names.index('Resolve registered release'))
                self.assertLess(names.index(name), names.index('Prepare verified runtime projection'))
            self.assertIn('shorebird_provider_patch.py', step(PATCH, job, 'Read university provider pin')['run'])
            self.assertIn('--manifest "$RUNNER_TEMP/release-manifest.json"', step(PATCH, job, 'Read university provider pin')['run'])
            checkout = step(PATCH, job, 'Check out approved provider source')
            self.assertEqual(checkout['if'], "steps.provider.outputs.ref != ''")
            self.assertEqual(checkout['with']['repository'], '${{ steps.provider.outputs.repository }}')
            self.assertEqual(checkout['with']['ref'], '${{ steps.provider.outputs.ref }}')
            self.assertEqual(checkout['with']['fetch-depth'], 0)
            self.assertEqual(checkout['with']['path'], 'provider-source')
            self.assertFalse(checkout['with']['persist-credentials'])
            resolve = step(PATCH, job, 'Resolve registered provider workspace')
            self.assertEqual(resolve['if'], "steps.release.outputs.provider_sha != ''")
            self.assertEqual(resolve['working-directory'], '${{ env.PATCH_WORKSPACE }}')
            self.assertIn('tool/configure_university_provider.dart --local private/university_provider', resolve['run'])
            self.assertLess(resolve['run'].index('configure_university_provider.dart'), resolve['run'].index("python3 - <<'PY'"))
            self.assertLess(resolve['run'].index('\nPY'), resolve['run'].index('flutter pub get --enforce-lockfile'))
            self.assertIn('--provider-repo "$PROVIDER_SOURCE_WORKSPACE"', step(PATCH, job, 'Prepare verified runtime projection')['run'])

    def test_provider_hotfix_is_tested_with_registered_locks_and_verified_at_promotion(self):
        analyze = step(PATCH, 'validate', 'Analyze hotfix')['run']
        tests = step(PATCH, 'validate', 'Test changed runtime')['run']
        self.assertIn('receipt.get("provider_projection")', analyze)
        self.assertIn('private/university_provider/', analyze)
        self.assertIn('receipt.get("provider_projection")', tests)
        self.assertIn('path.startswith("private/university_provider/test/")', tests)
        self.assertIn('--projection-receipt "$RUNNER_TEMP/shorebird-projection.json"', step(PATCH, 'patch', 'Configure release parameters')['run'])
        promotion = step(PROMOTE, 'promote', 'Verify provider projection provenance')['run']
        self.assertIn('--source "$SOURCE_SHA"', promotion)
        self.assertIn('--baseline "$BASELINE_SHA"', promotion)
        self.assertIn('--verify-receipt "$RUNNER_TEMP/promotion-receipt/shorebird-patch-receipt.json"', promotion)

    def test_provider_checkout_is_isolated_only_after_identity_validation(self):
        item = step(PATCH, 'patch', 'Isolate approved provider source')
        workspace = self.root / 'workspace'
        source = workspace / 'provider-source'
        source.mkdir(parents=True)
        (source / 'source.txt').write_text('approved')
        environment = {**self.environment, 'GITHUB_WORKSPACE': str(workspace), 'PROVIDER_SOURCE_SHA': 'a' * 40, 'GITHUB_ENV': str(self.root / 'github-env')}
        with patch.dict(os.environ, environment), patch('subprocess.check_output', side_effect=[str(source), 'b' * 40]):
            with self.assertRaisesRegex(SystemExit, 'differs from the approved source'):
                exec(compile(python_body(item), '<workflow>', 'exec'), {})
        self.assertTrue((source / 'source.txt').is_file())
        self.assertFalse((self.root / 'shorebird-provider-source').exists())
        with patch.dict(os.environ, environment), patch('subprocess.check_output', side_effect=[str(source), 'a' * 40, '']):
            exec(compile(python_body(item), '<workflow>', 'exec'), {})
        self.assertFalse(source.exists())
        self.assertEqual((self.root / 'shorebird-provider-source/source.txt').read_text(), 'approved')

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

    def test_ios_verbose_is_forwarded_to_flutter_only(self):
        publish = step(PATCH, 'patch', 'Publish staging patch')
        command = {'run': 'shorebird() { printf "<arg>%s</arg>\\n" "$@"; }\n' + publish['run']}
        for platform in ('ios', 'android'):
            with self.subTest(platform=platform):
                result = self.bash(command, PLATFORM=platform)
                self.assertEqual(result.returncode, 0, result.stderr)
                args = [line[5:-6] for line in result.stdout.splitlines() if line.startswith('<arg>')]
                separator = args.index('--')
                self.assertNotIn('--verbose', args[:separator])
                self.assertEqual('--verbose' in args[separator + 1:], platform == 'ios')

    def runner_diagnostics(self):
        item = step(PATCH, 'patch', 'Collect iOS Runner diagnostics')
        namespace = {'__name__': 'workflow_diagnostics'}
        exec(compile(python_body(item), '<workflow>', 'exec'), namespace)
        namespace['inspect_runner'] = lambda _: {}
        return namespace

    def test_missing_archive_parent_still_saves_a_diagnostics_manifest(self):
        temporary, workspace = self.root / 'temporary', self.root / 'workspace'
        temporary.mkdir()
        workspace.mkdir()
        output = self.root / 'diagnostics'
        self.runner_diagnostics()['collect_runners'](temporary, workspace, output)
        self.assertEqual(json.loads((output / 'manifest.json').read_text()), {'runners': []})

    def test_missing_workspace_archive_does_not_discard_temporary_runners(self):
        temporary, workspace = self.root / 'temporary', self.root / 'workspace'
        workspace.mkdir()
        runner = temporary / 'downloaded/Products/Applications/Runner.app/Runner'
        runner.parent.mkdir(parents=True)
        content = b'\xcf\xfa\xed\xfe' + b'bounded-runner'
        runner.write_bytes(content)
        output = self.root / 'diagnostics'
        with patch.object(os, 'O_NOFOLLOW', getattr(os, 'O_NOFOLLOW', 0), create=True):
            self.runner_diagnostics()['collect_runners'](temporary, workspace, output)
        manifest = json.loads((output / 'manifest.json').read_text())
        self.assertEqual([record['label'] for record in manifest['runners']], ['temporary-01'])
        self.assertEqual((output / 'temporary-01/Runner').read_bytes(), content)

    def test_missing_archive_does_not_relax_existing_runner_validation(self):
        temporary, workspace = self.root / 'temporary', self.root / 'workspace'
        temporary.mkdir()
        workspace.mkdir()
        runner = workspace / 'build/ios/archive/Runner.xcarchive/Products/Applications/Runner.app/Runner'
        runner.parent.mkdir(parents=True)
        runner.write_bytes(b'')
        with self.assertRaisesRegex(ValueError, 'bounded regular file'):
            self.runner_diagnostics()['find_runners'](temporary, workspace)

    def test_missing_archive_does_not_hide_a_broken_symlink_parent(self):
        temporary, workspace = self.root / 'temporary', self.root / 'workspace'
        temporary.mkdir()
        workspace.mkdir()
        try:
            (workspace / 'build').symlink_to(self.root / 'missing', target_is_directory=True)
        except OSError as error:
            self.skipTest(f'Symlink creation is unavailable: {error}')
        with self.assertRaisesRegex(ValueError, 'symlinks'):
            self.runner_diagnostics()['find_runners'](temporary, workspace)

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

    def test_promotion_accepts_cli_metadata_but_rejects_wrong_identity(self):
        receipt = self.receipt()
        live = {'id': 44, 'number': 2, 'channel': 'stable', 'is_rolled_back': False, 'artifacts': receipt['artifacts']}
        self.write('live-stable.json', {'status': 'success', 'data': {'patches': [live]}})
        data = {'app_id': receipt['app_id'], 'release_version': receipt['release_version'],
                'patch_number': 2, 'track': 'stable', 'changed': True, 'patch': live}
        item = step(PROMOTE, 'promote', 'Promote verified patch')
        self.write('promotion-result.json', {'status': 'success', 'data': data})
        self.execute(item, {'CURRENT_TRACK': 'staging'})
        for changes in ({'app_id': 'other-app'}, {'release_version': '1.0.0+1'},
                        {'patch_number': 3}, {'track': 'beta'}):
            self.write('promotion-result.json', {'status': 'success', 'data': {**data, **changes}})
            with self.subTest(changes=changes), self.assertRaises(SystemExit):
                self.execute(item, {'CURRENT_TRACK': 'staging'})
        self.write('promotion-result.json', {'status': 'error', 'data': data})
        with self.assertRaises(SystemExit):
            self.execute(item, {'CURRENT_TRACK': 'staging'})

    def test_cleanup_does_not_depend_on_successful_projection_creation(self):
        cleanup = step(PATCH, 'patch', 'Remove signing material')
        self.assertNotIn('working-directory', cleanup)
        self.assertEqual(cleanup['if'], 'always()')
        self.assertIn('$PATCH_WORKSPACE/android/key.properties', cleanup['run'])


if __name__ == '__main__':
    unittest.main()
