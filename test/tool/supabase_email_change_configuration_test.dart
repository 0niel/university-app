import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final config = File('supabase/config.toml').readAsStringSync();
  final template = File(
    'supabase/templates/email_change.html',
  ).readAsStringSync();

  String section(String name) =>
      RegExp(
        r'(?:^|\n)\[' + RegExp.escape(name) + r'\]\s*\n([\s\S]*?)(?=\n\[|$)',
      ).firstMatch(config)?.group(1) ??
      '';

  test('local guest linking preserves email confirmation requirements', () {
    final auth = section('auth');
    final email = section('auth.email');
    expect(auth, contains('enable_anonymous_sign_ins = true'));
    expect(auth, contains('enable_manual_linking = true'));
    expect(email, contains('double_confirm_changes = true'));
    expect(email, contains('enable_confirmations = true'));
  });

  test('email change template is configured with its own subject and path', () {
    final emailChange = section('auth.email.template.email_change');
    expect(
      emailChange,
      contains('subject = "Подтверждение email в приложении университета"'),
    );
    expect(
      emailChange,
      contains('content_path = "./supabase/templates/email_change.html"'),
    );
    for (final type in ['confirmation', 'magic_link', 'recovery']) {
      expect(
        section('auth.email.template.$type'),
        contains('content_path = "./supabase/templates/$type.html"'),
      );
    }
  });

  test('guest email includes one visible OTP without exposing its hash', () {
    expect(RegExp(r'\{\{\s*\.Token\s*\}\}').allMatches(template), hasLength(1));
    expect(template, isNot(contains('.TokenHash')));
    expect(template, contains('Введи этот код в приложении'));
  });

  test('conventional email changes retain their confirmation link', () {
    final optionalLink = RegExp(
      r'\{\{\s*if\s+\.Email\s*\}\}([\s\S]*?)\{\{\s*end\s*\}\}',
    ).firstMatch(template)?.group(1);
    expect(optionalLink, isNotNull);
    expect(optionalLink, contains('href="{{ .ConfirmationURL }}"'));
    expect(optionalLink, isNot(contains('{{ .Token }}')));
    expect(
      RegExp(r'\{\{\s*\.ConfirmationURL\s*\}\}').allMatches(template),
      hasLength(1),
    );
  });

  test('email change reuses the existing auth email visual style', () {
    final confirmation = File(
      'supabase/templates/confirmation.html',
    ).readAsStringSync();
    for (final style in [
      'background:#0F0F0F',
      'max-width:460px',
      'background:#1C1C1C',
      'background:#A45CFF',
      'font-size:34px',
      'letter-spacing:10px',
    ]) {
      expect(confirmation, contains(style));
      expect(template, contains(style));
    }
    expect(template, isNot(contains('<!--')));
    expect(template, isNot(contains('<script')));
  });
}
