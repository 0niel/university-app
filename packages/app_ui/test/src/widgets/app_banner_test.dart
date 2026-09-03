import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppBanner', () {
    testWidgets('renders the message and an 8px dot', (tester) async {
      await tester.pumpWidget(
        wrap(const AppBanner(message: 'Расписание обновлено')),
      );

      expect(find.text('Расписание обновлено'), findsOneWidget);
      expect(tester.widget<AppDot>(find.byType(AppDot)).size, 8);
    });

    testWidgets('renders the action and fires onAction', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          AppBanner(
            message: 'Нет связи',
            tone: AppBannerTone.danger,
            actionLabel: 'Повторить',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Повторить'), findsOneWidget);
      await tester.tap(find.text('Повторить'));
      expect(tapped, isTrue);
    });

    testWidgets('keeps a 44px minimum height', (tester) async {
      await tester.pumpWidget(wrap(const AppBanner(message: 'Коротко')));

      expect(
        tester.getSize(find.byType(AppBanner)).height,
        greaterThanOrEqualTo(44),
      );
    });

    testWidgets('every tone builds', (tester) async {
      for (final tone in AppBannerTone.values) {
        await tester.pumpWidget(
          wrap(AppBanner(message: tone.name, tone: tone)),
        );
        expect(find.text(tone.name), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  });
}
