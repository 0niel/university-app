import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../kit_harness.dart';

void main() {
  Widget wrap(Widget child) => wrapKit(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: child,
        ),
      );

  testWidgets('empty gallery has themed fallback and back header',
      (tester) async {
    await tester.pumpWidget(wrap(const ImagesViewGallery(imageUrls: [])));
    expect(find.byType(AppInnerHeader), findsOneWidget);
    expect(find.byType(ImagePlaceholder), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
    expect(find.text('0 / 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery honors initialIndex and clamps shrinking input',
      (tester) async {
    const urls = ['https://example.test/1.png', 'https://example.test/2.png'];
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: urls,
          initialIndex: 1,
        ),
      ),
    );
    final gallery = tester.widget<PageView>(find.byType(PageView));
    expect(gallery.controller?.initialPage, 1);
    expect(find.text('2 / 2'), findsOneWidget);
    gallery.onPageChanged!(0);
    await tester.pump();
    expect(find.text('1 / 2'), findsOneWidget);
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: ['https://example.test/1.png'],
          initialIndex: 99,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('1 / 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery preserves requested page through empty loading state',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: [],
          initialIndex: 2,
        ),
      ),
    );
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: [
            'https://example.test/1.png',
            'https://example.test/2.png',
            'https://example.test/3.png',
          ],
          initialIndex: 2,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(
      tester.widget<PageView>(find.byType(PageView)).controller?.page,
      2,
    );
  });

  testWidgets('slider preserves first-image exclusion and20px inset',
      (tester) async {
    await tester.pumpWidget(wrap(const ImagesHorizontalSlider(images: [])));
    expect(find.byType(GalleryImageItem), findsNothing);
    await tester.pumpWidget(
      wrap(
        const ImagesHorizontalSlider(
          images: [
            'https://example.test/1.png',
            'https://example.test/2.png',
          ],
        ),
      ),
    );
    expect(
      tester.widget<GalleryImageItem>(find.byType(GalleryImageItem)).imageUrl,
      'https://example.test/2.png',
    );
    expect(
      tester.widget<ListView>(find.byType(ListView)).padding,
      const EdgeInsets.symmetric(horizontal: 20),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
      'gallery delegates paging, toolbar and backdrop to image gestures',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: [
            'https://example.test/1.png',
            'https://example.test/2.png',
          ],
        ),
      ),
    );
    final first =
        tester.widget<AppZoomableImage>(find.byType(AppZoomableImage));
    expect(first.onPrevious, isNull);
    expect(first.onNext, isNotNull);
    expect(
      tester.widget<PageView>(find.byType(PageView)).physics,
      isA<NeverScrollableScrollPhysics>(),
    );
    first.onTap!();
    await tester.pump();
    expect(find.byType(AppInnerHeader), findsNothing);
    first.onTap!();
    first.onDismissProgress!(.4);
    await tester.pump();
    expect(find.byType(AppInnerHeader), findsOneWidget);
    expect(
      tester
          .widget<ColoredBox>(find.byKey(const ValueKey('gallery-backdrop')))
          .color
          .a,
      closeTo(.6, .01),
    );
    first.onNext!();
    await tester.pump();
    final second =
        tester.widget<AppZoomableImage>(find.byType(AppZoomableImage));
    expect(find.text('2 / 2'), findsOneWidget);
    expect(second.onPrevious, isNotNull);
    expect(second.onNext, isNull);
    second.onPrevious!();
    await tester.pump();
    expect(find.text('1 / 2'), findsOneWidget);
  });

  testWidgets(
      'slider opens the whole in-app gallery with a matching unique hero',
      (tester) async {
    const urls = [
      'https://example.test/1.png',
      'https://example.test/2.png',
      'https://example.test/2.png',
    ];
    await tester.pumpWidget(wrap(const ImagesHorizontalSlider(images: urls)));
    final source = find.byType(GalleryImageItem).first;
    final sourceHero = tester.widget<Hero>(
      find.descendant(of: source, matching: find.byType(Hero)),
    );
    final otherHero = tester.widget<Hero>(
      find.descendant(
        of: find.byType(GalleryImageItem).last,
        matching: find.byType(Hero),
      ),
    );
    expect(otherHero.tag, isNot(sourceHero.tag));
    await tester.tap(source);
    await tester.pump();
    await tester.pump();
    final gallery =
        tester.widget<ImagesViewGallery>(find.byType(ImagesViewGallery));
    expect(gallery.imageUrls, urls);
    expect(gallery.initialIndex, 1);
    final image =
        tester.widget<AppZoomableImage>(find.byType(AppZoomableImage));
    expect(image.heroTag, sourceHero.tag);
    final route =
        ModalRoute.of(tester.element(find.byType(ImagesViewGallery)))!;
    expect(route.opaque, isFalse);
    expect(route.transitionDuration, Duration.zero);
    image.onDismissed!();
    await tester.pump();
    await tester.pump();
    expect(find.byType(ImagesViewGallery), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery follows a horizontal finger drag before release',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ImagesViewGallery(
          imageUrls: [
            'https://example.test/drag-1.png',
            'https://example.test/drag-2.png',
          ],
        ),
      ),
    );
    final page = tester.widget<PageView>(find.byType(PageView));
    final controller = page.controller!;
    final gesture = await tester
        .startGesture(tester.getCenter(find.byType(AppZoomableImage)));
    await gesture.moveBy(const Offset(-40, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-200, 0));
    await tester.pump();
    expect(controller.page, greaterThan(0));
    expect(controller.page, lessThan(1));
    final heldPage = controller.page;
    await tester.pump(const Duration(milliseconds: 150));
    expect(controller.page, closeTo(heldPage!, .001));
    final offscreenFocus = tester.widgetList<ExcludeFocus>(
      find.descendant(
        of: find.byType(PageView),
        matching: find.byType(ExcludeFocus),
      ),
    );
    expect(offscreenFocus.where((widget) => widget.excluding), isNotEmpty);
    await gesture.moveBy(const Offset(-300, 0));
    await gesture.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(controller.page, 1);
    expect(find.text('2 / 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('image opening blocks duplicate taps and shows kit error',
      (tester) async {
    final request = Completer<void>();
    var calls = 0;
    ToastManager.debugReset();
    addTearDown(ToastManager.debugReset);
    await tester.pumpWidget(
      wrap(
        SizedBox(
          width: 180,
          height: 180,
          child: GalleryImageItem(
            imageUrl: 'https://example.test/1.png',
            semanticLabel: 'Open image',
            errorMessage: 'Could not open image',
            onOpen: (_) {
              calls++;
              return request.future;
            },
          ),
        ),
      ),
    );
    await tester.tap(find.byType(GalleryImageItem));
    await tester.pump();
    await tester.tap(find.byType(GalleryImageItem));
    expect(calls, 1);
    request.completeError(Exception('private diagnostic'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Could not open image'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.textContaining('private diagnostic'), findsNothing);
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(const SizedBox());
  });
}
