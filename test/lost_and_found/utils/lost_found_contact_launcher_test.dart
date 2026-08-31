import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/lost_and_found/utils/lost_found_contact_launcher.dart';

void main() {
  test('builds only canonical Telegram URLs', () {
    expect(
      UrlLostFoundContactLauncher.telegramUri('@student_123'),
      Uri.https('t.me', '/student_123'),
    );
    expect(UrlLostFoundContactLauncher.telegramUri('../evil'), isNull);
    expect(
      UrlLostFoundContactLauncher.telegramUri('https://evil.test'),
      isNull,
    );
  });

  test('builds only normalized telephone URIs', () {
    expect(
      UrlLostFoundContactLauncher.phoneUri('+7 (999) 123-45-67'),
      Uri(scheme: 'tel', path: '+79991234567'),
    );
    expect(UrlLostFoundContactLauncher.phoneUri('tel:+7999'), isNull);
    expect(UrlLostFoundContactLauncher.phoneUri('123'), isNull);
  });
}
