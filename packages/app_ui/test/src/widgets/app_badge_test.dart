import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  group('AppBadge', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(wrap(const AppBadge(label: 'Новое')));

      expect(find.text('Новое'), findsOneWidget);
      expect(find.byType(AppDot), findsNothing);
    });

    testWidgets('renders a 6px dot when dot is set', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppBadge(
            label: 'Экзамен',
            tone: AppBadgeTone.exam,
            dot: true,
          ),
        ),
      );

      final dot = tester.widget<AppDot>(find.byType(AppDot));
      expect(dot.size, 6);
      expect(tester.getSize(find.byType(AppDot)).width, 6);
    });

    testWidgets('renders a leading icon instead of a dot', (tester) async {
      await tester.pumpWidget(
        wrap(const AppBadge(label: 'Проверено', icon: AppLineIcon.check)),
      );

      expect(find.byType(AppLineIconWidget), findsOneWidget);
      expect(find.byType(AppDot), findsNothing);
    });

    testWidgets('every tone builds', (tester) async {
      for (final tone in AppBadgeTone.values) {
        await tester.pumpWidget(wrap(AppBadge(label: tone.name, tone: tone)));
        expect(find.text(tone.name), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });
  });

  group('AppCountBadge', () {
    testWidgets('renders the raw count at 22px height', (tester) async {
      await tester.pumpWidget(wrap(const AppCountBadge(7)));

      expect(find.text('7'), findsOneWidget);
      final size = tester.getSize(find.byType(AppCountBadge));
      expect(size.height, 22);
      expect(size.width, inInclusiveRange(22, 24));
    });

    testWidgets('clamps above max', (tester) async {
      await tester.pumpWidget(wrap(const AppCountBadge(1200)));

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('honours a custom max', (tester) async {
      await tester.pumpWidget(wrap(const AppCountBadge(12, max: 9)));

      expect(find.text('9+'), findsOneWidget);
    });
  });

  group('AppDot', () {
    testWidgets('defaults to 10px', (tester) async {
      await tester.pumpWidget(wrap(const AppDot()));

      expect(tester.getSize(find.byType(AppDot)), const Size(10, 10));
    });
  });

  group('AppTypeTag', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(wrap(const AppTypeTag('ЛАБ')));

      expect(find.text('ЛАБ'), findsOneWidget);
    });
  });
}
