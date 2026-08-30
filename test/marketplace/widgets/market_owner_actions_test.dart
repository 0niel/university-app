import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/marketplace.dart';

void main() {
  Widget buildSubject({
    required bool isBusy,
    VoidCallback? onToggleSold,
    VoidCallback? onDelete,
  }) => MaterialApp(
    theme: NinjaTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('ru'),
    home: Scaffold(
      body: MarketOwnerActions(
        isSold: false,
        isBusy: isBusy,
        onToggleSold: onToggleSold ?? () {},
        onDelete: onDelete ?? () {},
      ),
    ),
  );

  testWidgets('hides the busy spinner when idle', (tester) async {
    await tester.pumpWidget(buildSubject(isBusy: false));

    expect(find.byType(NinjaSpinner), findsNothing);
  });

  testWidgets('overlays a spinner and disables actions while busy', (
    tester,
  ) async {
    var toggled = false;
    var deleted = false;
    await tester.pumpWidget(
      buildSubject(
        isBusy: true,
        onToggleSold: () => toggled = true,
        onDelete: () => deleted = true,
      ),
    );

    expect(find.byType(NinjaSpinner), findsOneWidget);
    final buttons = tester.widgetList<NinjaIconButton>(
      find.byType(NinjaIconButton),
    );
    for (final button in buttons) {
      expect(button.onPressed, isNull);
    }

    await tester.tap(
      find.byTooltip('Отметить проданным'),
      warnIfMissed: false,
    );
    await tester.tap(
      find.byTooltip('Удалить объявление'),
      warnIfMissed: false,
    );

    expect(toggled, isFalse);
    expect(deleted, isFalse);
  });
}
