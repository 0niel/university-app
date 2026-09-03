import 'dart:ui' show PointerDeviceKind, SemanticsAction;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Finder pressesIn(Type type) => find.descendant(
        of: find.byType(type),
        matching: find.byType(AppPressState),
      );

  testWidgets('button icons use source geometry and the large label is 600',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppButton(
          label: 'Добавить',
          icon: const AppLineIconWidget(AppLineIcon.plus),
          onPressed: () {},
        ),
      ),
    );
    final button = tester.getRect(find.byType(AppButton));
    final icon = tester.getRect(find.byType(AppLineIconWidget));
    final label = tester.getRect(find.text('Добавить'));
    expect(button.height, 48);
    expect(icon.size, const Size.square(16));
    expect(icon.left - button.left, 16);
    expect(label.left - icon.right, 8);
    expect(button.right - label.right, 18);
    expect(
      tester
          .widget<AppLineIconWidget>(find.byType(AppLineIconWidget))
          .strokeWidth,
      2.4,
    );
    await tester.pumpWidget(
      wrapKit(
        AppButton(
          label: 'Большая',
          size: AppButtonSize.large,
          onPressed: () {},
        ),
      ),
    );
    expect(kitStyleOf(tester, 'Большая')?.fontSize, 15);
    expect(kitStyleOf(tester, 'Большая')?.fontWeight, FontWeight.w600);
  });

  testWidgets('icon button keeps compact paint inside a 44px target',
      (tester) async {
    for (final size in AppIconButtonSize.values) {
      await tester.pumpWidget(
        wrapKit(
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.plus),
            size: size,
            strokeWidth: 2.4,
            onPressed: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final icon =
          tester.widget<AppLineIconWidget>(find.byType(AppLineIconWidget));
      expect(tester.getSize(pressesIn(AppIconButton)), const Size.square(44));
      expect(icon.size, size.iconSize);
      expect(icon.strokeWidth, 2.4);
      final paint = find.descendant(
        of: find.byType(AppIconButton),
        matching: find.byType(AnimatedContainer),
      );
      expect(tester.getSize(paint), Size.square(size.dimension));
    }
  });

  testWidgets('buttons expose keyboard activation and skip disabled controls',
      (tester) async {
    var first = 0;
    var last = 0;
    await tester.pumpWidget(
      wrapKit(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(label: 'First', onPressed: () => first++),
            const AppButton(label: 'Disabled'),
            AppButton(label: 'Last', onPressed: () => last++),
          ],
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .where((paint) => paint.foregroundPainter != null),
      isNotEmpty,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(first, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(first, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(last, 1);
    expect(first, 2);
  });

  testWidgets('loading spinner respects reduced motion and ticker visibility',
      (tester) async {
    Widget view({bool reduced = false, bool visible = true}) => wrapKit(
          TickerMode(
            enabled: visible,
            child: const AppButton(label: 'Loading', loading: true),
          ),
          accessibleNavigation: reduced,
        );
    await tester.pumpWidget(view(reduced: true));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(view());
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(view(visible: false));
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(view());
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('split button fits long labels and names the separate menu',
      (tester) async {
    var menus = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 180,
          child: AppSplitButton(
            label: 'Очень длинное название действия',
            onPressed: () {},
            onMenuPressed: () => menus++,
            menuSemanticLabel: 'Другие действия',
          ),
        ),
        textScale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.bySemanticsLabel('Другие действия'));
    expect(menus, 1);
    expect(tester.getSize(pressesIn(AppSplitButton).last).width, 44);
  });

  testWidgets('tooltip renders the kit bubble for hover, focus and Escape',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppButton(label: 'Target', tooltip: 'Подсказка', onPressed: () {}),
        accessibleNavigation: true,
      ),
    );
    expect(find.byType(Tooltip), findsNothing);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(AppButton)));
    await tester.pumpAndSettle();
    expect(find.byType(AppTooltip), findsOneWidget);
    expect(
      tester.widget<AppTooltip>(find.byType(AppTooltip)).arrow,
      AppTooltipArrow.down,
    );
    expect(
      tester.getRect(find.byType(AppTooltip)).bottom,
      lessThan(tester.getRect(find.byType(AppButton)).top),
    );
    expect(
      tester.widget<RawTooltip>(find.byType(RawTooltip)).animationStyle,
      AnimationStyle.noAnimation,
    );
    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.byType(AppTooltip), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(AppTooltip), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('tooltip flips below a top target and wraps at 200 percent',
      (tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrapKit(
        Align(
          alignment: Alignment.topLeft,
          child: AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.plus),
            tooltip: 'Длинная подсказка, которая переносится по ширине экрана',
            onPressed: () {},
          ),
        ),
        textScale: 2,
        accessibleNavigation: true,
      ),
    );
    await tester.longPress(find.byType(AppIconButton));
    await tester.pumpAndSettle();
    expect(find.byType(AppTooltip), findsOneWidget);
    expect(
      tester.widget<AppTooltip>(find.byType(AppTooltip)).arrow,
      AppTooltipArrow.up,
    );
    final rect = tester.getRect(find.byType(AppTooltip));
    expect(rect.left, greaterThanOrEqualTo(0));
    expect(rect.right, lessThanOrEqualTo(320));
    expect(rect.top, greaterThanOrEqualTo(44));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'input rebinds controllers, focus and validation without ownership leaks',
      (tester) async {
    final first = TextEditingController(text: 'One');
    final second = TextEditingController(text: 'Two');
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();
    addTearDown(() {
      first.dispose();
      second.dispose();
      firstFocus.dispose();
      secondFocus.dispose();
    });
    final form = GlobalKey<FormState>();
    Widget view(TextEditingController controller, FocusNode focus) => wrapKit(
          Form(
            key: form,
            child: AppInputField(
              controller: controller,
              focusNode: focus,
              validator: (value) => value == 'Two' ? null : 'Invalid',
            ),
          ),
        );
    await tester.pumpWidget(view(first, firstFocus));
    form.currentState!.validate();
    await tester.pump();
    expect(find.text('Invalid'), findsOneWidget);
    await tester.pumpWidget(view(second, secondFocus));
    expect(tester.widget<TextField>(find.byType(TextField)).controller, second);
    expect(form.currentState!.validate(), isTrue);
    await tester.pump();
    expect(find.text('Invalid'), findsNothing);
    secondFocus.requestFocus();
    await tester.pumpAndSettle();
    expect(secondFocus.hasFocus, isTrue);
    expect(firstFocus.hasFocus, isFalse);
    first.text = 'Detached';
    await tester.pump();
    expect(find.text('Two'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    expect(() => first.text = 'Still owned', returnsNormally);
    expect(() => second.text = 'Still owned', returnsNormally);
  });

  testWidgets('clear has a 44px target, validates and is absent for read-only',
      (tester) async {
    final controller = TextEditingController(text: 'Text');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      wrapKit(
        AppInputField(
          controller: controller,
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ),
    );
    final clear = pressesIn(AppInputField);
    expect(tester.getSize(clear), const Size.square(44));
    expect(
      tester.getSize(find.byType(AppLineIconWidget)),
      const Size.square(16),
    );
    await tester.tap(clear);
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    controller.text = 'Read only';
    await tester.pumpWidget(
      wrapKit(
        AppInputField(controller: controller, readOnly: true),
      ),
    );
    expect(pressesIn(AppInputField), findsNothing);
  });

  testWidgets('search buttons expose separate 44px clear and trailing actions',
      (tester) async {
    final controller = TextEditingController(text: 'Query');
    addTearDown(controller.dispose);
    var trailing = 0;
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSearchField(
            controller: controller,
            trailingIcon: AppLineIcon.mic,
            onTrailingTap: () => trailing++,
            trailingSemanticLabel: 'Filters',
          ),
        ),
      ),
    );
    for (final element in pressesIn(AppSearchField).evaluate()) {
      expect(
        tester.getSize(find.byWidget(element.widget)),
        const Size.square(44),
      );
    }
    await tester.tap(pressesIn(AppSearchField).first);
    expect(controller.text, isEmpty);
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Filters'));
    expect(trailing, 1);
    await tester.pumpWidget(
      wrapKit(
        AppSearchBar.button(
          hintText: 'Search',
          onTap: () {},
          onTrailingTap: () => trailing++,
          trailingSemanticLabel: 'Filters',
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Filters'));
    expect(trailing, 2);
  });

  testWidgets('checkbox and radio retain 24px marks with 44px targets',
      (tester) async {
    for (final widget in <Widget>[
      AppCheckbox(value: false, onChanged: (_) {}),
      AppRadio(value: 1, groupValue: 0, onChanged: (_) {}),
    ]) {
      await tester.pumpWidget(wrapKit(widget));
      expect(tester.getSize(find.byType(AppPressState)), const Size.square(44));
      final mark = find.byType(AnimatedContainer).first;
      expect(tester.getSize(mark), const Size.square(24));
    }
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCheckbox(
                value: true,
                label: 'Очень длинное название',
                onChanged: (_) {},
              ),
              AppRadio(
                value: 1,
                groupValue: 1,
                label: 'Очень длинное название',
                onChanged: (_) {},
              ),
              AppSwitch(
                value: true,
                label: 'Очень длинное название',
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        textScale: 2,
        accessibleNavigation: true,
      ),
    );
    expect(tester.takeException(), isNull);
    for (final container in tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))) {
      expect(container.duration, Duration.zero);
    }
  });

  testWidgets('removable chip exposes distinct selection and removal',
      (tester) async {
    var selected = 0;
    var removed = 0;
    await tester.pumpWidget(
      wrapKit(
        AppChip(
          label: 'Выбран',
          onTap: () => selected++,
          onRemove: () => removed++,
          removeSemanticLabel: 'Удалить выбранный',
        ),
      ),
    );
    final removal = find.bySemanticsLabel('Удалить выбранный');
    expect(
      tester
          .getSemantics(removal)
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isTrue,
    );
    await tester.tap(removal);
    expect(removed, 1);
    expect(selected, 0);
    await tester.tap(find.text('Выбран'));
    expect(selected, 1);
    expect(tester.getSize(pressesIn(AppChip).last), const Size.square(44));
  });

  testWidgets('stepper retains 120x48 geometry and guards bounds',
      (tester) async {
    int? value;
    await tester.pumpWidget(
      wrapKit(
        AppStepper(value: 0, max: 1, onChanged: (next) => value = next),
      ),
    );
    expect(tester.getSize(find.byType(AppStepper)), const Size(120, 48));
    final presses = pressesIn(AppStepper);
    expect(tester.getSize(presses.first), const Size.square(44));
    expect(tester.getSize(presses.last), const Size.square(44));
    await tester.tap(presses.first);
    expect(value, isNull);
    await tester.tap(presses.last);
    expect(value, 1);
  });

  testWidgets('code keypad adapts touch targets and disables every key',
      (tester) async {
    var keys = 0;
    for (final width in [320.0, 600.0]) {
      await tester.pumpWidget(
        wrapKit(
          SizedBox(
            width: width,
            child: AppCodeKeypad(onKey: (_) => keys++, onBackspace: () {}),
          ),
        ),
      );
      final targets = pressesIn(AppCodeKeypad);
      expect(targets, findsNWidgets(11));
      for (final element in targets.evaluate()) {
        final size = tester.getSize(find.byWidget(element.widget));
        expect(size.width, greaterThanOrEqualTo(44));
        expect(size.height, 44);
      }
      expect(
        tester.getTopLeft(targets.at(3)).dy,
        width == 320
            ? greaterThan(tester.getTopLeft(targets.first).dy)
            : tester.getTopLeft(targets.first).dy,
      );
    }
    await tester.pumpWidget(
      wrapKit(
        AppCodeInput(
          showKeypad: true,
          enabled: false,
          onChanged: (_) => keys++,
        ),
      ),
    );
    await tester.tap(find.text('1'));
    expect(keys, 0);
    expect(
      tester
          .widgetList<SixDigitCodeCell>(find.byType(SixDigitCodeCell))
          .any((cell) => cell.active),
      isFalse,
    );
  });

  testWidgets('code input rebinds external state and detaches old listeners',
      (tester) async {
    final first = TextEditingController(text: '12');
    final second = TextEditingController(text: '45');
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();
    addTearDown(() {
      first.dispose();
      second.dispose();
      firstFocus.dispose();
      secondFocus.dispose();
    });
    Widget view(TextEditingController controller, FocusNode focus) => wrapKit(
          AppCodeInput(controller: controller, focusNode: focus),
        );
    await tester.pumpWidget(view(first, firstFocus));
    await tester.pumpWidget(view(second, secondFocus));
    expect(tester.widget<TextField>(find.byType(TextField)).controller, second);
    secondFocus.requestFocus();
    await tester.pump();
    expect(secondFocus.hasFocus, isTrue);
    first.text = '99';
    await tester.pump();
    final cells =
        tester.widgetList<SixDigitCodeCell>(find.byType(SixDigitCodeCell));
    expect(cells.take(2).map((cell) => cell.digit), ['4', '5']);
    await tester.pumpWidget(const SizedBox());
    expect(() => second.text = '67', returnsNormally);
  });

  testWidgets('segments retain 46px track and 38px pills with 44px targets',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        SizedBox(
          width: 320,
          child: AppSegmentedControl(
            value: 0,
            onChanged: (_) {},
            options: const [
              AppSegmentedOption(value: 0, label: 'День'),
              AppSegmentedOption(value: 1, label: 'Неделя'),
            ],
          ),
        ),
      ),
    );
    final track = tester.getRect(find.byType(AppSegmentedControl<int>));
    expect(track.height, 46);
    final presses = pressesIn(AppSegmentedControl<int>);
    expect(tester.getSize(presses.first).height, 44);
    final pill = tester.getRect(find.byType(AnimatedContainer).first);
    expect(pill.height, 38);
    expect(pill.top - track.top, 4);
  });

  testWidgets('tabs expose count, minimum targets and keyboard selection',
      (tester) async {
    int? selected;
    await tester.pumpWidget(
      wrapKit(
        AppTabs(
          value: 0,
          onChanged: (value) => selected = value,
          tabs: const [
            AppTab(value: 0, label: 'Я'),
            AppTab(value: 1, label: 'Все', count: 6),
          ],
        ),
      ),
    );
    for (final element in find.byType(AppPressState).evaluate()) {
      final size = tester.getSize(find.byWidget(element.widget));
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    }
    expect(find.text('6'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selected, 1);
  });
}
