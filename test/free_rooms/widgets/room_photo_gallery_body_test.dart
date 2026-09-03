import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_gallery_body.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_tile.dart';

import '../../helpers/pump_app.dart';

void main() {
  Widget buildSubject({
    RoomPhotoGalleryStatus status = RoomPhotoGalleryStatus.loaded,
    List<RoomPhoto> photos = const [],
    int index = 0,
    int uploadDone = 0,
    int uploadTotal = 0,
    VoidCallback? onRetry,
    ValueChanged<RoomPhoto>? onDeletePhoto,
    VoidCallback? onAddPhoto,
  }) {
    return Scaffold(
      body: RoomPhotoGalleryBody(
        status: status,
        photos: photos,
        index: index,
        pageController: PageController(),
        uploadDone: uploadDone,
        uploadTotal: uploadTotal,
        onIndexChanged: (_) {},
        onRetry: onRetry ?? () {},
        onOpenPhoto: (_) {},
        onAddPhoto: onAddPhoto,
        onDeletePhoto: onDeletePhoto,
      ),
    );
  }

  testWidgets('loading shows a stripe placeholder, not a spinner', (
    tester,
  ) async {
    await tester.pumpApp(
      buildSubject(status: RoomPhotoGalleryStatus.loading),
    );
    expect(find.byType(AppStripePlaceholder), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('empty loaded state shows the placeholder and add CTA', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpApp(
      buildSubject(onAddPhoto: () => tapped = true),
    );
    expect(find.byType(RoomPhotoPlaceholder), findsOneWidget);
    expect(find.text('Добавить фото'), findsOneWidget);
    await tester.tap(find.text('Добавить фото'));
    expect(tapped, isTrue);
  });

  testWidgets('loaded state with photos shows dots and the caption', (
    tester,
  ) async {
    final photos = [
      RoomPhoto(
        id: 'p1',
        path: 'user-1/a.jpg',
        createdBy: 'user-1',
        authorName: 'Анна',
        createdAt: DateTime.now(),
        url: 'https://example.com/a.jpg',
      ),
      RoomPhoto(
        id: 'p2',
        path: 'user-1/b.jpg',
        createdBy: 'user-1',
        authorName: 'Иван',
        createdAt: DateTime.now(),
        url: 'https://example.com/b.jpg',
      ),
    ];
    await tester.pumpApp(buildSubject(photos: photos));
    expect(find.byType(RoomPhotoTile), findsAtLeastNWidgets(1));
    expect(find.byType(RoomPhotoDots), findsOneWidget);
    expect(find.textContaining('Анна'), findsOneWidget);
  });

  testWidgets('error state offers a retry action', (tester) async {
    var retried = false;
    await tester.pumpApp(
      buildSubject(
        status: RoomPhotoGalleryStatus.error,
        onRetry: () => retried = true,
      ),
    );
    expect(find.text('Ошибка загрузки'), findsOneWidget);
    await tester.tap(find.text('Повторить'));
    expect(retried, isTrue);
  });

  testWidgets('offline state explains photos need a connection', (
    tester,
  ) async {
    await tester.pumpApp(buildSubject(status: RoomPhotoGalleryStatus.offline));
    expect(find.text('Оффлайн'), findsOneWidget);
    expect(
      find.text('Проверь интернет, чтобы увидеть фото аудитории.'),
      findsOneWidget,
    );
  });

  testWidgets('shows upload progress while photos are uploading', (
    tester,
  ) async {
    await tester.pumpApp(
      buildSubject(uploadTotal: 3, uploadDone: 1),
    );
    expect(find.byType(AppProgressBar), findsOneWidget);
  });
}
