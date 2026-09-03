import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/map/models/room_model.dart';
import 'package:rtu_mirea_app/map/widgets/map_loading_pill.dart';
import 'package:rtu_mirea_app/map/widgets/map_room_sheet.dart';

import '../../helpers/pump_app.dart';

class _MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  late _MockCampusRepository repository;

  setUp(() {
    repository = _MockCampusRepository();
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenAnswer((_) async => const []);
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 844),
    TextScaler textScaler = TextScaler.noScaling,
  }) => tester.pumpApp(
    RepositoryProvider<CampusRepository>.value(
      value: repository,
      child: child,
    ),
    size: size,
    textScaler: textScaler,
  );

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
        await pump(
          tester,
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: MapRoomSheet(
                room: RoomModel(roomId: 'А-101', path: Path()),
                campus: 'В-78',
              ),
            ),
          ),
          textScaler: TextScaler.linear(scale),
        );
        await tester.pump();
        expect(tester.getTopLeft(find.text('А-101')).dy, greaterThan(0));
        expect(find.text('Нет актуальных данных о занятости'), findsOneWidget);
        expect(find.text('Сохранить место'), findsNothing);
        expect(tester.getSize(find.byType(AppButton).last).height, 52);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('shows the empty photo placeholder and add CTA once loaded', (
    tester,
  ) async {
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: MapRoomSheet(
            room: RoomModel(roomId: 'r1', name: 'А-101', path: Path()),
            campus: 'В-78',
          ),
        ),
      ),
    );
    await tester.pump();

    verify(
      () => repository.getRoomPhotos(campus: 'v78', roomKey: 'А101'),
    ).called(1);
    expect(find.byType(RoomPhotoPlaceholder), findsOneWidget);
    expect(find.text('Добавить фото'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
