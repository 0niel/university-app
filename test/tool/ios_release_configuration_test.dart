import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('widget uses a distinct bundle identifier for every configuration', () {
    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();

    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER = com\.ituniversity\.app\.HomeWidget;',
      ).allMatches(project),
      hasLength(3),
    );
    expect(
      RegExp(
        r'PRODUCT_BUNDLE_IDENTIFIER = com\.ituniversity\.app;',
      ).allMatches(project),
      hasLength(3),
    );
  });

  test('widget inherits the Flutter release version', () {
    final infoPlist = File(
      'ios/HomeWidget/Info.plist',
    ).readAsStringSync();

    expect(infoPlist, contains(r'<string>$(FLUTTER_BUILD_NAME)</string>'));
    expect(infoPlist, contains(r'<string>$(FLUTTER_BUILD_NUMBER)</string>'));
  });
}
