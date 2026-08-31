import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

class _PaintCounter extends SingleChildRenderObjectWidget {
  const _PaintCounter({required this.onPaint, super.child});

  final VoidCallback onPaint;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderPaintCounter(onPaint);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPaintCounter renderObject,
  ) {
    renderObject.onPaint = onPaint;
  }
}

class _RenderPaintCounter extends RenderProxyBox {
  _RenderPaintCounter(this.onPaint);

  VoidCallback onPaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}

void main() {
  Finder sceneBoundaries() => find.descendant(
        of: find.byType(NinjaSkeletonGroup).first,
        matching: find.byType(RepaintBoundary),
      );

  Widget wrap(
    Widget child, {
    bool reduceMotion = false,
    bool accessibleNavigation = false,
  }) =>
      MaterialApp(
        theme: NinjaTheme.light(),
        home: MediaQuery(
          data: MediaQueryData(
            disableAnimations: reduceMotion,
            accessibleNavigation: accessibleNavigation,
          ),
          child: Scaffold(body: SizedBox(width: 300, child: child)),
        ),
      );

  Widget wrapLoose(Widget child) => MaterialApp(
        theme: NinjaTheme.light(),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('avatar block is a soft 44 circle', (tester) async {
    await tester.pumpWidget(
      wrapLoose(const NinjaSkeleton.avatar(shimmer: false)),
    );

    expect(tester.getSize(find.byType(NinjaSkeleton)), const Size(44, 44));
  });

  testWidgets('bars stretch and honour the width factor', (tester) async {
    await tester.pumpWidget(
      wrap(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NinjaSkeleton.bar(),
            NinjaSkeleton.bar(height: 11, widthFactor: 0.6),
          ],
        ),
      ),
    );

    expect(tester.getSize(find.byType(NinjaSkeleton).first).width, 300);
    expect(tester.getSize(find.byType(NinjaSkeleton).first).height, 12);
    expect(tester.getSize(find.byType(NinjaSkeleton).last).width, 180);
    expect(tester.getSize(find.byType(NinjaSkeleton).last).height, 11);
  });

  testWidgets('standalone block creates one spatial scene', (tester) async {
    await tester.pumpWidget(wrap(const NinjaSkeleton.tile()));

    expect(find.byType(NinjaSkeletonGroup), findsOneWidget);
    expect(sceneBoundaries(), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 1);
    expect(
      find.descendant(
        of: find.byType(NinjaSkeletonGroup),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(NinjaSkeletonGroup),
        matching: find.byType(ShaderMask),
      ),
      findsNothing,
    );
  });

  testWidgets('reduced motion keeps static geometry without a scene boundary', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const NinjaSkeleton.tile(), reduceMotion: true),
    );
    await tester.pumpAndSettle();

    expect(sceneBoundaries(), findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.getSize(find.byType(NinjaSkeleton)).height, 64);
  });

  testWidgets('NinjaSkeletonRow composes an avatar and two bars', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const NinjaSkeletonRow(shimmer: false)));

    expect(find.byType(NinjaSkeleton), findsNWidgets(3));
    expect(find.byType(NinjaSkeletonGroup), findsNothing);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('group owns one scene boundary for every placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NinjaSkeletonGroup(
          child: Column(
            children: [
              NinjaSkeleton.bar(),
              NinjaSkeleton.tile(),
              NinjaSkeletonGroup(child: NinjaSkeletonRow()),
            ],
          ),
        ),
      ),
    );

    expect(sceneBoundaries(), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 1);
    expect(find.byType(NinjaSkeleton), findsNWidgets(5));
    expect(
      find.descendant(
        of: find.byType(NinjaSkeletonGroup).first,
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
  });

  testWidgets('shared sweep repaints geometry behind lazy child boundaries', (
    tester,
  ) async {
    var paints = 0;
    await tester.pumpWidget(
      wrap(
        NinjaSkeletonGroup(
          child: SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => RepaintBoundary(
                child: _PaintCounter(
                  onPaint: () => paints += 1,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: NinjaSkeleton.tile(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final initialPaints = paints;
    await tester.pump(const Duration(milliseconds: 400));

    expect(initialPaints, greaterThan(0));
    expect(paints, greaterThan(initialPaints));
    expect(tester.binding.transientCallbackCount, 1);
  });

  testWidgets('disabled group is a semantic render passthrough', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        NinjaSkeletonGroup(
          excludeSemantics: false,
          pulse: false,
          child: Semantics(
            label: 'loaded content',
            child: const SizedBox(height: 20),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('loaded content'), findsOneWidget);
    expect(sceneBoundaries(), findsNothing);
    semantics.dispose();
  });

  testWidgets('accessible navigation freezes the shared scene', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const NinjaSkeletonGroup(child: NinjaSkeleton.tile()),
        accessibleNavigation: true,
      ),
    );

    await tester.pump(const Duration(seconds: 3));
    expect(sceneBoundaries(), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('loading geometry stays silent for assistive technology', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        NinjaSkeletonGroup(
          child: Semantics(
            label: 'placeholder content',
            child: const NinjaSkeleton.tile(),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('placeholder content'), findsNothing);
    semantics.dispose();
  });

  testWidgets('screen loading group announces one live region', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        const NinjaSkeletonGroup(
          semanticsLabel: 'Loading content',
          child: Column(
            children: [NinjaSkeleton.bar(), NinjaSkeleton.tile()],
          ),
        ),
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('Loading content'));
    expect(node.flagsCollection.isLiveRegion, isTrue);
    expect(find.bySemanticsLabel('Loading content'), findsOneWidget);
    semantics.dispose();
  });
}
