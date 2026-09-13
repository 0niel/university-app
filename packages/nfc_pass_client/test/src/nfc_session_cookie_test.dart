import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_pass_client/nfc_pass_client.dart';

void main() {
  test('normalizes legacy raw values and complete ASP.NET cookie headers', () {
    expect(nfcSessionCookieHeader('value='), '.AspNetCore.Cookies=value=');
    expect(
      nfcSessionCookieHeader('.AspNetCore.Cookies=value'),
      '.AspNetCore.Cookies=value',
    );
    expect(
      nfcSessionCookieHeader(
        '.AspNetCore.CookiesC2=second; .AspNetCore.Cookies=chunks-2; '
        '.AspNetCore.CookiesC1=first',
      ),
      '.AspNetCore.Cookies=chunks-2; .AspNetCore.CookiesC1=first; '
      '.AspNetCore.CookiesC2=second',
    );
  });

  for (final value in [
    '',
    'value; other=injected',
    'value\r\nInjected: header',
    '.AspNetCore.Cookies=value; unrelated=ignored',
    '.AspNetCore.Cookies=value; .AspNetCore.Cookies=duplicate',
    '.AspNetCore.Cookies=chunks-2; .AspNetCore.CookiesC1=partial',
    '.AspNetCore.Cookies=chunks-1; .AspNetCore.CookiesC2=wrong',
    '.AspNetCore.Cookies=value; .AspNetCore.CookiesC1=extra',
    '.AspNetCore.CookiesC1=orphan',
    '.AspNetCore.Cookies=chunks-100',
    'chunks-2',
  ]) {
    test('rejects unsafe or incomplete cookie ${value.hashCode}', () {
      expect(
        () => nfcSessionCookieHeader(value),
        throwsA(isA<FormatException>()),
      );
    });
  }
}
