import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  testWidgets('focus and control semantics share one node across disable',
      (tester) async {
    var taps = 0;
    Widget view({required bool enabled}) => wrapKit(
          AppPressState(
            enabled: enabled,
            onTap: () => taps++,
            semanticsLabel: 'Control',
            semanticsButton: false,
            semanticsChecked: true,
            semanticsExclusive: true,
            builder: (context, {required pressed}) =>
                const SizedBox.square(dimension: 48, child: Text('Control')),
          ),
        );
    await tester.pumpWidget(view(enabled: true));
    var data =
        tester.getSemantics(find.byType(AppPressState)).getSemanticsData();
    expect(data.flagsCollection.isChecked, ui.CheckedState.isTrue);
    expect(data.flagsCollection.isEnabled, ui.Tristate.isTrue);
    expect(data.flagsCollection.isFocused, ui.Tristate.isFalse);
    expect(find.bySemanticsLabel('Control'), findsOneWidget);
    tester.semantics.performAction(
      find.semantics.byLabel('Control'),
      ui.SemanticsAction.focus,
    );
    await tester.pump();
    data = tester.getSemantics(find.byType(AppPressState)).getSemanticsData();
    expect(data.flagsCollection.isFocused, ui.Tristate.isTrue);
    expect(data.flagsCollection.isChecked, ui.CheckedState.isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
    await tester.pumpWidget(view(enabled: false));
    await tester.pump();
    data = tester.getSemantics(find.byType(AppPressState)).getSemanticsData();
    expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
    expect(data.flagsCollection.isFocused, ui.Tristate.none);
    expect(data.flagsCollection.isChecked, ui.CheckedState.isTrue);
    expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
    expect(data.hasAction(ui.SemanticsAction.focus), isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 1);
  });

  testWidgets('header and toast actions are reachable by keyboard',
      (tester) async {
    var backs = 0;
    var actions = 0;
    var retries = 0;
    await tester.pumpWidget(
      wrapKit(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppInnerHeader(
              title: 'Заголовок',
              applyTopInset: false,
              onBack: () => backs++,
              actions: [
                AppHeaderAction(
                  icon: AppLineIcon.plus,
                  onTap: () => actions++,
                ),
              ],
            ),
            AppToast(
              message: 'Не удалось загрузить',
              actionLabel: 'Повторить',
              onAction: () => retries++,
            ),
          ],
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(backs, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(actions, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(retries, 1);
  });

  testWidgets('nested pressables dispatch one callback to the tapped target',
      (tester) async {
    var outer = 0;
    var inner = 0;
    await tester.pumpWidget(
      wrapKit(
        AppPressable(
          onTap: () => outer++,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 100, height: 48, child: Text('Outer')),
              AppPressable(
                onTap: () => inner++,
                child: const SizedBox(
                  width: 100,
                  height: 48,
                  child: Text('Inner'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Inner'));
    expect(inner, 1);
    expect(outer, 0);
    await tester.tap(find.text('Outer'));
    expect(outer, 1);
    expect(inner, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(inner, 2);
    expect(outer, 1);
  });

  testWidgets('long press remains separate from taps and haptic feedback',
      (tester) async {
    var taps = 0;
    var holds = 0;
    var haptics = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'HapticFeedback.vibrate') haptics++;
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    await tester.pumpWidget(
      wrapKit(
        AppPressable(
          onTap: () => taps++,
          onLongPress: () => holds++,
          haptics: true,
          child: const SizedBox.square(dimension: 48),
        ),
      ),
    );
    await tester.longPress(find.byType(AppPressable));
    expect(holds, 1);
    expect(taps, 0);
    await tester.tap(find.byType(AppPressable));
    await tester.pump();
    expect(taps, 1);
    expect(holds, 1);
    expect(haptics, 1);
  });

  testWidgets('reduced motion keeps opacity immediate and removes scale',
      (tester) async {
    await tester.pumpWidget(
      wrapKit(
        AppPressable(
          onTap: () {},
          child: const SizedBox.square(dimension: 48),
        ),
        accessibleNavigation: true,
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(AppPressable)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    final opacity =
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacity.opacity, .85);
    expect(opacity.duration, Duration.zero);
    expect(find.byType(AnimatedScale), findsNothing);
    await gesture.cancel();
  });

  testWidgets('disabling during a press cancels activation and pressed state',
      (tester) async {
    var taps = 0;
    Widget view({required bool enabled}) => wrapKit(
          AppPressable(
            enabled: enabled,
            onTap: () => taps++,
            child: const SizedBox.square(dimension: 48),
          ),
        );
    await tester.pumpWidget(view(enabled: true));
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(AppPressable)),
    );
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pumpWidget(view(enabled: false));
    await gesture.up();
    expect(taps, 0);
    await tester.pumpWidget(view(enabled: true));
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );
    await tester.tap(find.byType(AppPressable));
    expect(taps, 1);
  });
}
