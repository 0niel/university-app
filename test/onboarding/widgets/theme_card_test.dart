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
    var current = AdaptiveThemeMode.light;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => OnboardingThemeCard(
            mode: current,
            onChanged: (mode) {
              selections.add(mode);
              setState(() => current = mode);
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Светлая'), findsOneWidget);
    expect(find.text('Тёмная'), findsOneWidget);
    expect(find.text('Авто'), findsOneWidget);

    await tester.tap(find.text('Тёмная'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Авто'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Авто'));
    await tester.pumpAndSettle();

    expect(selections, [AdaptiveThemeMode.dark, AdaptiveThemeMode.system]);
  });
}
