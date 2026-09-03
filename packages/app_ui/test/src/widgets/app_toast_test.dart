import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppToast', () {
    testWidgets('renders the message with the default check tile',
        (tester) async {
      await tester.pumpWidget(wrap(const AppToast(message: 'Сохранено')));

      expect(find.text('Сохранено'), findsOneWidget);
      expect(find.byType(AppIconTile), findsOneWidget);
    });

    testWidgets('showIcon false drops the tile', (tester) async {
      await tester.pumpWidget(
        wrap(const AppToast(message: 'Без иконки', showIcon: false)),
      );

      expect(find.byType(AppIconTile), findsNothing);
    });

    testWidgets('renders the action and fires onAction', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppToast(
            message: 'Удалено',
            actionLabel: 'Вернуть',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Вернуть'), findsOneWidget);
      await tester.tap(find.text('Вернуть'));
      expect(tapped, isTrue);
    });

    testWidgets('a custom leading replaces the icon tile', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppToast(
            message: 'Эмодзи',
            leading: Text('🥷'),
          ),
        ),
      );

      expect(find.text('🥷'), findsOneWidget);
      expect(find.byType(AppIconTile), findsNothing);
    });
  });
}
