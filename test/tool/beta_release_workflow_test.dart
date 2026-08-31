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
    expect(workflow, contains('shorebirdtech/shorebird-release@'));
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
  });

  test('manual Shorebird releases use the production entrypoint', () {
    final workflow = File(
      '.github/workflows/shorebird-release.yml',
    ).readAsStringSync();

    expectProductionTargetBeforeSeparator(workflow, stepName: 'Release Android');
    expectProductionTargetBeforeSeparator(workflow, stepName: 'Release iOS');
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
  final argsMarker = '          args: >-\n';
  final argsStart = step.indexOf(argsMarker);
  expect(argsStart, isNonNegative, reason: 'Missing args for $stepName');

  final tokens = step
      .substring(argsStart + argsMarker.length)
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList();
  final targetIndex = tokens.indexOf('--target');
  final separatorIndex = tokens.indexOf('--');

  expect(targetIndex, isNonNegative, reason: 'Missing target for $stepName');
  expect(tokens[targetIndex + 1], 'lib/main/main_production.dart');
  expect(separatorIndex, greaterThan(targetIndex + 1));
}
