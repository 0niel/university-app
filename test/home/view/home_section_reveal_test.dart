import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_section_reveal.dart';

void main() {
  testWidgets(
    'home reveal reuses static paint and invalidates content updates',
    (
      tester,
    ) async {
      var paints = 0;
      var revision = 0;
      late StateSetter rebuild;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return ListView(
                  children: [
                    HomeSectionReveal(
                      child: CustomPaint(
                        painter: _PaintProbe(
                          revision: revision,
                          onPaint: () => paints++,
                        ),
                        child: const SizedBox(height: 200),
                      ),
                    ),
                    const SizedBox(height: 1000),
                  ],
                );
              },
            ),
          ),
        ),
      );
      expect(paints, 1);
      for (var frame = 0; frame < 8; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(HomeSectionReveal),
          matching: find.byType(Transform),
        ),
      );
      expect(transform.transform.storage[13], greaterThan(0));
      expect(transform.transform.storage[13], lessThan(18));
      expect(paints, 1);
      rebuild(() => revision++);
      await tester.pump(const Duration(milliseconds: 16));
      expect(paints, 2);
      for (var frame = 0; frame < 8; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(paints, 2);
      expect(tester.takeException(), isNull);
    },
  );

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

class _PaintProbe extends CustomPainter {
  _PaintProbe({required this.revision, required this.onPaint});

  final int revision;
  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) {
    onPaint();
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = revision.isEven ? Colors.red : Colors.blue,
    );
  }

  @override
  bool shouldRepaint(_PaintProbe oldDelegate) =>
      revision != oldDelegate.revision;
}
