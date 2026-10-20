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

  test('preserves the current Pulse session cookie and canonical chunks', () {
    expect(
      nfcSessionCookieHeader('Pulse.Auth.Cookie=session'),
      'Pulse.Auth.Cookie=session',
    );
    expect(
      nfcSessionCookieHeader(
        'Pulse.Auth.CookieC2=second; Pulse.Auth.Cookie=chunks-2; '
        'Pulse.Auth.CookieC1=first',
      ),
      'Pulse.Auth.Cookie=chunks-2; Pulse.Auth.CookieC1=first; '
      'Pulse.Auth.CookieC2=second',
    );
  });

  test('prefers the current Pulse family over a stale legacy family', () {
    expect(
      nfcSessionCookieHeader(
        '.AspNetCore.Cookies=chunks-2; .AspNetCore.CookiesC1=stale; '
        'Pulse.Auth.Cookie=current',
      ),
      'Pulse.Auth.Cookie=current',
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
    'Pulse.Auth.Cookie=',
    'Pulse.Auth.Cookie=value; unrelated=ignored',
    'Pulse.Auth.Cookie=value; Pulse.Auth.Cookie=duplicate',
    'Pulse.Auth.Cookie=chunks-2; Pulse.Auth.CookieC1=partial',
    'Pulse.Auth.Cookie=chunks-1; Pulse.Auth.CookieC2=wrong',
    'Pulse.Auth.Cookie=value; Pulse.Auth.CookieC1=extra',
    'Pulse.Auth.CookieC1=orphan',
    'Pulse.Auth.Cookie=chunks-100',
    'Pulse.Auth.Cookie.evil=untrusted',
    'Pulse.Auth.Cookie=chunks-2; Pulse.Auth.CookieC1=p; .AspNetCore.Cookies=l',
  ]) {
    test('rejects unsafe or incomplete cookie ${value.hashCode}', () {
      expect(
        () => nfcSessionCookieHeader(value),
        throwsA(isA<FormatException>()),
      );
    });
  }
}
