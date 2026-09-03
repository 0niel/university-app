import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/widgets/guest_upgrade_sheet.dart';
import 'package:user_repository/user_repository.dart';

class _UserRepository extends Mock implements UserRepository {}

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  ),
);

Finder _field(String name) => find.descendant(
  of: find.byKey(ValueKey(name)),
  matching: find.byType(EditableText),
);

void main() {
  testWidgets(
    'guest upgrade preserves user id through verified email and password',
    (tester) async {
      final repository = _UserRepository();
      when(
        () => repository.linkGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
        ),
      ).thenAnswer((_) async {});
      when(
        () => repository.verifyGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
          code: '123456',
        ),
      ).thenAnswer((_) async {});
      when(
        () => repository.setAccountPassword(
          userId: 'guest',
          password: 'password123',
        ),
      ).thenAnswer((_) async {});
      var saved = false;
      await tester.pumpWidget(
        _app(
          GuestUpgradeSheet(
            userId: 'guest',
            repository: repository,
            onSaved: () => saved = true,
          ),
        ),
      );
      final submit = find.byKey(const ValueKey('guest-upgrade-submit'));
      expect(tester.widget<AppButton>(submit).onPressed, isNull);
      await tester.enterText(
        _field('guest-upgrade-email'),
        'student@gmail.com',
      );
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      verifyNever(
        () => repository.setAccountPassword(
          userId: any(named: 'userId'),
          password: any(named: 'password'),
        ),
      );
      await tester.enterText(_field('guest-upgrade-code'), '123456');
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      await tester.enterText(_field('guest-upgrade-password'), 'password123');
      await tester.enterText(
        _field('guest-upgrade-confirmation'),
        'password123',
      );
      await tester.pump();
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(saved, isTrue);
      verifyInOrder([
        () => repository.linkGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
        ),
        () => repository.verifyGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
          code: '123456',
        ),
        () => repository.setAccountPassword(
          userId: 'guest',
          password: 'password123',
        ),
      ]);
      verifyNever(repository.logOut);
    },
  );

  testWidgets(
    'guest upgrade keeps a failed account link retryable and single flight',
    (tester) async {
      final repository = _UserRepository();
      final completion = Completer<void>();
      when(
        () => repository.linkGuestEmail(
          userId: 'guest',
          email: 'student@gmail.com',
        ),
      ).thenAnswer((_) => completion.future);
      await tester.pumpWidget(
        _app(
          GuestUpgradeSheet(
            userId: 'guest',
            repository: repository,
            onSaved: () {},
          ),
        ),
      );
      await tester.enterText(
        _field('guest-upgrade-email'),
        'student@gmail.com',
      );
      await tester.pump();
      final submit = find.byKey(const ValueKey('guest-upgrade-submit'));
      await tester.tap(submit);
      await tester.pump();
      expect(tester.widget<AppButton>(submit).onPressed, isNull);
      completion.completeError(Exception('email conflict'));
      await tester.pumpAndSettle();
      expect(find.byType(AppBanner), findsOneWidget);
      expect(find.byKey(const ValueKey('guest-upgrade-email')), findsOneWidget);
      expect(tester.widget<AppButton>(submit).onPressed, isNotNull);
      verifyNever(repository.logOut);
    },
  );
}
