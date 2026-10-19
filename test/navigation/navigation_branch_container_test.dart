import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/navigation/view/navigation_branch_container.dart';

void main() {
  testWidgets('inactive branches never paint or expose semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final paints = [0, 0];

      Widget build(int index) => MaterialApp(
        home: NavigationBranchContainer(
          currentIndex: index,
          children: [
            for (var branch = 0; branch < 2; branch++)
              CustomPaint(
                painter: _PaintRecorder(() => paints[branch]++),
                child: Semantics(
                  label: 'Branch $branch',
                  child: const SizedBox.expand(),
                ),
              ),
          ],
        ),
      );

      await tester.pumpWidget(build(0));
      expect(paints[0], greaterThan(0));
      expect(paints[1], 0);
      expect(find.bySemanticsLabel('Branch 0'), findsOneWidget);
      expect(find.bySemanticsLabel('Branch 1'), findsNothing);
      final firstPaints = paints[0];

      await tester.pumpWidget(build(1));
      await tester.pump(const Duration(milliseconds: 110));
      expect(paints[0], firstPaints);
      expect(paints[1], greaterThan(0));
      expect(find.bySemanticsLabel('Branch 0'), findsNothing);
      expect(find.bySemanticsLabel('Branch 1'), findsOneWidget);
      for (final type in [
        AnimatedOpacity,
        Opacity,
        FadeTransition,
        ColorFiltered,
      ]) {
        expect(
          find.descendant(
            of: find.byType(NavigationBranchContainer),
            matching: find.byType(type),
          ),
          findsNothing,
        );
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'switching tabs preserves state and scroll with stable child keys',
    (tester) async {
      Widget build(int index) => MaterialApp(
        home: NavigationBranchContainer(
          currentIndex: index,
          children: const [_ScrollBranch('Feed'), _ScrollBranch('Schedule')],
        ),
      );

      await tester.pumpWidget(build(0));
      final firstState = tester.state<_ScrollBranchState>(
        find.byType(_ScrollBranch).first,
      );
      await tester.tap(find.text('Feed 0'));
      firstState.controller.jumpTo(240);
      await tester.pump();
      expect(firstState.count, 1);
      expect(firstState.controller.offset, 240);

      await tester.pumpWidget(build(1));
      await tester.pumpAndSettle();
      expect(find.text('Feed 1'), findsNothing);
      expect(find.text('Schedule 0'), findsOneWidget);
      final hidden = tester.widgetList<TickerMode>(
        find.descendant(
          of: find.byType(NavigationBranchContainer),
          matching: find.byType(TickerMode, skipOffstage: false),
          skipOffstage: false,
        ),
      );
      expect(hidden.map((mode) => mode.enabled), [false, true]);

      await tester.pumpWidget(build(0));
      await tester.pumpAndSettle();
      expect(
        tester.state<_ScrollBranchState>(find.byType(_ScrollBranch).first),
        same(firstState),
      );
      expect(firstState.count, 1);
      expect(firstState.controller.offset, 240);
      expect(tester.takeException(), isNull);
    },
  );
}

class _PaintRecorder extends CustomPainter {
  const _PaintRecorder(this.onPaint);

  final VoidCallback onPaint;

  @override
  void paint(Canvas canvas, Size size) => onPaint();

  @override
  bool shouldRepaint(_PaintRecorder oldDelegate) => true;
}

class _ScrollBranch extends StatefulWidget {
  const _ScrollBranch(this.label);

  final String label;

  @override
  State<_ScrollBranch> createState() => _ScrollBranchState();
}

class _ScrollBranchState extends State<_ScrollBranch> {
  final controller = ScrollController();
  int count = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: ListView(
      controller: controller,
      children: [
        TextButton(
          onPressed: () => setState(() => count++),
          child: Text('${widget.label} $count'),
        ),
        const SizedBox(height: 2000),
      ],
    ),
  );
}
