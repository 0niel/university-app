import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/login/widgets/auth_content_reveal.dart';

void main() {
  testWidgets('local auth scale preserves glass backdrop, input and focus', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    var identity = 0;
    late StateSetter rebuild;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return AuthContentReveal(
                identity: identity,
                child: AppGlassSurface(
                  key: const Key('glass'),
                  child: TextField(controller: controller, focusNode: focus),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'student@example.com');
    final input = tester.state(find.byType(EditableText));
    rebuild(() => identity++);
    await tester.pump();
    final transition = find.byType(AuthContentReveal);
    final scale = tester.widget<ScaleTransition>(
      find.descendant(of: transition, matching: find.byType(ScaleTransition)),
    );
    expect(scale.scale.value, .985);
    final isolatingAncestors = find.ancestor(
      of: find.byKey(const Key('glass')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Opacity ||
            widget is FadeTransition ||
            widget is AnimatedOpacity ||
            widget is ShaderMask ||
            widget is ColorFiltered,
      ),
    );
    expect(
      find.descendant(of: transition, matching: isolatingAncestors),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(scale.scale.value, greaterThan(.985));
    expect(scale.scale.value, lessThan(1));
    expect(tester.state(find.byType(EditableText)), same(input));
    expect(controller.text, 'student@example.com');
    expect(focus.hasFocus, isTrue);
    await tester.pumpAndSettle();
    expect(scale.scale.value, 1);
    expect(tester.takeException(), isNull);
  });

  for (final accessibleNavigation in [false, true]) {
    testWidgets('auth reduced motion is immediate, nav:$accessibleNavigation', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: !accessibleNavigation,
              accessibleNavigation: accessibleNavigation,
            ),
            child: child!,
          ),
          home: const AuthContentReveal(
            child: AppGlassSurface(child: SizedBox(width: 160, height: 100)),
          ),
        ),
      );
      final scale = tester.widget<ScaleTransition>(
        find.descendant(
          of: find.byType(AuthContentReveal),
          matching: find.byType(ScaleTransition),
        ),
      );
      expect(scale.scale.value, 1);
      expect(tester.takeException(), isNull);
    });
  }
}
