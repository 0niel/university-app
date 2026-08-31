import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colors = NinjaColors.light();

  Widget wrap(
    Widget child, {
    TextScaler textScaler = TextScaler.noScaling,
  }) =>
      MaterialApp(
        theme: NinjaTheme.light(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
        home: Scaffold(body: child),
      );

  group('NinjaLessonRow', () {
    testWidgets('renders subject, time and meta', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaLessonRow(
            title: 'Матанализ',
            time: '10:15–11:45',
            meta: 'лекция · 314 Б · Смирнова Е. В.',
            color: Color(0xFF4F46E5),
          ),
        ),
      );

      expect(find.text('Матанализ'), findsOneWidget);
      expect(find.text('10:15–11:45'), findsOneWidget);
      expect(find.text('лекция · 314 Б · Смирнова Е. В.'), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('10:15–11:45')).style?.color,
        colors.mutedDark,
      );
    });

    testWidgets('past lesson dims without losing content', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaLessonRow(
            title: 'История',
            time: '8:30–10:00',
            past: true,
          ),
        ),
      );

      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.5);
    });

    testWidgets('current lesson takes the contrast surface and inline actions',
        (
      tester,
    ) async {
      var routed = 0;
      await tester.pumpWidget(
        wrap(
          NinjaLessonRow(
            title: 'Матанализ',
            time: '10:15–11:45',
            current: true,
            actions: [
              NinjaLessonAction(
                label: 'До 120 А — 6 мин',
                onPressed: () => routed++,
              ),
              const NinjaLessonAction(label: 'Конспект', primary: false),
            ],
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is DecoratedBox &&
              (widget.decoration as BoxDecoration).color == colors.ink,
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<Text>(find.text('10:15–11:45')).style?.color,
        colors.onInk.withValues(alpha: 0.68),
      );
      expect(find.byType(NinjaActionButton), findsNWidgets(2));
      expect(find.byType(AppLineIconWidget), findsOneWidget);

      await tester.tap(find.text('До 120 А — 6 мин'));
      expect(routed, 1);
    });

    testWidgets('inline chip rides inside the title', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaLessonRow(
            title: 'Физика',
            time: '12:00–13:30',
            chipLabel: 'отчёт №3',
          ),
        ),
      );

      final chip = tester.widget<Text>(find.text('отчёт №3')).style;
      expect(chip?.fontSize, 10.5);
      expect(chip?.fontWeight, FontWeight.w600);
      expect(chip?.color, colors.scarlet);
    });

    testWidgets('is tappable when a handler is given', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(
          NinjaLessonRow(
            title: 'Физика',
            time: '12:00–13:30',
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.text('Физика'));
      expect(taps, 1);
    });

    testWidgets('stacks time without overflow at 320px and 200 percent text', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(320, 568)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        wrap(
          const SingleChildScrollView(
            child: NinjaLessonRow(
              title: 'Проектирование информационных систем',
              time: '10:40–12:10',
              meta: 'лекция · А-123 · Иванов Иван Иванович',
            ),
          ),
          textScaler: const TextScaler.linear(2),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('NinjaGapRow', () {
    testWidgets('prints muted gap copy', (tester) async {
      await tester.pumpWidget(
        wrap(const NinjaGapRow(text: 'окно 15 мин → корпус А')),
      );

      final style =
          tester.widget<Text>(find.text('окно 15 мин → корпус А')).style;
      expect(style?.fontSize, 12.5);
      expect(style?.fontWeight, FontWeight.w500);
      expect(style?.color, colors.muted);
    });
  });

  group('NinjaNowLine', () {
    testWidgets('renders a compact brand time marker', (tester) async {
      await tester.pumpWidget(wrap(const NinjaNowLine(label: 'СЕЙЧАС 11:11')));

      final style = tester.widget<Text>(find.text('СЕЙЧАС 11:11')).style;
      expect(style?.fontSize, 10.5);
      expect(style?.fontWeight, FontWeight.w800);
      expect(style?.color, colors.brandInk);

      final markers = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .where(
            (box) =>
                (box.decoration as BoxDecoration?)?.color == colors.brandTint,
          );
      expect(markers, hasLength(1));
      expect(find.byType(AppLineIconWidget), findsOneWidget);
    });
  });

  group('NinjaDisplayHeader', () {
    testWidgets('renders display title and muted summary', (tester) async {
      await tester.pumpWidget(
        wrap(
          const NinjaDisplayHeader(
            title: 'Среда,\n13 августа',
            summary: '4 пары · 2 корпуса · числитель',
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('Среда,\n13 августа')).style;
      expect(title?.fontSize, 28);
      expect(title?.fontWeight, FontWeight.w700);
      expect(title?.letterSpacing, -0.5);

      final summary = tester
          .widget<Text>(find.text('4 пары · 2 корпуса · числитель'))
          .style;
      expect(summary?.fontSize, 13);
      expect(summary?.color, colors.muted);
    });
  });
}
