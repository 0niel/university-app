import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';

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
    WidgetTester tester, {
    double scale = 1,
    VoidCallback? onRoute,
  }) async {
    final now = DateTime.now();
    await tester.pumpApp(
      RepositoryProvider<CampusRepository>.value(
        value: repository,
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FreeRoomSheet(
              onRoute: onRoute,
              room: FreeRoomViewModel(
                room: FreeRoom(
                  room: 'А-101',
                  campus: 'МП-1',
                  freeUntil: now.add(const Duration(hours: 1)),
                ),
                now: now,
              ),
            ),
          ),
        ),
      ),
      size: const Size(320, 900),
      textScaler: TextScaler.linear(scale),
    );
    await tester.pump();
  }

  testWidgets('shows the empty photo placeholder and add CTA', (
    tester,
  ) async {
    await pump(tester);
    final photo = tester.getRect(find.byType(RoomPhotoPlaceholder));
    expect(photo.height, 150);
    expect(find.text('Добавить фото'), findsOneWidget);
    expect(tester.getTopLeft(find.text('А-101')).dy, greaterThan(photo.bottom));
  });

  testWidgets('never invents booking affordances', (tester) async {
    await pump(tester);
    expect(find.text('Сохранить место'), findsNothing);
    expect(find.text('Удалить сохранённое место'), findsNothing);
  });

  testWidgets('details sheet supports 200 percent text without overflow', (
    tester,
  ) async {
    await pump(tester, scale: 2);
    expect(tester.takeException(), isNull);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -600),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'room details keep the heading, stat grid and a full-width route CTA',
    (tester) async {
      await pump(tester, onRoute: () {});
      final cards = find.byType(AppCard);
      expect(cards, findsNWidgets(3));
      final first = tester.getRect(cards.at(0));
      final second = tester.getRect(cards.at(1));
      expect(first.top, second.top);
      expect(first.height, second.height);
      expect(second.left - first.right, 8);
      final route = find.text('Показать на плане');
      expect(route, findsOneWidget);
      expect(tester.getSize(find.byType(AppButton).last).height, 52);
    },
  );

  testWidgets('hides the route CTA when there is nothing to focus', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Показать на плане'), findsNothing);
  });
}
