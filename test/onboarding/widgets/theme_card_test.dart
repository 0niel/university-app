import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/theme_card.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      locale: const Locale('ru'),
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('offers light, dark and system modes', (tester) async {
    final selections = <AdaptiveThemeMode>[];
    await tester.pumpWidget(
      wrap(OnboardingThemeCard(onChanged: selections.add)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Светлая'), findsOneWidget);
    expect(find.text('Тёмная'), findsOneWidget);
    expect(find.text('Авто'), findsOneWidget);

    await tester.tap(find.text('Тёмная'));
    await tester.tap(find.text('Авто'));
    await tester.pumpAndSettle();

    expect(selections, [AdaptiveThemeMode.dark]);
  });
}
