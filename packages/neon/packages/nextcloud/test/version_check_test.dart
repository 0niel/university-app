import 'package:nextcloud/nextcloud.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  group('Version check', () {
    test('Null versions', () {
      final check = VersionCheck(
        versions: null,
        // Invalid constraints to avoid accidental validation
        minimumVersion: Version(2, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);
    });

    test('Empty versions', () {
      final check = VersionCheck(
        versions: const [],
        // Invalid constraints to avoid accidental validation
        minimumVersion: Version(2, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);
    });

    test('Multiple versions', () {
      final check = VersionCheck(
        versions: [
          Version(0, 9, 9),
          Version(1, 5, 0),
          Version(2, 0, 0),
        ],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);
    });

    test('With maximumMajor', () {
      var check = VersionCheck(
        versions: [Version(0, 9, 9)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isFalse);

      check = VersionCheck(
        versions: [Version(1, 0, 0)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);

      check = VersionCheck(
        versions: [Version(1, 5, 0)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);

      check = VersionCheck(
        versions: [Version(1, 9, 9)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isTrue);

      check = VersionCheck(
        versions: [Version(2, 0, 0)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: 1,
      );
      expect(check.isSupported, isFalse);
    });

    test('Without maximumMajor', () {
      var check = VersionCheck(
        versions: [Version(0, 9, 9)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: null,
      );
      expect(check.isSupported, isFalse);

      check = VersionCheck(
        versions: [Version(1, 5, 0)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: null,
      );
      expect(check.isSupported, isTrue);

      check = VersionCheck(
        versions: [Version(2, 0, 0)],
        minimumVersion: Version(1, 0, 0),
        maximumMajor: null,
      );
      expect(check.isSupported, isFalse);
    });
  });
}
