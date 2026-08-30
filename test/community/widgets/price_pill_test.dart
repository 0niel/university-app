import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/widgets/price_pill.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

double _contrastRatio(Color foreground, Color background) {
  final lighter = foreground.computeLuminance() > background.computeLuminance()
      ? foreground.computeLuminance()
      : background.computeLuminance();
  final darker = foreground.computeLuminance() > background.computeLuminance()
      ? background.computeLuminance()
      : foreground.computeLuminance();
  return (lighter + .05) / (darker + .05);
}

Widget _wrap(ThemeData theme, {String? text}) {
  return MaterialApp(
    theme: theme,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(child: PricePill(free: true, text: text)),
    ),
  );
}

void main() {
  for (final (name, theme) in [
    ('light', NinjaTheme.light()),
    ('dark', NinjaTheme.dark()),
  ]) {
    testWidgets('free price is localized and readable in $name theme', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(theme));

      final label = tester.widget<Text>(find.text('Free'));
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('Free'), matching: find.byType(Container)),
      );
      final background = (container.decoration! as BoxDecoration).color!;

      expect(find.text('Бесплатно'), findsNothing);
      expect(_contrastRatio(label.style!.color!, background), greaterThan(4.5));
    });
  }

  testWidgets('explicit free label overrides localization', (tester) async {
    await tester.pumpWidget(_wrap(NinjaTheme.light(), text: 'Included'));

    expect(find.text('Included'), findsOneWidget);
    expect(find.text('Free'), findsNothing);
  });
}
