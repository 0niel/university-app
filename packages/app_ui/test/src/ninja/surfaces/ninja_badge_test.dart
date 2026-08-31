import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  BoxDecoration decorationOf(WidgetTester tester, Type type) {
    final decorated = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(type),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    return decorated.decoration as BoxDecoration;
  }

  group('NinjaBadge', () {
    testWidgets('default tone uses the readable selected accent', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const NinjaBadge('СЕГОДНЯ')));

      final decoration = decorationOf(tester, NinjaBadge);
      expect(decoration.color, colors.brand);
      final style = tester.widget<Text>(find.text('СЕГОДНЯ')).style;
      expect(style?.fontSize, 11.5);
      expect(style?.fontWeight, FontWeight.w600);
      expect(style?.color, colors.onBrand);
    });

    testWidgets('ink tone inverts the text', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaBadge('СОБЫТИЕ', tone: NinjaBadgeTone.ink)),
      );

      expect(decorationOf(tester, NinjaBadge).color, colors.ink);
      expect(
        tester.widget<Text>(find.text('СОБЫТИЕ')).style?.color,
        colors.onInk,
      );
    });

    testWidgets('danger tone uses a soft fill and accent dot without a border',
        (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const NinjaBadge('ДЕДЛАЙН', tone: NinjaBadgeTone.dangerOutline)),
      );

      final decoration = decorationOf(tester, NinjaBadge);
      expect(decoration.color, colors.dangerTint);
      expect(decoration.border, isNull);
      expect(
        tester.widget<Text>(find.text('ДЕДЛАЙН')).style?.color,
        colors.ink,
      );
      expect(
        find.descendant(
          of: find.byType(NinjaBadge),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is DecoratedBox &&
                (widget.decoration as BoxDecoration).color == colors.scarlet,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tint tones pair tint fills with readable text', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              NinjaBadge('ПЕРЕНОС', tone: NinjaBadgeTone.warnTint),
              NinjaBadge('ГОТОВО', tone: NinjaBadgeTone.successTint),
            ],
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('ПЕРЕНОС')).style?.color,
        colors.ink,
      );
      expect(
        tester.widget<Text>(find.text('ГОТОВО')).style?.color,
        colors.ink,
      );
    });
  });

  group('NinjaCountBadge', () {
    testWidgets('renders the count in a scarlet pill', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCountBadge(4)));

      expect(find.text('4'), findsOneWidget);
      final decoration = decorationOf(tester, NinjaCountBadge);
      expect(decoration.color, colors.scarlet);
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(NinjaCountBadge),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.minWidth, 22);
      expect(
        tester.widget<Text>(find.text('4')).style?.color,
        colors.onScarlet,
      );
    });

    testWidgets('clamps above 99', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCountBadge(128)));
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('dot variant is a bare 10px circle', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCountBadge.dot()));

      expect(find.byType(Text), findsNothing);
      final size = tester.getSize(find.byType(NinjaCountBadge));
      expect(size, const Size(10, 10));
    });

    testWidgets('count exposes one concise semantics label', (tester) async {
      await tester.pumpWidget(wrap(const NinjaCountBadge(12)));

      expect(find.bySemanticsLabel('12'), findsOneWidget);
    });
  });
}
