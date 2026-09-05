import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';

void main() {
  test('iOS launches a single Flutter scene from the main storyboard', () {
    final plist = XmlDocument.parse(
      File('ios/Runner/Info.plist').readAsStringSync(),
    );
    final root = plist.rootElement.getElement('dict')!;
    final manifest = plistValue(root, 'UIApplicationSceneManifest');
    expect(
      plistValue(manifest, 'UIApplicationSupportsMultipleScenes').name.local,
      'false',
    );
    final configurations = plistValue(manifest, 'UISceneConfigurations');
    final scenes = plistValue(
      configurations,
      'UIWindowSceneSessionRoleApplication',
    ).findElements('dict');
    expect(scenes, hasLength(1));
    final scene = scenes.single;
    expect(plistValue(scene, 'UISceneClassName').innerText, 'UIWindowScene');
    expect(
      plistValue(scene, 'UISceneDelegateClassName').innerText,
      'FlutterSceneDelegate',
    );
    expect(plistValue(scene, 'UISceneConfigurationName').innerText, 'flutter');
    final storyboardName = plistValue(scene, 'UISceneStoryboardFile').innerText;
    final storyboard = XmlDocument.parse(
      File(
        'ios/Runner/Base.lproj/$storyboardName.storyboard',
      ).readAsStringSync(),
    );
    final initialController = storyboard.rootElement.getAttribute(
      'initialViewController',
    );
    expect(initialController, isNotNull);
    final controller = storyboard
        .findAllElements('viewController')
        .singleWhere(
          (element) => element.getAttribute('id') == initialController,
        );
    expect(controller.getAttribute('customClass'), 'FlutterViewController');
  });

  test('iOS registers plugins when the implicit Flutter engine is ready', () {
    final delegate = File('ios/Runner/AppDelegate.swift').readAsStringSync();
    expect(delegate, contains('FlutterImplicitEngineDelegate'));
    expect(
      delegate,
      matches(
        RegExp(
          r'func didInitializeImplicitFlutterEngine\('
          r'_ engineBridge: FlutterImplicitEngineBridge\)\s*\{\s*'
          r'GeneratedPluginRegistrant.register\(with: engineBridge.pluginRegistry\)',
        ),
      ),
    );
    expect(
      RegExp(r'GeneratedPluginRegistrant\.register\(').allMatches(delegate),
      hasLength(1),
    );
    expect(delegate, isNot(contains('register(with: self)')));
    expect(delegate, contains('UNUserNotificationCenter.current().delegate'));
  });

  test('widget uses a distinct bundle identifier for every configuration', () {
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();

    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER = pro\.oniel\.it\.university\.homewidget;',
      ).allMatches(project),
      hasLength(3),
    );
    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER = pro\.oniel\.it\.university;',
      ).allMatches(project),
      hasLength(3),
    );
  });

  test('widget inherits the Flutter release version', () {
    final infoPlist = File(
      'ios/HomeWidget/Info.plist',
    ).readAsStringSync();
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();

    expect(infoPlist, contains(r'<string>$(FLUTTER_BUILD_NAME)</string>'));
    expect(infoPlist, contains(r'<string>$(FLUTTER_BUILD_NUMBER)</string>'));
    for (final marker in [
      '26239B262749523700ADE724 /* Debug */',
      '26239B272749523700ADE724 /* Release */',
      '26239B282749523700ADE724 /* Profile */',
    ]) {
      expect(
        buildConfiguration(project, marker),
        contains(
          'baseConfigurationReference = 9740EEB31CF90195004384FC '
          '/* Generated.xcconfig */;',
        ),
      );
    }
  });

  test('release archive uses supported iOS and distribution signing', () {
    final podfile = File('ios/Podfile').readAsStringSync();
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    final runnerRelease = buildConfiguration(
      project,
      '97C147071CF9000F007C117D /* Release */',
    );
    final widgetRelease = buildConfiguration(
      project,
      '26239B272749523700ADE724 /* Release */',
    );

    expect(podfile, contains("platform :ios, '15.0'"));
    expect(project, isNot(contains('IPHONEOS_DEPLOYMENT_TARGET = 14.0;')));
    expect(
      RegExp(
        r'IPHONEOS_DEPLOYMENT_TARGET = 15\.0;',
      ).allMatches(project),
      hasLength(6),
    );
    expect(runnerRelease, contains('CODE_SIGN_STYLE = Manual;'));
    expect(widgetRelease, contains('CODE_SIGN_STYLE = Manual;'));
    expect(
      runnerRelease,
      contains(
        '"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";',
      ),
    );
    expect(
      widgetRelease,
      contains(
        '"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "Apple Distribution";',
      ),
    );
    expect(
      runnerRelease,
      contains(
        'PROVISIONING_PROFILE_SPECIFIER = '
        '"IT University App Store 2026";',
      ),
    );
    expect(
      widgetRelease,
      contains(
        'PROVISIONING_PROFILE_SPECIFIER = '
        '"IT University Widget App Store 2026";',
      ),
    );
  });
}

XmlElement plistValue(XmlElement dictionary, String key) {
  final elements = dictionary.childElements.toList();
  final index = elements.indexWhere(
    (element) => element.name.local == 'key' && element.innerText == key,
  );
  expect(index, isNonNegative, reason: 'Missing plist key $key');
  expect(index + 1, lessThan(elements.length));
  return elements[index + 1];
}

String buildConfiguration(String project, String marker) {
  final start = project.indexOf(marker);
  expect(start, isNonNegative, reason: 'Missing $marker');
  final end = project.indexOf('\n\t\t};', start);
  expect(end, greaterThan(start), reason: 'Unterminated $marker');
  return project.substring(start, end);
}
