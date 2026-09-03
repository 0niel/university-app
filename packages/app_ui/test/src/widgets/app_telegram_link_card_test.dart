import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: SizedBox(width: 360, child: child))),
      );

  group('AppTelegramLinkCard', () {
    testWidgets('link variant shows title, handle and action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppTelegramLinkCard(
            title: 'Чат ИКБО-09',
            handle: 't.me/ikbo09',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Чат ИКБО-09'), findsOneWidget);
      expect(find.text('t.me/ikbo09'), findsOneWidget);
      expect(find.text('Открыть'), findsOneWidget);

      await tester.tap(find.text('Открыть'));
      expect(tapped, isTrue);
    });

    testWidgets('add variant shows the label inside a dashed border', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppTelegramLinkCard.add(label: 'Добавить ссылку')),
      );

      expect(find.text('Добавить ссылку'), findsOneWidget);
      expect(find.byType(AppDashedBorder), findsOneWidget);
      final icon = tester.widget<AppLineIconWidget>(
        find.byType(AppLineIconWidget),
      );
      expect(icon.icon, AppLineIcon.plus);
    });
  });
}
