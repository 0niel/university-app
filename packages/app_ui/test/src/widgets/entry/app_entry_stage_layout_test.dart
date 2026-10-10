import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/widgets/entry/app_entry_body_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('content transitions and scrolling keep header and footer fixed',
      (
    tester,
  ) async {
    var story = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: AppEntryLayout(
              presentation: AppEntryPresentation.staged,
              contentIdentity: story,
              title: 'Story $story',
              header: const Text('Campus Hub', key: Key('header')),
              actions: AppButton.primary(
                key: const Key('continue'),
                label: 'Continue',
                expanded: true,
                onPressed: () => setState(() => story++),
              ),
              child: const SizedBox(height: 900),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final header = tester.getRect(find.byKey(const Key('header')));
    final footer = tester.getRect(find.byKey(const Key('continue')));

    await tester.tap(find.byKey(const Key('continue')));
    await tester.pump();
    final transition = find.byType(AppEntryBodyTransition);
    final fade = tester.widget<FadeTransition>(
      find.descendant(of: transition, matching: find.byType(FadeTransition)),
    );
    final slide = tester.widget<SlideTransition>(
      find.descendant(of: transition, matching: find.byType(SlideTransition)),
    );
    expect(fade.opacity.value, 0);
    expect(slide.position.value.dx, 0);
    expect(slide.position.value.dy, greaterThan(0));
    expect(find.text('Story 0'), findsNothing);
    expect(tester.getRect(find.byKey(const Key('header'))), header);
    expect(tester.getRect(find.byKey(const Key('continue'))), footer);

    await tester.pump(const Duration(milliseconds: 100));
    expect(fade.opacity.value, greaterThan(0));
    expect(fade.opacity.value, lessThan(1));
    expect(tester.getRect(find.byKey(const Key('header'))), header);
    expect(tester.getRect(find.byKey(const Key('continue'))), footer);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(const Key('header'))), header);
    expect(tester.getRect(find.byKey(const Key('continue'))), footer);
    expect(tester.takeException(), isNull);
  });

  for (final accessibleNavigation in [false, true]) {
    testWidgets(
        'reduced motion applies immediately, navigation=$accessibleNavigation',
        (
      tester,
    ) async {
      var story = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: !accessibleNavigation,
              accessibleNavigation: accessibleNavigation,
            ),
            child: child!,
          ),
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: AppEntryLayout(
                presentation: AppEntryPresentation.staged,
                contentIdentity: story,
                title: 'Story $story',
                actions: AppButton.primary(
                  key: const Key('continue'),
                  label: 'Continue',
                  onPressed: () => setState(() => story++),
                ),
                child: const Text('Content'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('continue')));
      await tester.pump();
      final transition = find.byType(AppEntryBodyTransition);
      final fade = tester.widget<FadeTransition>(
        find.descendant(of: transition, matching: find.byType(FadeTransition)),
      );
      final slide = tester.widget<SlideTransition>(
        find.descendant(of: transition, matching: find.byType(SlideTransition)),
      );
      expect(fade.opacity.value, 1);
      expect(slide.position.value, Offset.zero);
      expect(find.text('Story 1'), findsOneWidget);
    });
  }

  testWidgets('staged actions stay usable at 320px, 200% text and keyboard', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 568)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var continued = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2),
            viewInsets: const EdgeInsets.only(bottom: 240),
            disableAnimations: true,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: AppEntryLayout(
            presentation: AppEntryPresentation.staged,
            title: 'Choose your profile',
            header: const AppBackButton(),
            actions: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton.primary(label: 'First action', onPressed: () {}),
                const SizedBox(height: 12),
                AppButton.secondary(
                  key: const Key('continue'),
                  label: 'Continue',
                  onPressed: () => continued = true,
                ),
              ],
            ),
            child: const AppInputField(label: 'Name'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('continue')),
      100,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.byKey(const Key('continue')));
    expect(continued, isTrue);
    expect(tester.takeException(), isNull);
  });
}
