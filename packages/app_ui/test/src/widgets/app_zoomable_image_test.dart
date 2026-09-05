import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MemoryImage image;
  setUpAll(() async {
    final fixture = await createTestImage(width: 300, height: 600);
    final bytes = await fixture.toByteData(format: ui.ImageByteFormat.png);
    image = MemoryImage(bytes!.buffer.asUint8List());
    fixture.dispose();
  });

  Future<void> pump(
    WidgetTester tester, {
    VoidCallback? dismiss,
    VoidCallback? next,
    VoidCallback? previous,
    bool reduceMotion = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 600,
              child: AppZoomableImage(
                imageProvider: image,
                onDismissed: dismiss,
                onNext: next,
                onPrevious: previous,
                errorBuilder: (_, error, stack) => const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(image, tester.element(find.byType(AppZoomableImage))),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<RawImage>(find.byType(RawImage)).image?.width, 300);
  }

  double scale(WidgetTester tester) => tester
      .widget<Transform>(
        find.byKey(const ValueKey('image-zoom-transform')),
      )
      .transform
      .getMaxScaleOnAxis();

  Future<void> doubleTap(WidgetTester tester) async {
    final target = find.byType(AppZoomableImage);
    await tester.tap(target);
    await tester.pump(const Duration(milliseconds: 60));
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  testWidgets('double tap toggles real zoom and reset', (tester) async {
    await pump(tester);
    expect(scale(tester), 1);
    await doubleTap(tester);
    expect(scale(tester), closeTo(3, .01));
    await tester.pump(const Duration(milliseconds: 350));
    await doubleTap(tester);
    expect(scale(tester), closeTo(1, .01));
  });

  testWidgets('base scale vertical swipe dismisses and short drag returns',
      (tester) async {
    var closes = 0;
    await pump(tester, dismiss: () => closes++);
    await tester.timedDrag(
      find.byType(AppZoomableImage),
      const Offset(0, 35),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();
    expect(closes, 0);
    expect(scale(tester), closeTo(1, .01));
    await tester.drag(find.byType(AppZoomableImage), const Offset(0, 180));
    await tester.pumpAndSettle();
    expect(closes, 1);
  });

  testWidgets('horizontal swipe pages while zoomed drag only pans',
      (tester) async {
    var next = 0;
    var previous = 0;
    var closes = 0;
    await pump(
      tester,
      next: () => next++,
      previous: () => previous++,
      dismiss: () => closes++,
    );
    await tester.drag(find.byType(AppZoomableImage), const Offset(-130, 0));
    await tester.pumpAndSettle();
    expect(next, 1);
    await tester.drag(find.byType(AppZoomableImage), const Offset(130, 0));
    await tester.pumpAndSettle();
    expect(previous, 1);
    await doubleTap(tester);
    await tester.drag(find.byType(AppZoomableImage), const Offset(0, 180));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(AppZoomableImage), const Offset(-130, 0));
    await tester.pumpAndSettle();
    expect(closes, 0);
    expect(next, 1);
    expect(scale(tester), greaterThan(1));
  });

  testWidgets('two finger pinch zooms without dismissing or paging',
      (tester) async {
    var closes = 0;
    var pages = 0;
    await pump(tester, dismiss: () => closes++, next: () => pages++);
    final center = tester.getCenter(find.byType(AppZoomableImage));
    final first =
        await tester.startGesture(center - const Offset(30, 0), pointer: 1);
    final second =
        await tester.startGesture(center + const Offset(30, 0), pointer: 2);
    await first.moveTo(center - const Offset(45, 0));
    await second.moveTo(center + const Offset(45, 0));
    await tester.pump();
    await first.moveTo(center - const Offset(100, 0));
    await second.moveTo(center + const Offset(100, 0));
    await tester.pump();
    await first.up();
    await second.up();
    await tester.pumpAndSettle();
    expect(scale(tester), greaterThan(1.2));
    expect(closes, 0);
    expect(pages, 0);
  });

  testWidgets('reduced motion zoom remains functional', (tester) async {
    await pump(tester, reduceMotion: true);
    await doubleTap(tester);
    expect(scale(tester), closeTo(3, .01));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('adding a pinch finger never commits a pending dismiss',
      (tester) async {
    var closes = 0;
    await pump(tester, dismiss: () => closes++);
    final center = tester.getCenter(find.byType(AppZoomableImage));
    final first = await tester.startGesture(center, pointer: 1);
    await first.moveBy(const Offset(0, 160));
    await tester.pump();
    final second =
        await tester.startGesture(center - const Offset(50, 0), pointer: 2);
    await tester.pump();
    expect(closes, 0);
    await first.moveBy(const Offset(20, 0));
    await second.moveBy(const Offset(-20, 0));
    await tester.pump();
    await first.up();
    await second.up();
    await tester.pumpAndSettle();
    expect(closes, 0);
  });

  testWidgets('cancelled drag beyond dismissal threshold stays open',
      (tester) async {
    var closes = 0;
    await pump(tester, dismiss: () => closes++);
    final gesture = await tester
        .startGesture(tester.getCenter(find.byType(AppZoomableImage)));
    await gesture.moveBy(const Offset(0, 180));
    await tester.pump();
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(closes, 0);
    expect(scale(tester), closeTo(1, .01));
  });
}
