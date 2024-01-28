import 'package:flutter_test/flutter_test.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/utils/findable.dart';

void main() {
  group('LoginQRcode', () {
    const qrCodePath = '/user:JohnDoe&password:super_secret&server:example.com';
    const qrCode = 'nc://login$qrCodePath';
    const invalidUrl = '::Not valid LoginQRcode::';
    final credentials = LoginQRcode(
      serverURL: Uri.parse('example.com'),
      username: 'JohnDoe',
      password: 'super_secret',
    );

    test('parse', () {
      expect(LoginQRcode.tryParse(qrCode), equals(credentials));
      expect(LoginQRcode.tryParse(qrCodePath), equals(credentials));
      expect(LoginQRcode.tryParse(invalidUrl), null);
    });

    test('equality', () {
      expect(credentials, equals(credentials));
    });
  });

  group('URI', () {
    const testURL = 'apps/test?123=456#789';

    for (final (serverURL, path) in [
      ('http://localhost', ''),
      ('http://localhost:443', ''),
      ('http://localhost:443/nextcloud', '/nextcloud'),
    ]) {
      group(serverURL, () {
        final account = Account(
          serverURL: Uri.parse(serverURL),
          username: 'example',
        );

        test('Complete absolute path', () {
          expect(
            account.completeUri(Uri.parse('$path/$testURL')),
            Uri.parse('$serverURL/$testURL'),
          );
        });

        test('Complete relative path', () {
          expect(
            account.completeUri(Uri.parse(testURL)),
            Uri.parse('$serverURL/$testURL'),
          );
        });

        test('Strip', () {
          expect(
            account.stripUri(Uri.parse('$serverURL/$testURL')),
            Uri.parse('/$testURL'),
          );
        });
      });
    }
  });

  test('getAuthorizationHeaders', () {
    final account = Account(
      serverURL: Uri.parse('https://example.com:443/test'),
      username: 'example',
      password: 'example',
    );

    for (final (url, shouldHaveHeaders) in [
      ('https://example.com:443/test/bla.png', true),
      // Different ports
      ('https://example.com/test/bla.png', true),
      ('https://example.com:80/test/bla.png', false),
      // Different paths
      ('https://example.com:443/bla.png', false),
      ('https://example.com:443/123/bla.png', false),
      // Different protocol
      ('http://example.com:443/test/bla.png', false),
      // Different domains
      ('https://test.example.com:443/test/bla.png', false),
      ('https://test.com:443/test/bla.png', false),
    ]) {
      expect(account.getAuthorizationHeaders(Uri.parse(url)), shouldHaveHeaders ? isNotNull : isNull);
    }
  });

  group('Account', () {
    final account = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe',
      password: 'super_secret',
    );

    test('serialization', () {
      const json = {
        'serverURL': 'http://example.com',
        'username': 'JohnDoe',
        'password': 'super_secret',
        'userAgent': null,
      };

      expect(account.toJson(), equals(json));

      expect(Account.fromJson(json), equals(account));
    });

    test('id', () {
      expect(account.id, '8bcb507a406c5ad0eed4072601bcfdd2d923e87d');
    });

    test('humanReadableID', () {
      expect(account.humanReadableID, 'JohnDoe@example.com');

      final accountWithDefaultPort = Account(
        serverURL: Uri(scheme: 'http', host: 'example.com', port: 80),
        username: 'JohnDoe',
        password: 'super_secret',
      );

      expect(accountWithDefaultPort.humanReadableID, 'JohnDoe@example.com');

      final accountWithPort = Account(
        serverURL: Uri(scheme: 'http', host: 'example.com', port: 8080),
        username: 'JohnDoe',
        password: 'super_secret',
      );

      expect(accountWithPort.humanReadableID, 'JohnDoe@example.com:8080');
    });
  });

  test('AccountFind', () {
    final account1 = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe',
      password: 'super_secret',
    );
    final account2 = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe2',
      password: 'super_secret',
    );
    final account3 = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe3',
      password: 'super_secret',
    );
    final account4 = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe4',
      password: 'super_secret',
    );
    final account5 = Account(
      serverURL: Uri(scheme: 'http', host: 'example.com'),
      username: 'JohnDoe5',
      password: 'super_secret',
    );
    final accounts = {
      account1,
      account2,
      account3,
      account4,
      account5,
    };

    expect(accounts.tryFind(null), isNull);
    expect(accounts.tryFind('invalidID'), isNull);
    expect(accounts.tryFind(account3.id), equals(account3));

    expect(() => accounts.find('invalidID'), throwsA(isA<StateError>()));
    expect(accounts.find(account3.id), equals(account3));
  });
}
