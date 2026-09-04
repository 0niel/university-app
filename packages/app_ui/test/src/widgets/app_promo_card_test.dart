import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('AppPromoCard renders copy and fires callbacks', (tester) async {
    var tapped = 0;
    var closed = 0;
    await tester.pumpWidget(
      wrap(
        AppPromoCard(
          title: 'Курьер Яндекс Еды',
          kicker: 'Подработка',
          subtitle: 'Выплаты каждый день',
          emoji: '🛵',
          actionLabel: 'Подробнее',
          accent: const Color(0xFFFC3F1D),
          onTap: () => tapped++,
          onClose: () => closed++,
          closeSemanticsLabel: 'Скрыть',
        ),
      ),
    );

    expect(find.text('Курьер Яндекс Еды'), findsOneWidget);
    expect(find.text('ПОДРАБОТКА'), findsOneWidget);
    expect(find.text('Подробнее'), findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.close,
      ),
    );
    expect(closed, 1);
    expect(tapped, 0);

    await tester.tap(find.text('Курьер Яндекс Еды'));
    expect(tapped, 1);
  });

  testWidgets('AppPromoCard without onClose has no close control', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AppPromoCard(
          title: 'Title',
          accent: Color(0xFF3366FF),
          solid: false,
        ),
      ),
    );

    expect(find.byType(AppPressable), findsNothing);
  });
}
