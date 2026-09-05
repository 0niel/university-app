import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_gallery.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_viewer.dart';

import '../../helpers/pump_app.dart';

void main() {
  const url = 'https://example.com/photo.png';

  testWidgets(
    'opens the selected image with the complete gallery and matching hero',
    (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) => AppButton.primary(
              label: 'Photos',
              onPressed: () => showAppSheet<void>(
                context,
                title: 'Photos',
                child: const LostFoundGallery(images: [url, url]),
              ),
            ),
          ),
        ),
        size: const Size(360, 700),
      );
      await tester.tap(find.text('Photos'));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      final source = find
          .descendant(
            of: find.byType(LostFoundGallery),
            matching: find.byType(Hero),
          )
          .last;
      final tag = tester.widget<Hero>(source).tag;
      await tester.tap(
        find
            .descendant(
              of: find.byType(LostFoundGallery),
              matching: find.byType(AppPressable),
            )
            .last,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final viewer = tester.widget<MediaViewerPage>(
        find.byType(MediaViewerPage),
      );
      expect(viewer.items, hasLength(2));
      expect(viewer.initialIndex, 1);
      expect(viewer.items[1].heroTag, tag);
      expect(viewer.items[0].heroTag, isNot(viewer.items[1].heroTag));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('identical URLs in separate galleries have unique hero tags', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Column(
          children: [
            LostFoundGallery(images: [url]),
            LostFoundGallery(images: [url]),
          ],
        ),
      ),
    );
    final heroes = tester.widgetList<Hero>(find.byType(Hero)).toList();
    expect(heroes, hasLength(2));
    expect(heroes[0].tag, isNot(heroes[1].tag));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('legacy photo viewer delegates to the shared media viewer', (
    tester,
  ) async {
    await tester.pumpApp(const LostFoundPhotoViewer(url: url));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items.single.url, url);
    expect(viewer.items.single.kind, MediaKind.image);
    await tester.pumpWidget(const SizedBox());
  });
}
