import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_page.dart';

void main() {
  testWidgets('shows a retry action when runtime initialization fails', (
    tester,
  ) async {
    var attempts = 0;
    final retryCompleter = Completer<void>();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MiniAppRunnerPage(
          slug: 'test-app',
          runtimeInitializerBuilder: () {
            attempts += 1;
            if (attempts == 1) return Future<void>.error(Exception('boom'));
            return retryCompleter.future;
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Повторить'), findsOneWidget);
    expect(attempts, 1);

    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();

    expect(attempts, 2);
    expect(retryCompleter.isCompleted, isFalse);
  });
}
