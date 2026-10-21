import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(body: Center(child: child)),
  );

  group('AppTooltip', () {
    testWidgets('preserves the child state when tooltip visibility changes', (
      tester,
    ) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      await tester.pumpWidget(
        wrap(
          ValueListenableBuilder(
            valueListenable: visible,
            builder: (context, value, child) => TooltipVisibility(
              visible: value,
              child: child!,
            ),
            child: const AppTooltipAnchor(
              message: 'Draft hint',
              child: _DraftTarget(),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Count 0'));
      await tester.enterText(find.byType(TextField), 'Unsaved draft');
      await tester.pumpAndSettle();
      final target = tester.state<_DraftTargetState>(find.byType(_DraftTarget));
      final field = tester.element(find.byType(TextField));

      for (final enabled in [false, true, false, true]) {
        visible.value = enabled;
        await tester.pumpAndSettle();

        expect(
          tester.state<_DraftTargetState>(find.byType(_DraftTarget)),
          same(target),
        );
        expect(tester.element(find.byType(TextField)), same(field));
        expect(find.text('Count 1'), findsOneWidget);
        expect(find.text('Unsaved draft'), findsOneWidget);
        expect(target.focus.hasFocus, isTrue);
        expect(
          find.byType(RawTooltip),
          enabled ? findsOneWidget : findsNothing,
        );
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('restores tooltip triggers without keeping hidden routes', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const SizedBox()));
      final router = tester.binding.pointerRouter;
      final baseline = router.debugGlobalRouteCount;
      final visible = ValueNotifier(true);
      final focus = FocusNode();
      addTearDown(visible.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        wrap(
          ValueListenableBuilder(
            valueListenable: visible,
            builder: (context, value, child) => TooltipVisibility(
              visible: value,
              child: child!,
            ),
            child: AppTooltipAnchor(
              message: 'Target hint',
              child: Focus(
                focusNode: focus,
                child: const SizedBox(
                  width: 100,
                  height: 44,
                  child: Text('Target'),
                ),
              ),
            ),
          ),
        ),
      );
      expect(router.debugGlobalRouteCount, baseline + 1);
      visible.value = false;
      await tester.pumpAndSettle();
      expect(router.debugGlobalRouteCount, baseline);
      await tester.longPress(find.text('Target'));
      await tester.pumpAndSettle();
      expect(find.byType(AppTooltip), findsNothing);

      visible.value = true;
      await tester.pumpAndSettle();
      expect(router.debugGlobalRouteCount, baseline + 1);
      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(find.text('Target hint'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AppTooltip), findsNothing);
      focus.unfocus();
      await tester.pumpAndSettle();

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('Target')));
      await tester.pumpAndSettle();
      expect(find.text('Target hint'), findsOneWidget);
      await mouse.moveTo(Offset.zero);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      expect(find.byType(AppTooltip), findsNothing);
      await mouse.removePointer();

      await tester.longPress(find.text('Target'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Target hint'), findsOneWidget);
      visible.value = false;
      await tester.pumpAndSettle();
      expect(find.byType(AppTooltip), findsNothing);
      expect(router.debugGlobalRouteCount, baseline);
      await tester.pump(const Duration(seconds: 2));
      expect(router.debugGlobalRouteCount, baseline);
      expect(tester.takeException(), isNull);
    });

    for (final width in [360.0, 430.0]) {
      testWidgets(
        'keeps tooltip direction in canvas units at $width',
        (tester) async {
          tester.view
            ..physicalSize = Size(width, 900) * 3
            ..devicePixelRatio = 3;
          addTearDown(tester.view.reset);
          const message = 'Подсказка';
          final painter = TextPainter(
            text: TextSpan(text: message, style: AppText.subtextStrong),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: 300);
          final threshold = painter.height + AppSpacing.sm * 3 + 7;
          painter.dispose();
          final below = width > AppScale.designWidth;
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.darkTheme,
              builder: (_, child) => AppScale(child: child!),
              home: Scaffold(
                body: Stack(
                  children: [
                    Positioned(
                      top: threshold + (below ? -1 : 1),
                      left: 100,
                      child: const AppTooltipAnchor(
                        message: message,
                        child: SizedBox(
                          width: 100,
                          height: 44,
                          child: Text('Target'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.longPress(find.text('Target'));
          await tester.pump(const Duration(milliseconds: 200));
          final tooltip = tester.widget<AppTooltip>(find.byType(AppTooltip));
          expect(
            tooltip.arrow,
            below ? AppTooltipArrow.up : AppTooltipArrow.down,
          );
          expect(tester.takeException(), isNull);
        },
        variant: TargetPlatformVariant.only(TargetPlatform.android),
      );
    }

    testWidgets('renders the label with a rotated tail', (tester) async {
      await tester.pumpWidget(wrap(const AppTooltip(label: 'Свайпни')));

      expect(find.text('Свайпни'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppTooltip),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
    });

    testWidgets('the up arrow variant builds', (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppTooltip(label: 'Сверху', arrow: AppTooltipArrow.up),
        ),
      );

      expect(find.text('Сверху'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

class _DraftTarget extends StatefulWidget {
  const _DraftTarget();

  @override
  State<_DraftTarget> createState() => _DraftTargetState();
}

class _DraftTargetState extends State<_DraftTarget> {
  final controller = TextEditingController();
  final focus = FocusNode();
  int count = 0;

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(controller: controller, focusNode: focus),
      TextButton(
        onPressed: () => setState(() => count++),
        child: Text('Count $count'),
      ),
    ],
  );
}
