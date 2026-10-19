import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/marketplace/models/market_media_draft_item.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_media_picker.dart';
import 'package:rtu_mirea_app/marketplace/widgets/market_media_thumbnail.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('null remove callback disables attachment removal', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpApp(
        Scaffold(
          body: MarketMediaPicker(
            items: [
              MarketMediaDraftItem(key: 'saved-media', kind: .video),
            ],
            onReorder: (_, _) {},
            onRemove: null,
          ),
        ),
      );
      final thumbnail = find.byType(MarketMediaThumbnail);
      expect(tester.widget<MarketMediaThumbnail>(thumbnail).onRemove, isNull);
      final removeButton = find.descendant(
        of: thumbnail,
        matching: find.byType(AppPressState),
      );
      final control = tester.widget<AppPressState>(removeButton);
      expect(control.onTap, isNull);
      expect(control.enabled, isFalse);
      expect(
        tester.getSemantics(removeButton),
        matchesSemantics(
          label: tester.element(thumbnail).l10n.marketRemoveMediaItem,
          isButton: true,
          hasEnabledState: true,
        ),
      );
      await tester.tap(removeButton);
      await tester.pump();
      expect(find.byType(MarketMediaThumbnail), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'media picker preserves both gutters and removes the selected attachment',
    (tester) async {
      int? removed;
      await tester.pumpApp(
        Scaffold(
          body: MarketMediaPicker(
            items: [
              for (var i = 0; i < 5; i++)
                MarketMediaDraftItem(
                  key: 'media-$i',
                  kind: MarketMediaKind.video,
                ),
            ],
            onReorder: (_, _) {},
            onRemove: (index) => removed = index,
          ),
        ),
        size: const Size(320, 900),
        textScaler: const TextScaler.linear(2),
      );
      final scrollable = find.descendant(
        of: find.byType(MarketMediaPicker),
        matching: find.byType(Scrollable),
      );
      final viewport = tester.getRect(scrollable);
      expect(viewport.left, 0);
      expect(viewport.right, 320);
      expect(
        tester.getRect(find.byType(MarketMediaThumbnail).first).left,
        AppSpacing.screen,
      );
      final position = tester.state<ScrollableState>(scrollable).position;
      await tester.dragFrom(
        Offset(318, viewport.center.dy),
        const Offset(-220, 0),
      );
      await tester.pumpAndSettle();
      expect(position.pixels, greaterThan(0));
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();
      final last = find.byType(MarketMediaThumbnail).last;
      expect(tester.getRect(last).right, 320 - AppSpacing.screen);
      await tester.tap(
        find.descendant(of: last, matching: find.byType(AppPressState)),
      );
      expect(removed, 4);
      expect(tester.takeException(), isNull);
    },
  );
}
