import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(body: Center(child: SizedBox(width: 360, child: child))),
      );

  group('AppActivityRow', () {
    testWidgets('renders time, type pill, title and meta', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppActivityRow(
            type: AppActivityType.retake,
            time: '15:00',
            endTime: '16:30',
            title: 'Пересдача по матанализу',
            place: 'А-315',
            subtitle: 'Иванов И.И.',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Пересдача'), findsOneWidget);
      expect(find.text('Пересдача по матанализу'), findsOneWidget);
      expect(find.text('А-315 · Иванов И.И.'), findsOneWidget);
      expect(find.byType(AppDashedBorder), findsOneWidget);

      await tester.tap(find.byType(AppActivityRow));
      expect(tapped, isTrue);
    });

    testWidgets('the type tone comes from the palette', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppActivityRow(
            type: AppActivityType.extra,
            time: '09:00',
            title: 'Доп. пара',
          ),
        ),
      );

      expect(
        AppActivityType.extra.color(AppColors.light),
        AppColors.light.lecture,
      );
      expect(AppActivityType.extra.icon, AppLineIcon.plus);
      expect(
        tester.widget<Text>(find.text('Доп. занятие')).style?.color,
        AppColors.light.lecture,
      );
    });
  });
}
