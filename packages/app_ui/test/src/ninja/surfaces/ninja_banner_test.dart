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
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  BoxDecoration decorationOf(WidgetTester tester) {
    return tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(NinjaBanner),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere(
          (value) =>
              value.borderRadius == BorderRadius.circular(NinjaRadius.card),
        );
  }

  testWidgets('danger tone tints the frame and colors the title', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NinjaBanner(
          title: 'Риск недопуска по физике',
          tone: NinjaBannerTone.danger,
          body: 'Сдайте отчёт №3 до завтра 23:59',
        ),
      ),
    );

    final decoration = decorationOf(tester);
    expect(decoration.color, colors.surface);
    expect(decoration.border, isNull);

    final title =
        tester.widget<Text>(find.text('Риск недопуска по физике')).style;
    expect(title?.fontSize, 15);
    expect(title?.fontWeight, FontWeight.w600);
    expect(title?.color, colors.ink);
  });

  testWidgets('warn tone uses the readable amber ink', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NinjaBanner(
          title: 'Оффлайн · данные на 9:40',
          tone: NinjaBannerTone.warn,
        ),
      ),
    );

    expect(decorationOf(tester).color, colors.surface);
    expect(
      tester.widget<Text>(find.text('Оффлайн · данные на 9:40')).style?.color,
      colors.ink,
    );
    expect(
      tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget)).color,
      colors.amberInk,
    );
  });

  testWidgets('success tone renders the green check glyph', (tester) async {
    await tester.pumpWidget(
      wrap(
        const NinjaBanner(
          title: 'Справка готова',
          tone: NinjaBannerTone.success,
        ),
      ),
    );

    expect(decorationOf(tester).color, colors.surface);
    final glyph = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(glyph.icon, AppLineIcon.check);
    expect(glyph.color, colors.green);
    expect(glyph.size, 20);
  });

  testWidgets('info tone is the default and carries a tappable action', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        NinjaBanner(
          title: 'Аудитория изменена',
          body: 'Маршрут обновлён',
          actionLabel: 'открыть',
          onAction: () => taps++,
        ),
      ),
    );

    expect(decorationOf(tester).color, colors.surface);
    expect(
      tester.widget<Text>(find.text('Аудитория изменена')).style?.color,
      colors.ink,
    );

    final action = tester.widget<Text>(find.text('открыть')).style;
    expect(action?.color, colors.brandInk);
    expect(action?.fontWeight, FontWeight.w600);
    expect(
      tester
          .getSize(
            find.ancestor(
              of: find.text('открыть'),
              matching: find.byType(AppPressable),
            ),
          )
          .height,
      greaterThanOrEqualTo(NinjaMetrics.minTouchTarget),
    );

    await tester.tap(find.text('открыть'));
    expect(taps, 1);
  });

  testWidgets('stays flat and overflow-free at 320px and 200 percent text', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrap(
        const Padding(
          padding: EdgeInsets.all(16),
          child: NinjaBanner(
            title: 'Расписание временно недоступно',
            body: 'Показываем последние сохранённые данные для этого дня',
            actionLabel: 'Повторить загрузку',
            onAction: _noop,
          ),
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(decorationOf(tester).border, isNull);
  });
}

void _noop() {}
