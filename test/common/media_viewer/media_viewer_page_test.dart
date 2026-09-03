import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_file_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_image_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_pdf_page.dart';
import 'package:rtu_mirea_app/common/media_viewer/widgets/media_video_page.dart';

import '../../helpers/pump_app.dart';

const _items = [
  MediaItem(
    url: 'https://example.com/a.png',
    kind: MediaKind.image,
    fileName: 'a.png',
    sizeBytes: 1024,
  ),
  MediaItem(
    url: 'https://example.com/b.mp4',
    kind: MediaKind.video,
    fileName: 'b.mp4',
  ),
  MediaItem(
    url: 'https://example.com/c.pdf',
    kind: MediaKind.pdf,
    fileName: 'c.pdf',
  ),
  MediaItem(
    url: 'https://example.com/d.zip',
    kind: MediaKind.file,
    fileName: 'd.zip',
    sizeBytes: 2048,
  ),
];

void main() {
  testWidgets('routes each media kind to its dedicated page', (tester) async {
    await tester.pumpApp(
      const MediaViewerPage(items: _items, initialIndex: 0),
    );
    await tester.pump();

    expect(find.byType(MediaImagePage), findsOneWidget);

    final pageView = find.byType(PageView);
    await tester.drag(pageView, const Offset(-800, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(MediaVideoPage), findsOneWidget);

    await tester.drag(pageView, const Offset(-800, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(MediaPdfPage), findsOneWidget);

    await tester.drag(pageView, const Offset(-800, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(MediaFilePage), findsOneWidget);
  });

  testWidgets('shows the gallery index counter for multi-item galleries', (
    tester,
  ) async {
    await tester.pumpApp(
      const MediaViewerPage(items: _items, initialIndex: 2),
    );
    await tester.pump();

    expect(find.textContaining('3 / 4'), findsOneWidget);
  });

  testWidgets('opens a file card with open and download actions', (
    tester,
  ) async {
    await tester.pumpApp(
      const MediaViewerPage(items: _items, initialIndex: 3),
    );
    await tester.pump();

    expect(find.byType(MediaFilePage), findsOneWidget);
    expect(find.text('d.zip'), findsWidgets);
  });
}
