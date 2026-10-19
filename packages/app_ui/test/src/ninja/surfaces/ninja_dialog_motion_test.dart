import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../kit_harness.dart';

void main() {
  testWidgets('dialog scales with no fade and retains its pop result', (
    tester,
  ) async {
    String? result;
    late BuildContext dialogContext;
    await tester.pumpWidget(
      wrapKit(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showNinjaDialog<String>(
                context,
                builder: (context) {
                  dialogContext = context;
                  return const NinjaDialog(
                    key: Key('dialog'),
                    title: 'Save changes?',
                  );
                },
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final dialog = find.byKey(const Key('dialog'));
    expect(
      find.ancestor(of: dialog, matching: find.byType(FadeTransition)),
      findsNothing,
    );
    expect(
      find.ancestor(of: dialog, matching: find.byType(Opacity)),
      findsNothing,
    );
    final transition = tester.widget<ScaleTransition>(
      find.ancestor(of: dialog, matching: find.byType(ScaleTransition)).first,
    );
    expect(transition.scale.value, greaterThan(.96));
    expect(transition.scale.value, lessThan(1));
    expect(ModalRoute.of(dialogContext), isA<DialogRoute<String>>());
    expect(
      ModalRoute.of(dialogContext)!.traversalEdgeBehavior,
      TraversalEdgeBehavior.closedLoop,
    );
    await tester.pumpAndSettle();
    Navigator.of(dialogContext).pop('Saved');
    await tester.pumpAndSettle();
    expect(result, 'Saved');
    expect(find.byType(NinjaDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final dismissible in [false, true]) {
    testWidgets('barrier dismissal=$dismissible retains label and back', (
      tester,
    ) async {
      var completed = false;
      await tester.pumpWidget(
        wrapKit(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                await showNinjaDialog<void>(
                  context,
                  barrierDismissible: dismissible,
                  builder: (_) => const NinjaDialog(title: 'Dialog'),
                );
                completed = true;
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(barrier.dismissible, dismissible);
      expect(barrier.semanticsLabel, 'Dismiss');
      expect(barrier.color, kitColors.scrim);
      await tester.tapAt(const Offset(4, 4));
      await tester.pumpAndSettle();
      expect(completed, dismissible);
      if (!dismissible) {
        expect(find.text('Dialog'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(completed, isTrue);
      }
      expect(find.text('Dialog'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final root in [false, true]) {
    testWidgets('rootNavigator=$root preserves caller theme and media', (
      tester,
    ) async {
      final rootNavigator = GlobalKey<NavigatorState>();
      final nestedNavigator = GlobalKey<NavigatorState>();
      String? result;
      late BuildContext dialogContext;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: rootNavigator,
          theme: AppTheme.lightTheme,
          home: Theme(
            data: AppTheme.darkTheme,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Navigator(
                key: nestedNavigator,
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (context) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.7),
                    ),
                    child: Builder(
                      builder: (context) => Scaffold(
                        body: TextButton(
                          onPressed: () async {
                            result = await showNinjaDialog<String>(
                              context,
                              useRootNavigator: root,
                              builder: (context) {
                                dialogContext = context;
                                return const NinjaDialog(title: 'Dialog');
                              },
                            );
                          },
                          child: const Text('Open'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(rootNavigator.currentState!.canPop(), root);
      expect(nestedNavigator.currentState!.canPop(), !root);
      expect(dialogContext.colors.ink, AppColors.dark.ink);
      expect(Directionality.of(dialogContext), TextDirection.rtl);
      expect(MediaQuery.textScalerOf(dialogContext).scale(10), 17);
      Navigator.of(dialogContext).pop('Saved');
      await tester.pumpAndSettle();
      expect(result, 'Saved');
      expect(rootNavigator.currentState!.canPop(), isFalse);
      expect(nestedNavigator.currentState!.canPop(), isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  for (final accessible in [false, true]) {
    testWidgets('reduced motion is instant, accessible=$accessible', (
      tester,
    ) async {
      late BuildContext dialogContext;
      await tester.pumpWidget(
        wrapKit(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                accessibleNavigation: accessible,
                disableAnimations: !accessible,
              ),
              child: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showNinjaDialog<void>(
                    context,
                    builder: (context) {
                      dialogContext = context;
                      return const NinjaDialog(title: 'Dialog');
                    },
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      final route = ModalRoute.of(dialogContext)!;
      expect(route.transitionDuration, Duration.zero);
      expect(
        find.ancestor(
          of: find.byType(NinjaDialog),
          matching: find.byType(ScaleTransition),
        ),
        findsNothing,
      );
      expect(route.animation!.value, 1);
      Navigator.of(dialogContext).pop();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('dialog focus stays inside its closed loop', (tester) async {
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      wrapKit(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showNinjaDialog<void>(
              context,
              builder: (_) => NinjaDialog(
                title: 'Dialog',
                child: Column(
                  children: [
                    TextField(focusNode: first, autofocus: true),
                    TextField(focusNode: second),
                  ],
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(first.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(first.hasFocus, isTrue);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(NinjaDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('open dialog follows keyboard insets and viewport changes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late BuildContext dialogContext;
    await tester.pumpWidget(
      wrapKit(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showNinjaDialog<void>(
              context,
              builder: (context) {
                dialogContext = context;
                return const NinjaDialog(title: 'Dialog');
              },
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(MediaQuery.viewInsetsOf(dialogContext), EdgeInsets.zero);
    tester.view.viewInsets = const FakeViewPadding(bottom: 240);
    await tester.pumpAndSettle();
    expect(MediaQuery.viewInsetsOf(dialogContext).bottom, 240);
    tester.view.physicalSize = const Size(600, 800);
    await tester.pumpAndSettle();
    expect(MediaQuery.sizeOf(dialogContext), const Size(600, 800));
    expect(tester.takeException(), isNull);
  });
}
