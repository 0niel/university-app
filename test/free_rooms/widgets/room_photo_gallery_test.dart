import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/common/media_viewer/media_viewer.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_tile.dart';

import '../../helpers/pump_app.dart';

class _MockCampusRepository extends Mock implements CampusRepository {}

void main() {
  late _MockCampusRepository repository;

  setUp(() {
    repository = _MockCampusRepository();
  });

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    RepositoryProvider<CampusRepository>.value(
      value: repository,
      child: const Scaffold(
        body: RoomPhotoGallery(campus: 'В-78', roomName: 'А-101'),
      ),
    ),
  );

  testWidgets('loads photos scoped to the normalized campus and room key', (
    tester,
  ) async {
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenAnswer((_) async => const []);

    await pump(tester);
    await tester.pump();

    verify(
      () => repository.getRoomPhotos(campus: 'v78', roomKey: 'А101'),
    ).called(1);
    expect(find.byType(RoomPhotoPlaceholder), findsOneWidget);
    expect(find.text('Добавить фото'), findsOneWidget);
  });

  testWidgets('shows a retryable error when the load fails', (tester) async {
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenThrow(Exception('boom'));

    await pump(tester);
    await tester.pump();

    expect(find.text('Ошибка загрузки'), findsOneWidget);
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenAnswer((_) async => const []);
    await tester.tap(find.text('Повторить'));
    await tester.pump();
    await tester.pump();
    expect(find.byType(RoomPhotoPlaceholder), findsOneWidget);
  });

  testWidgets('the add CTA opens a camera/gallery source sheet', (
    tester,
  ) async {
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenAnswer((_) async => const []);

    await pump(tester);
    await tester.pump();
    await tester.tap(find.text('Добавить фото'));
    await tester.pumpAndSettle();

    expect(find.text('Камера'), findsOneWidget);
    expect(find.text('Галерея'), findsOneWidget);
  });
  testWidgets('room photo opens the whole collection with its source hero', (
    tester,
  ) async {
    final photos = [
      for (var i = 0; i < 2; i++)
        RoomPhoto(
          id: '$i',
          path: '$i.png',
          createdBy: 'user',
          createdAt: DateTime(2026),
          url: 'https://example.com/$i.png',
        ),
    ];
    when(
      () => repository.getRoomPhotos(
        campus: any(named: 'campus'),
        roomKey: any(named: 'roomKey'),
      ),
    ).thenAnswer((_) async => photos);
    await pump(tester);
    await tester.pump();
    final source = find
        .descendant(
          of: find.byType(RoomPhotoGallery),
          matching: find.byType(Hero),
        )
        .first;
    final tag = tester.widget<Hero>(source).tag;
    await tester.tap(find.byType(RoomPhotoTile).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final viewer = tester.widget<MediaViewerPage>(find.byType(MediaViewerPage));
    expect(viewer.items, hasLength(2));
    expect(viewer.items.first.heroTag, tag);
    expect(viewer.items.last.heroTag, isNot(tag));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
