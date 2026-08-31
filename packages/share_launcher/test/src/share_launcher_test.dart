import 'package:flutter_test/flutter_test.dart';
import 'package:share_launcher/share_launcher.dart';

void main() {
  group('ShareLauncher', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('calls shareProvider with text', () async {
      var called = false;

      final shareLauncher = ShareLauncher(
        shareProvider: (text) async {
          called = true;
          expect(text, equals('text'));
        },
      );

      await shareLauncher.share(text: 'text');

      expect(called, isTrue);
    });

    test('wraps an asynchronous share failure', () async {
      final error = StateError('sharing is unavailable');
      final shareLauncher = ShareLauncher(
        shareProvider: (_) => Future<void>.error(error),
      );

      await expectLater(
        shareLauncher.share(text: 'text'),
        throwsA(
          isA<ShareFailure>().having(
            (failure) => failure.error,
            'error',
            same(error),
          ),
        ),
      );
    });
  });
}
