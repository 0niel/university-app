import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/wallet/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: NinjaTheme.dark(),
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('WalletEarnTab', () {
    testWidgets('shows only the live row and a collapsed "coming soon" '
        'toggle by default', (tester) async {
      await tester.pumpWidget(_wrap(const WalletEarnTab()));

      // Live rows (upload, quests) are always visible; attendance was
      // removed from the app so its row is behind the toggle.
      expect(find.text('Посещай пары'), findsNothing);
      expect(find.text('Залей конспект'), findsOneWidget);
      expect(find.text('Закрывай квесты'), findsOneWidget);
      // Non-live rows stay collapsed until the toggle is tapped.
      expect(find.text('Держи стрик'), findsNothing);
      expect(find.text('Позови друга'), findsNothing);
      expect(find.text('Скоро · 7'), findsOneWidget);
    });

    testWidgets('expands every non-live row on toggle tap', (tester) async {
      await tester.pumpWidget(_wrap(const WalletEarnTab()));

      await tester.tap(find.text('Скоро · 7'));
      await tester.pump();

      expect(find.text('Держи стрик'), findsOneWidget);
      expect(find.text('Позови друга'), findsOneWidget);
    });
  });
}
