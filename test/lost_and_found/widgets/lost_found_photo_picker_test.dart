import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_picker.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_photo_thumbnail.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets(
    'full photo picker keeps its final gutter and removes the selected photo',
    (tester) async {
      final image = LostFoundImageUpload(
        bytes: base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0l'
          'EQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
        ),
        contentType: 'image/png',
      );
      int? removed;
      await tester.pumpApp(
        Scaffold(
          body: LostFoundPhotoPicker(
            images: List.filled(5, image),
            onAddFromGallery: () {},
            onAddFromCamera: () {},
            onRemove: (index) => removed = index,
          ),
        ),
        size: const Size(320, 900),
        textScaler: const TextScaler.linear(2),
      );
      await tester.pumpAndSettle();
      final scrollable = find.descendant(
        of: find.byType(LostFoundPhotoPicker),
        matching: find.byType(Scrollable),
      );
      final viewport = tester.getRect(scrollable);
      expect(viewport.left, 0);
      expect(viewport.right, 320);
      expect(
        tester.getRect(find.byType(LostFoundPhotoThumbnail).first).left,
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
      final last = find.byType(LostFoundPhotoThumbnail).last;
      expect(tester.getRect(last).right, 320 - AppSpacing.screen);
      await tester.tap(
        find.descendant(of: last, matching: find.byType(AppPressable)),
      );
      expect(removed, 4);
      expect(tester.takeException(), isNull);
    },
  );
}
