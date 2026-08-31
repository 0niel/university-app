import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses the canonical icon in shared UI assets', () {
    final canonical = File('assets/icon.png').readAsBytesSync();
    final shared = File('packages/app_ui/assets/icon.png').readAsBytesSync();

    expect(listEquals(canonical, shared), isTrue);
    expect(_pngSize(canonical), (1024, 1024));
  });

  test('ships matching store icons on every supported surface', () {
    final expected = File('web/icons/Icon-512.png').readAsBytesSync();
    final paths = [
      'android/app/src/main/ic_launcher-playstore.png',
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png',
      'wear/android/app/src/main/ic_launcher-playstore.png',
      'wear/android/app/src/staging/ic_launcher-playstore.png',
      'wear/android/app/src/development/ic_launcher-playstore.png',
    ];

    expect(_pngSize(expected), (512, 512));
    for (final path in paths) {
      expect(listEquals(File(path).readAsBytesSync(), expected), isTrue);
    }
  });

  test('defines adaptive and maskable icon variants', () {
    final manifest = File('web/manifest.json').readAsStringSync();
    final wearForeground = File(
      'wear/android/app/src/main/res/drawable/ic_launcher_foreground.xml',
    ).readAsStringSync();
    final wearBackground = File(
      'wear/android/app/src/main/res/values/ic_launcher_background.xml',
    ).readAsStringSync();
    final maskable192 = File(
      'web/icons/Icon-maskable-192.png',
    ).readAsBytesSync();
    final maskable512 = File(
      'web/icons/Icon-maskable-512.png',
    ).readAsBytesSync();

    expect(manifest, contains('Icon-maskable-192.png'));
    expect(manifest, contains('Icon-maskable-512.png'));
    expect(_pngSize(maskable192), (192, 192));
    expect(_pngSize(maskable512), (512, 512));
    expect(wearForeground, contains('android:fillColor="#FFFFFF"'));
    expect(wearBackground, contains('#2F7AFF'));
    expect(
      File('windows/runner/resources/app_icon.ico').lengthSync(),
      isPositive,
    );
  });
}

(int, int) _pngSize(Uint8List bytes) {
  final data = ByteData.sublistView(bytes);
  expect(data.getUint32(0), 0x89504E47);
  expect(data.getUint32(4), 0x0D0A1A0A);
  return (data.getUint32(16), data.getUint32(20));
}
