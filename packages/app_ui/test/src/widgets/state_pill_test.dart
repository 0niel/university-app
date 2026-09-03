import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Finder surface() => find.descendant(
        of: find.byType(AppPillButton),
        matching: find.byType(Container),
      );

  Finder pressable() => find.descendant(
        of: find.byType(AppPillButton),
        matching: find.byType(AppPressable),
      );

  testWidgets('default pill keeps compact 44px reference visuals', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppPillButton(
            label: 'Добавить',
            background: kitColors.tint,
            foreground: kitColors.accent,
            onPressed: () {},
          ),
        ),
      ),
    );

    final pill = tester.getRect(surface());
    final label = tester.getRect(find.text('Добавить'));
    expect(pill.height, AppControlSize.buttonSmall);
    expect(pill.width, lessThan(320));
    expect(pill.width - label.width, AppSpacing.fieldGap * 2);
    expect(kitDecoration(tester, surface()).color, kitColors.tint);
    expect(
      kitDecoration(tester, surface()).borderRadius,
      BorderRadius.circular(AppRadius.full),
    );
    expect(kitStyleOf(tester, 'Добавить')?.fontSize, 13);
    expect(kitStyleOf(tester, 'Добавить')?.fontWeight, FontWeight.w700);
  });

  testWidgets('smaller visuals retain a 44px tappable area', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        AppPillButton(
          label: 'Готово',
          background: kitColors.tint,
          foreground: kitColors.accent,
          height: AppControlSize.iconButtonSmall,
          onPressed: () => taps++,
        ),
      ),
    );

    final visual = tester.getRect(surface());
    final target = tester.getRect(pressable());
    expect(visual.height, AppControlSize.iconButtonSmall);
    expect(target.height, AppControlSize.touchTarget);
    expect(target.center, visual.center);
    await tester.tapAt(target.topCenter + const Offset(0, 1));
    expect(taps, 1);
  });

  testWidgets('long labels wrap and grow at 200 percent', (tester) async {
    const label = 'Добавить расписание';
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 220,
          child: AppPillButton(
            label: label,
            background: kitColors.tint,
            foreground: kitColors.accent,
            onPressed: () {},
          ),
        ),
        textScale: 2,
      ),
    );

    final button = tester.getRect(surface());
    final text = tester.widget<Text>(find.text(label));
    expect(button.width, lessThanOrEqualTo(220));
    expect(button.height, greaterThan(AppControlSize.buttonSmall));
    expect(tester.getSize(find.text(label)).height, greaterThan(26 * 1.3));
    expect(text.maxLines, isNull);
    expect(text.overflow, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('schedule empty action stays inside a narrow scaled card', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppEmptyState(
            title: 'Нет расписания',
            subtitle: 'Выберите группу',
            actionLabel: 'Добавить расписание',
            onAction: () => taps++,
          ),
        ),
        textScale: 2,
      ),
    );

    final card = tester.getRect(find.byType(AppEmptyState));
    final button = tester.getRect(surface());
    expect(button.left, greaterThanOrEqualTo(card.left + AppSpacing.fieldGap));
    expect(button.right, lessThanOrEqualTo(card.right - AppSpacing.fieldGap));
    expect(button.height, greaterThan(AppControlSize.buttonSmall));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Добавить расписание'));
    expect(taps, 1);
  });

  testWidgets('error actions wrap instead of overflowing at 200 percent', (
    tester,
  ) async {
    var retries = 0;
    var selections = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppErrorState(
            title: 'Не загрузилось',
            message: null,
            footnote: null,
            primaryLabel: 'Повторить загрузку',
            secondaryLabel: 'Выбрать расписание',
            onPrimary: () => retries++,
            onSecondary: () => selections++,
          ),
        ),
        textScale: 2,
      ),
    );

    final secondary = tester.getRect(surface().first);
    final primary = tester.getRect(surface().last);
    expect(primary.top - secondary.bottom, AppSpacing.gap);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Повторить загрузку'));
    await tester.tap(find.text('Выбрать расписание'));
    expect(retries, 1);
    expect(selections, 1);
  });

  testWidgets('compatibility pill delegates to the adaptive shared control', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 240,
          child: NinjaPillButton(
            label: 'Подтвердить выбранное расписание',
            tone: NinjaPillTone.primary,
            expanded: true,
            onPressed: () {},
          ),
        ),
        textScale: 2,
      ),
    );

    expect(find.byType(AppPillButton), findsOneWidget);
    expect(tester.getSize(surface()).width, 240);
    expect(
      tester.getSize(surface()).height,
      greaterThan(AppControlSize.buttonSmall),
    );
    expect(kitDecoration(tester, surface()).color, kitColors.accent);
    expect(tester.takeException(), isNull);
  });
}
