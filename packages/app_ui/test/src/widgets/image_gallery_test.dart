import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
    final gallery =
        tester.widget<PhotoViewGallery>(find.byType(PhotoViewGallery));
    expect(gallery.pageController?.initialPage, 1);
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
      tester
          .widget<PhotoViewGallery>(find.byType(PhotoViewGallery))
          .pageController
          ?.page,
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
