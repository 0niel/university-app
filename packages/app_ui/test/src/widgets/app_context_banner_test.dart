import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppContextBanner', () {
    testWidgets('renders title, subtitle and action label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppContextBanner(
            emoji: '🥷',
            title: 'Маскировка',
            subtitle: 'EXIF стёрт',
            actionLabel: 'Настроить',
          ),
        ),
      );

      expect(find.text('🥷'), findsOneWidget);
      expect(find.text('Маскировка'), findsOneWidget);
      expect(find.text('EXIF стёрт'), findsOneWidget);
      expect(find.text('Настроить'), findsOneWidget);
    });

    testWidgets('the icon variant paints a flat tinted banner', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppContextBanner(
            icon: AppLineIcon.shield,
            title: 'Конфликт',
            subtitle: 'Расписание изменилось',
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppContextBanner),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.gradient, isNull);
      expect(decoration.boxShadow, isNull);
    });

    testWidgets('fires onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppContextBanner(
            icon: AppLineIcon.bell,
            title: 'Синхронизация',
            subtitle: 'Нет связи',
            actionLabel: 'Повторить',
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Повторить'));
      expect(tapped, isTrue);
    });
  });
}
