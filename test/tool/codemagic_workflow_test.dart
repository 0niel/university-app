import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late String workflow;
  late YamlMap configuration;

  setUpAll(() {
    workflow = File('codemagic.yaml').readAsStringSync();
    configuration = loadYaml(workflow) as YamlMap;
  });

  test('defines signed iOS release and patch workflows', () {
    final workflows = configuration['workflows'] as YamlMap;

    expect(workflows, contains('ios-beta-release'));
    expect(workflows, contains('ios-patch'));
    expect(workflow, contains('flutter: 3.44.2'));
    expect(workflow, contains('xcode: 26.4'));
    expect(workflow, contains('distribution_type: app_store'));
    expect(workflow, contains('submit_to_testflight: true'));
  });

  test('signs the app and widget with current bundle identifiers', () {
    expect(workflow, contains('BUNDLE_ID: pro.oniel.it.university'));
    expect(
      workflow,
      contains('WIDGET_BUNDLE_ID: pro.oniel.it.university.homewidget'),
    );
    expect(
      RegExp(
        'app-store-connect fetch-signing-files',
      ).allMatches(workflow),
      hasLength(2),
    );
    expect(workflow, isNot(contains('mirea.ninja.mireaapp')));
  });

  test('uploads iOS builds only for beta testing', () {
    final workflows = configuration['workflows'] as YamlMap;
    final release = workflows['ios-beta-release'] as YamlMap;
    final publishing = release['publishing'] as YamlMap;
    final appStore = publishing['app_store_connect'] as YamlMap;

    expect(appStore['submit_to_testflight'], isTrue);
    expect(appStore['submit_to_app_store'], isFalse);
  });

  test('publishes patches only to staging', () {
    final workflows = configuration['workflows'] as YamlMap;
    final patch = workflows['ios-patch'] as YamlMap;
    final scripts = patch['scripts'] as YamlList;
    final commands = scripts
        .cast<YamlMap>()
        .map((step) => step['script'] as String)
        .where((script) => script.contains('shorebird patch'))
        .toList();

    expect(commands, hasLength(1));
    final arguments = commands.single.split(RegExp(r'\s+'));
    expect(arguments, contains('--track=staging'));
    expect(
      arguments.indexOf('--track=staging'),
      lessThan(arguments.indexOf('--')),
    );
    expect(workflow, isNot(contains('shorebird patches promote')));
    expect(workflow, isNot(contains('--track=stable')));
  });

  test('keeps credentials in Codemagic variable groups', () {
    expect(workflow, contains('- shorebird'));
    expect(workflow, contains('- app_store'));
    expect(workflow, contains('- university'));
    expect(workflow, contains('APP_STORE_CONNECT_PRIVATE_KEY'));
    expect(workflow, contains('CERTIFICATE_PRIVATE_KEY'));
    expect(workflow, isNot(contains('AUTH_KEY:')));
    expect(workflow, isNot(contains('CERTIFICATE_KEY:')));
  });

  test('verifies the source before every release operation', () {
    expect(
      RegExp(r'- \*verify_source').allMatches(workflow),
      hasLength(2),
    );
    expect(workflow, contains('flutter analyze'));
    expect(workflow, contains('flutter test'));
  });

  test('pins and verifies Shorebird source', () {
    expect(
      workflow,
      contains('5ac7f9a9a5c4a5e66a958e608da0f73e34a3d6bb'),
    );
    expect(workflow, contains(r'git -C "$shorebird_dir" fetch --depth 1'));
    expect(workflow, contains(r'git -C "$shorebird_dir" rev-parse HEAD'));
    expect(workflow, isNot(contains('shorebirdtech/install')));
  });
}
