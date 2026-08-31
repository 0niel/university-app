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
    expect(workflow, contains('--target lib/main/main_production.dart'));
    expect(workflow, contains('app-production-release.apk'));
    expect(workflow, contains('app-production-release.aab'));
    expect(workflow, contains('actions/upload-artifact@'));
    expect(workflow, contains('actions/attest-build-provenance@'));
    expect(workflow, contains(r'gh release create "$TAG"'));
    expect(workflow, contains('--prerelease'));
    expect(workflow, contains('if-no-files-found: error'));
  });
}
