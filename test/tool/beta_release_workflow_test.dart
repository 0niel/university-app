import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('publishes an attested beta after successful master CI', () {
    final workflow = File(
      '.github/workflows/beta-release.yml',
    ).readAsStringSync();

    expect(workflow, contains('workflow_run:'));
    expect(workflow, contains('      - CI'));
    expect(workflow, contains('      - master'));
    expect(workflow, contains("workflow_run.conclusion == 'success'"));
    expect(workflow, contains("workflow_run.event == 'push'"));
    expect(workflow, contains('cancel-in-progress: false'));
    expect(workflow, contains('shorebird release android'));
    expect(workflow, contains('--artifact apk'));
    expectProductionTargetBeforeSeparator(
      workflow,
      stepName: 'Release Android beta',
    );
    expect(workflow, contains('app-production-release.apk'));
    expect(workflow, contains('app-production-release.aab'));
    expect(workflow, contains('actions/upload-artifact@'));
    expect(workflow, contains('actions/attest-build-provenance@'));
    expect(workflow, contains(r'gh release create "$TAG"'));
    expect(workflow, contains('--prerelease'));
    expect(workflow, contains("--notes ''"));
    expect(workflow, isNot(contains('--generate-notes')));
    expect(workflow, contains('if-no-files-found: error'));
    expect(
      workflow,
      contains('5ac7f9a9a5c4a5e66a958e608da0f73e34a3d6bb'),
    );
    expect(workflow, contains(r'git -C "$shorebird_dir" rev-parse HEAD'));
    expect(workflow, isNot(contains('shorebirdtech/setup-shorebird@')));
    expect(workflow, isNot(contains('shorebirdtech/shorebird-release@')));
  });

  test('updates the Google Play store icon only on explicit dispatch', () {
    final workflow = File(
      '.github/workflows/google-play-release.yml',
    ).readAsStringSync();
    final uploadIndex = workflow.indexOf(
      '      - name: Upload beta to Google Play',
    );
    final iconIndex = workflow.indexOf(
      '      - name: Update Google Play store icon',
    );
    final cleanupIndex = workflow.indexOf(
      '      - name: Remove Google Play credentials',
    );

    expect(uploadIndex, isNonNegative);
    expect(iconIndex, greaterThan(uploadIndex));
    expect(cleanupIndex, greaterThan(iconIndex));
    expect(workflow, contains('tool/google_play_store_icon.py'));
    expect(workflow, contains('tool/google_play_internal_release.py'));
    expect(workflow, isNot(contains('r0adkll/upload-google-play@')));
    expect(workflow, isNot(contains('changesNotSentForReview:')));
    expect(workflow, contains('update_icon_only:'));
    expect(workflow, contains('submit_icon_for_review:'));
    expect(
      workflow.substring(iconIndex, cleanupIndex),
      contains(
        r"if: ${{ github.event_name == 'workflow_dispatch' && "
        'inputs.update_icon_only == true }}',
      ),
    );
    expect(
      workflow,
      contains('A release tag is required for a manual bundle upload'),
    );
    expect(workflow, contains("github.event_name == 'schedule'"));
    expect(workflow, contains("cron: '17,47 * * * *'"));
    expect(
      workflow,
      contains('github.event.workflow_run.head_sha || github.sha'),
    );
    expect(workflow, contains('inputs.update_icon_only != true'));
    expect(workflow, contains('arguments+=(--submit-for-review)'));
    expect(
      workflow,
      contains('android/app/src/main/ic_launcher-playstore.png'),
    );
    expect(
      workflow,
      contains(
        'python3 -m unittest discover -s test/tool '
        '-p google_play_store_icon_test.py',
      ),
    );
  });

  test('manual iOS Shorebird releases use the production entrypoint', () {
    final workflow = File(
      '.github/workflows/shorebird-release.yml',
    ).readAsStringSync();

    expectProductionTargetBeforeSeparator(workflow, stepName: 'Release iOS');
    expect(
      RegExp(
        r'--dart-define=SUPABASE_URL=\$\{\{ vars\.SUPABASE_URL \}\}',
      ).allMatches(workflow),
      hasLength(1),
    );
    expect(workflow, isNot(contains('secrets.SUPABASE_URL')));
  });

  test('manual iOS release validates, verifies, signs, and publishes', () {
    final workflow = File(
      '.github/workflows/shorebird-release.yml',
    ).readAsStringSync();
    final verifyIndex = workflow.indexOf(
      '      - name: Verify release configuration',
    );
    final configureIosIndex = workflow.indexOf(
      '      - name: Configure iOS signing',
    );
    final releaseIosIndex = workflow.indexOf('      - name: Release iOS');
    final testFlightIndex = workflow.indexOf(
      '      - name: Upload iOS beta to TestFlight',
    );
    final processingIndex = workflow.indexOf(
      '      - name: Verify TestFlight processing',
    );
    final verifySourceIndex = workflow.indexOf('      - name: Verify source');
    final verifyXcodeIndex = workflow.indexOf(
      '      - name: Verify Xcode toolchain',
    );
    final setupFlutterIndex = workflow.indexOf('      - name: Set up Flutter');

    expect(verifyIndex, isNonNegative);
    expect(verifyXcodeIndex, greaterThan(verifyIndex));
    expect(setupFlutterIndex, greaterThan(verifyXcodeIndex));
    expect(
      workflow,
      contains('/Applications/Xcode_26.3.app/Contents/Developer'),
    );
    expect(workflow, contains('"Xcode 26.3"'));
    expect(verifySourceIndex, greaterThan(verifyIndex));
    expect(workflow, contains('flutter analyze lib test'));
    expect(workflow, isNot(contains('          flutter analyze\n')));
    expect(configureIosIndex, greaterThan(verifyIndex));
    expect(configureIosIndex, greaterThan(verifySourceIndex));
    expect(releaseIosIndex, greaterThan(configureIosIndex));
    expect(testFlightIndex, greaterThan(releaseIosIndex));
    expect(processingIndex, greaterThan(testFlightIndex));
    expect(workflow, contains('BUILD_PROVISION_PROFILE_BASE64'));
    expect(workflow, contains('BUILD_WIDGET_PROVISION_PROFILE_BASE64'));
    expect(workflow, contains('APPSTORE_API_ISSUER_ID'));
    expect(workflow, contains('"".join(private_key.split())'));
    expect(workflow, contains('base64.b64decode(encoded_key, validate=True)'));
    expect(workflow, contains('artifact_run_id:'));
    expect(workflow, contains('verify_build_number:'));
    expect(workflow, contains('verify_marketing_version:'));
    expect(workflow, contains('verify_release_status:'));
    expect(workflow, contains('&& !inputs.verify_release_status'));
    expect(workflow, contains('status_args+=(--release-status)'));
    expect(workflow, contains(r'"${status_args[@]}"'));
    expect(
      workflow,
      contains('App Store build number is required for release status'),
    );
    expect(workflow, contains('actions: read'));
    expect(workflow, contains('group: shorebird-ios-release'));
    expect(workflow, contains('cancel-in-progress: false'));
    expect(workflow, contains('datetime(2020, 1, 1, tzinfo=timezone.utc)'));
    expect(workflow, contains(r'--build-number="$build_number"'));
    expect(workflow, isNot(contains(r'--build-number="$GITHUB_RUN_ID"')));
    expect(
      workflow,
      contains(r'^[0-9]{1,4}\.[0-9]{1,2}\.[0-9]{1,2}$'),
    );
    expect(workflow, contains("inputs.artifact_run_id == ''"));
    expect(workflow, contains("inputs.artifact_run_id != ''"));
    expect(workflow, contains(r'run-id: ${{ inputs.artifact_run_id }}'));
    expect(workflow, contains(r'github-token: ${{ github.token }}'));
    expect(workflow, contains('tool/app_store_build_status.py'));
    expect(workflow, contains(r'--marketing-version "$marketing_version"'));
    expect(workflow, contains('--timeout 1200'));
    expect(workflow, contains('--interval 30'));
    expect(workflow, contains("inputs.verify_build_number == ''"));
    expect(workflow, contains("inputs.verify_build_number != ''"));
    expect(
      workflow,
      contains(
        'python3 -m unittest discover -s test/tool '
        '-p app_store_build_status_test.py',
      ),
    );
    expect(
      workflow,
      contains(
        r'--export-options-plist=${{ runner.temp }}/ExportOptions.plist',
      ),
    );
    expect(workflow, contains('pro.oniel.it.university.homewidget'));
    expect(workflow, contains('if: always()'));
    expect(workflow, contains('publish:\n    needs: release'));
    expect(workflow, contains('actions/upload-artifact@'));
    expect(workflow, contains('actions/download-artifact@'));
  });

  test('manual iOS release pins and verifies Shorebird source', () {
    final workflow = File(
      '.github/workflows/shorebird-release.yml',
    ).readAsStringSync();

    expect(
      workflow,
      contains('5ac7f9a9a5c4a5e66a958e608da0f73e34a3d6bb'),
    );
    expect(workflow, contains(r'git -C "$shorebird_dir" fetch --depth 1'));
    expect(workflow, contains(r'git -C "$shorebird_dir" rev-parse HEAD'));
    expect(workflow, isNot(contains('shorebirdtech/install')));
  });
}

void expectProductionTargetBeforeSeparator(
  String workflow, {
  required String stepName,
}) {
  final stepStart = workflow.indexOf('      - name: $stepName');
  expect(stepStart, isNonNegative, reason: 'Missing $stepName step');

  final stepEnd = workflow.indexOf('\n      - name:', stepStart + 1);
  final step = workflow.substring(
    stepStart,
    stepEnd == -1 ? workflow.length : stepEnd,
  );
  const argsMarker = '          args: >-\n';
  const runMarker = '        run: |\n';
  final argsStart = step.indexOf(argsMarker);
  final runStart = step.indexOf(runMarker);
  expect(
    argsStart >= 0 || runStart >= 0,
    isTrue,
    reason: 'Missing command for $stepName',
  );
  final commandStart = argsStart >= 0
      ? argsStart + argsMarker.length
      : runStart + runMarker.length;

  final tokens = step
      .substring(commandStart)
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList();
  final targetIndex = tokens.indexOf('--target');
  final separatorIndex = tokens.indexOf('--');

  expect(targetIndex, isNonNegative, reason: 'Missing target for $stepName');
  expect(tokens[targetIndex + 1], 'lib/main/main_production.dart');
  expect(separatorIndex, greaterThan(targetIndex + 1));
}
