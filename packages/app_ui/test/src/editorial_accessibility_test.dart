import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'kit_harness.dart';

void main() {
  testWidgets('reduced motion stops the pulse ticker', (tester) async {
    await tester.pumpWidget(
      wrapKit(const AppPulseDot(), accessibleNavigation: true),
    );
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('list rows expose their independent trailing switch',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppListRow(
          title: 'Уведомления',
          meta: '3',
          onTap: () {},
          trailing:
              AppSwitch(value: true, onChanged: (_) {}, label: 'Получать'),
        ),
      ),
    );
    final data = tester.getSemantics(find.byType(AppSwitch)).getSemanticsData();
    expect(data.flagsCollection.isToggled, ui.Tristate.isTrue);
    expect(data.hasAction(ui.SemanticsAction.tap), isTrue);
  });

  testWidgets('disabled buttons have disabled semantics', (tester) async {
    await tester.pumpWidget(
      wrapKit(
        const Column(
          children: [
            AppButton.primary(label: 'Сохранить'),
            AppIconButton(
              icon: AppLineIconWidget(AppLineIcon.search),
              tooltip: 'Поиск',
            ),
          ],
        ),
      ),
    );
    final controlIds = <int>{};
    for (final (type, label) in [
      (AppButton, 'Сохранить'),
      (AppIconButton, 'Поиск'),
    ]) {
      final node = tester.getSemantics(
        find.descendant(
          of: find.byType(type),
          matching: find.byType(AppPressState),
        ),
      );
      final data = node.getSemanticsData();
      controlIds.add(node.id);
      expect(data.label, label);
      expect(data.flagsCollection.isButton, isTrue);
      expect(
        data.flagsCollection.isEnabled,
        ui.Tristate.isFalse,
        reason: '$type must expose its own disabled semantics',
      );
      expect(data.flagsCollection.isFocused, ui.Tristate.none);
      expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
      expect(data.hasAction(ui.SemanticsAction.focus), isFalse);
    }
    expect(controlIds, hasLength(2));
    final accessibleControls = tester.semantics
        .simulatedAccessibilityTraversal()
        .where((node) => controlIds.contains(node.id));
    expect(accessibleControls, hasLength(2));
  });

  testWidgets('inner header contains long trailing text at 200 percent',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapKit(
        AppInnerHeader(
          title: 'Опросы',
          trailingLabel: '24 активных опроса',
          onBack: () {},
          actions: [AppHeaderAction(icon: AppLineIcon.plus, onTap: () {})],
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  test('text uses package-qualified font families', () {
    expect(AppText.body.fontFamily, 'packages/app_ui/Onest');
    expect(AppText.display.fontFamily, 'packages/app_ui/Literata');
  });

  testWidgets('week stays usable at 320px and double text size',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    int? selected;
    await tester.pumpWidget(
      wrapKit(
        AppWeekStrip(
          days: List.generate(
            7,
            (index) => AppWeekDay('${index + 10}', short: 'ПН'),
          ),
          selectedIndex: 0,
          onSelected: (index) => selected = index,
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(AppDayPill).first).height,
      greaterThan(64),
    );
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('16'));
    expect(selected, 6);
  });

  testWidgets('lesson time and actions fit double text size', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var opened = false;
    await tester.pumpWidget(
      wrapKit(
        AppLessonRow(
          title: 'Математический анализ',
          time: '10:40',
          endTime: '12:10',
          meta: 'Практика · Г-402',
          onMore: () => opened = true,
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    final more = find.byWidgetPredicate(
      (widget) => widget is AppPressable && widget.onTap != null,
    );
    expect(tester.getSize(more).width, greaterThanOrEqualTo(44));
    expect(tester.getSize(more).height, greaterThanOrEqualTo(44));
    await tester.tap(more);
    expect(opened, isTrue);
  });

  testWidgets('deadline keeps separate toggle semantics and reduced motion', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var toggled = false;
    var opened = false;
    await tester.pumpWidget(
      wrapKit(
        AppDeadlineRow(
          title: 'Лабораторная',
          meta: 'Физика',
          left: 'завтра',
          onTap: () => opened = true,
          onToggle: () => toggled = true,
        ),
        accessibleNavigation: true,
      ),
    );
    final check = find.byType(AppDeadlineCheck);
    final node = tester.getSemantics(check);
    expect(node.getSemanticsData().hasAction(ui.SemanticsAction.tap), isTrue);
    expect(
      node.getSemanticsData().flagsCollection.isToggled,
      ui.Tristate.isFalse,
    );
    await tester.tap(check);
    expect(toggled, isTrue);
    expect(opened, isFalse);
    final animations = tester.widgetList<AnimatedContainer>(
      find.descendant(of: check, matching: find.byType(AnimatedContainer)),
    );
    expect(animations.single.duration, Duration.zero);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
