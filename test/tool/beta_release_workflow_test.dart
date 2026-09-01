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
    expect(workflow, contains('if-no-files-found: error'));
    expect(
      workflow,
      contains('5ac7f9a9a5c4a5e66a958e608da0f73e34a3d6bb'),
    );
    expect(workflow, contains(r'git -C "$shorebird_dir" rev-parse HEAD'));
    expect(workflow, isNot(contains('shorebirdtech/setup-shorebird@')));
    expect(workflow, isNot(contains('shorebirdtech/shorebird-release@')));
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
    expect(workflow, contains('BUILD_PROVISION_PROFILE_BASE64'));
    expect(workflow, contains('BUILD_WIDGET_PROVISION_PROFILE_BASE64'));
    expect(workflow, contains('APPSTORE_API_ISSUER_ID'));
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
