import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/login/models/email.dart';

void main() {
  test('accepts edu.mirea.ru regardless of policy casing or @ prefix', () {
    const email = Email.dirtyWithDomains(
      'student@edu.mirea.ru',
      allowedDomains: [' @EDU.MIREA.RU '],
    );

    expect(email.isValid, isTrue);
  });

  test('rejects domains outside the normalized policy', () {
    const email = Email.dirtyWithDomains(
      'student@example.com',
      allowedDomains: ['mirea.ru', 'edu.mirea.ru'],
    );

    expect(email.isValid, isFalse);
  });
}
