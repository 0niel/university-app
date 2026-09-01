import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
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

String buildConfiguration(String project, String marker) {
  final start = project.indexOf(marker);
  expect(start, isNonNegative, reason: 'Missing $marker');
  final end = project.indexOf('\n\t\t};', start);
  expect(end, greaterThan(start), reason: 'Unterminated $marker');
  return project.substring(start, end);
}
