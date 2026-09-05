import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_listing_details_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('listing photo opens every attachment with its thumbnail hero', (
    tester,
  ) async {
    const listing = MarketListing(
      id: 'book',
      title: 'Book',
      price: 0,
      media: [
        MarketMediaItem(
          path: 'cover.png',
          kind: MarketMediaKind.image,
          url: 'https://example.com/cover.png',
        ),
        MarketMediaItem(
          path: 'clip.mp4',
          kind: MarketMediaKind.video,
          url: 'https://example.com/clip.mp4',
        ),
      ],
    );
    await tester.pumpApp(
      Scaffold(
        body: MarketListingDetailsSheet(
          item: listing,
          onContact: () {},
          onShare: () {},
        ),
      ),
    );
    final source = tester.widget<Hero>(find.byType(Hero).first);
    await tester.tap(
      find
          .descendant(
            of: find.byType(PageView),
            matching: find.byType(AppPressable),
          )
          .first,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items, hasLength(2));
    expect(viewer.items.first.heroTag, source.tag);
    expect(viewer.items.last.kind, MediaKind.video);
    expect(viewer.items.last.heroTag, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
