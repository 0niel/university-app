import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_section_reveal.dart';

void main() {
  testWidgets('home transform preserves glass backdrop and focused child', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    var reduced = false;
    late StateSetter rebuild;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(disableAnimations: reduced),
                child: HomeSectionReveal(
                  order: 2,
                  child: AppGlassSurface(
                    key: const Key('glass'),
                    child: TextField(controller: controller, focusNode: focus),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    final reveal = find.byType(HomeSectionReveal);
    Transform transform() => tester.widget<Transform>(
      find.descendant(of: reveal, matching: find.byType(Transform)).first,
    );
    expect(transform().transform.storage[13], 18);
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
      find.descendant(of: reveal, matching: isolatingAncestors),
      findsNothing,
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(transform().transform.storage[13], greaterThan(0));
    expect(transform().transform.storage[13], lessThan(18));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Draft');
    final input = tester.state(find.byType(EditableText));
    rebuild(() => reduced = true);
    await tester.pump();
    expect(transform().transform.storage[13], 0);
    expect(tester.state(find.byType(EditableText)), same(input));
    expect(focus.hasFocus, isTrue);
    expect(controller.text, 'Draft');
    rebuild(() => reduced = false);
    await tester.pump();
    expect(tester.state(find.byType(EditableText)), same(input));
    expect(focus.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });
}
