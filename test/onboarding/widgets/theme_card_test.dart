import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/onboarding/widgets/theme_card.dart';

void main() {
  Widget wrap(Widget child, {TextScaler textScaler = TextScaler.noScaling}) {
    return MaterialApp(
      locale: const Locale('ru'),
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      ),
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

  testWidgets('theme choices remain actionable at 320px and 200 percent text', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var current = AdaptiveThemeMode.light;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: OnboardingThemeCard(
              mode: current,
              onChanged: (mode) => setState(() => current = mode),
            ),
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (final option in [
      ('Тёмная', AdaptiveThemeMode.dark),
      ('Авто', AdaptiveThemeMode.system),
      ('Светлая', AdaptiveThemeMode.light),
    ]) {
      await tester.ensureVisible(find.text(option.$1));
      await tester.tap(find.text(option.$1));
      await tester.pumpAndSettle();
      expect(current, option.$2);
      expect(tester.takeException(), isNull);
    }
  });
}
