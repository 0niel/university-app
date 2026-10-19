import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({
    required WidgetBuilder content,
    ValueChanged<int?>? onResult,
    FocusNode? anchorFocus,
    double textScale = 1,
    bool reducedMotion = false,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets viewInsets = EdgeInsets.zero,
    Alignment alignment = Alignment.topRight,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: reducedMotion,
          viewPadding: padding,
          viewInsets: viewInsets,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(48),
          child: Align(
            alignment: alignment,
            child: Builder(
              builder: (anchorContext) => TextButton(
                focusNode: anchorFocus,
                onPressed: () async {
                  final result = await showAppPopover<int>(
                    anchorContext,
                    anchorContext: anchorContext,
                    semanticLabel: 'Choose an option',
                    builder: content,
                  );
                  onResult?.call(result);
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget choices(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppListRow(
        title: 'First',
        onTap: () => Navigator.of(context).pop(1),
      ),
      AppListRow(
        title: 'Second',
        onTap: () => Navigator.of(context).pop(2),
      ),
    ],
  );

  testWidgets('anchors a glass menu and returns the selection without fade', (
    tester,
  ) async {
    int? result;
    await tester.pumpWidget(
      host(content: choices, onResult: (v) => result = v),
    );
    final anchor = tester.getRect(find.byType(TextButton));
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final popover = find.byType(AppPopover);
    final scale = tester.widget<ScaleTransition>(
      find.ancestor(of: popover, matching: find.byType(ScaleTransition)).first,
    );
    expect(scale.scale.value, inExclusiveRange(.97, 1));
    final fades = tester.widgetList<FadeTransition>(
      find.ancestor(of: popover, matching: find.byType(FadeTransition)),
    );
    expect(fades.every((fade) => fade.opacity.value == 1), isTrue);
    await tester.pumpAndSettle();
    final panel = tester.getRect(popover);
    expect(panel.right, closeTo(anchor.right, .01));
    expect(panel.top, closeTo(anchor.bottom + AppSpacing.sm, .01));
    expect(panel.width, lessThanOrEqualTo(360));
    expect(find.byType(AppGlassSurface), findsOneWidget);
    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();
    expect(result, 2);
    expect(popover, findsNothing);
  });

  testWidgets('outside, system back and escape dismiss and restore focus', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final results = <int?>[];
    await tester.pumpWidget(
      host(content: choices, anchorFocus: focus, onResult: results.add),
    );
    focus.requestFocus();
    await tester.pump();
    for (final dismiss in ['outside', 'back', 'escape']) {
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(AppPopover), findsOneWidget);
      switch (dismiss) {
        case 'outside':
          await tester.tapAt(const Offset(10, 10));
        case 'back':
          await tester.binding.handlePopRoute();
        case 'escape':
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      }
      await tester.pumpAndSettle();
      expect(find.byType(AppPopover), findsNothing);
      expect(focus.hasFocus, isTrue);
    }
    expect(results, [null, null, null]);
  });

  testWidgets('keyboard traversal remains inside the menu', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(host(content: choices, anchorFocus: focus));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 6; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focus.hasFocus, isFalse);
      final focused = FocusManager.instance.primaryFocus!.context!;
      expect(focused.findAncestorWidgetOfExactType<AppPopover>(), isNotNull);
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
  });

  for (final size in [const Size(320, 568), const Size(700, 320)]) {
    testWidgets('long content scrolls within safe bounds at $size and 200%', (
      tester,
    ) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        host(
          textScale: 2,
          reducedMotion: true,
          padding: const EdgeInsets.fromLTRB(16, 24, 20, 20),
          viewInsets: const EdgeInsets.only(bottom: 80),
          alignment: Alignment.bottomRight,
          content: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < 20; index++)
                AppListRow(
                  title: 'Long option number $index',
                  titleMaxLines: null,
                  onTap: () => Navigator.of(context).pop(index),
                ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      final route = ModalRoute.of(tester.element(find.byType(AppPopover)))!;
      expect(route.transitionDuration, Duration.zero);
      final bounds = tester.getRect(find.byType(AppPopover));
      expect(bounds.left, greaterThanOrEqualTo(28));
      expect(bounds.right, lessThanOrEqualTo(size.width - 32));
      expect(bounds.top, greaterThanOrEqualTo(36));
      expect(bounds.bottom, lessThanOrEqualTo(size.height - 92));
      await tester.scrollUntilVisible(
        find.text('Long option number 19'),
        200,
        scrollable: find.descendant(
          of: find.byType(AppPopover),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(find.text('Long option number 19'));
      await tester.pump();
      expect(find.byType(AppPopover), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
