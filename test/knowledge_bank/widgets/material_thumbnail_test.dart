import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_thumbnail.dart';

import '../../helpers/pump_app.dart';

Widget _sized(Widget child) => SizedBox(width: 44, height: 44, child: child);

void main() {
  testWidgets('shows an image glyph tile when there is no preview url', (
    tester,
  ) async {
    await tester.pumpApp(
      _sized(
        const MaterialThumbnail(previewUrl: null, mimeType: 'image/png'),
      ),
    );
    final icon = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(icon.icon, AppLineIcon.image);
  });

  testWidgets('shows a video glyph tile for video mime types', (
    tester,
  ) async {
    await tester.pumpApp(
      _sized(
        const MaterialThumbnail(previewUrl: null, mimeType: 'video/mp4'),
      ),
    );
    final icon = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(icon.icon, AppLineIcon.video);
  });

  testWidgets('shows a pdf glyph tile for pdf materials', (tester) async {
    await tester.pumpApp(
      _sized(
        const MaterialThumbnail(
          previewUrl: null,
          mimeType: 'application/pdf',
        ),
      ),
    );
    final icon = tester.widget<AppLineIconWidget>(
      find.byType(AppLineIconWidget),
    );
    expect(icon.icon, AppLineIcon.book);
  });

  testWidgets('renders a cached network image when a preview url exists', (
    tester,
  ) async {
    await tester.pumpApp(
      _sized(
        const MaterialThumbnail(
          previewUrl: 'https://example.com/preview.jpg',
          mimeType: 'application/pdf',
        ),
      ),
    );
    expect(find.byType(AppLineIconWidget), findsNothing);
  });
}
