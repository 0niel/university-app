import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppTelegramLinkCard', () {
    testWidgets('link variant shows title, handle and action', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppTelegramLinkCard(
            title: 'Чат ИКБО-09',
            handle: 't.me/ikbo09',
          ),
        ),
      );

      expect(find.text('Чат ИКБО-09'), findsOneWidget);
      expect(find.text('t.me/ikbo09'), findsOneWidget);
      expect(find.text('Открыть'), findsOneWidget);
    });

    testWidgets('add variant shows the label', (tester) async {
      await tester.pumpWidget(
        wrap(const AppTelegramLinkCard.add(label: 'Добавить ссылку')),
      );

      expect(find.text('Добавить ссылку'), findsOneWidget);
    });
  });
}
