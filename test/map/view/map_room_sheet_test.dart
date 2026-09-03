import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/map/models/room_model.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_pill.dart';
import 'package:rtu_mirea_app/map/widgets/map_room_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('floor-loading status wraps on narrow screens with large text', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Center(child: SizedBox(width: 220, child: MapLoadingPill())),
      ),
      size: const Size(320, 568),
      textScaler: const TextScaler.linear(2),
    );
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'unknown mapped room keeps source structure at ${scale}x '
      'without invented data',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: MapRoomSheet(
                room: RoomModel(roomId: 'А-101', path: Path()),
              ),
            ),
          ),
          size: const Size(390, 844),
          textScaler: TextScaler.linear(scale),
        );
        final photo = tester.getRect(find.byType(RoomPhotoPlaceholder));
        expect(photo.height, 150);
        expect(tester.getTopLeft(find.text('А-101')).dy - photo.bottom, 16);
        expect(find.text('Нет актуальных данных о занятости'), findsOneWidget);
        expect(find.text('Сохранить место'), findsNothing);
        expect(tester.getSize(find.byType(AppButton)).height, 52);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
