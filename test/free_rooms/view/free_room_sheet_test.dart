import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/room_booking_cubit.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_sheet.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/free_room_view_model.dart';
import 'package:rtu_mirea_app/free_rooms/widgets/room_photo_placeholder.dart';

import '../../helpers/pump_app.dart';

class _Cubit extends MockCubit<RoomBookingState> implements RoomBookingCubit {}

void main() {
  late _Cubit cubit;
  setUp(() {
    cubit = _Cubit();
    when(() => cubit.state).thenReturn(const RoomBookingState());
    registerFallbackValue(
      RoomBooking(room: 'А-101', until: DateTime(2026, 9, 2)),
    );
  });
  tearDown(() => cubit.close());

  Future<void> pump(
    WidgetTester tester, {
    double scale = 1,
    VoidCallback? onRoute,
  }) async {
    final now = DateTime.now();
    await tester.pumpApp(
      BlocProvider<RoomBookingCubit>.value(
        value: cubit,
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

  testWidgets(
    'local save discloses limits and does not invent floor information',
    (tester) async {
      await pump(tester);
      expect(find.textContaining('Она не бронирует аудиторию'), findsOneWidget);
      expect(find.text('Неизвестно'), findsOneWidget);
      expect(find.text('Сохранить место'), findsOneWidget);
      expect(find.text('Показать на плане'), findsNothing);
    },
  );

  testWidgets('a failed write leaves the room unsaved and shows an error', (
    tester,
  ) async {
    when(() => cubit.book(any())).thenAnswer((_) async => false);
    await pump(tester);
    await tester.tap(find.text('Сохранить место'));
    await tester.pump();
    expect(
      find.text('Не удалось сохранить. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    verify(() => cubit.book(any())).called(1);
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
    'room details keep the source photo, heading, stat grid and route geometry',
    (tester) async {
      await pump(tester, onRoute: () {});
      final photo = tester.getRect(find.byType(RoomPhotoPlaceholder));
      expect(photo.height, 150);
      expect(
        tester
            .widget<Text>(find.text('фото аудитории'))
            .style
            ?.fontFamilyFallback,
        contains(AppText.sansFamily),
      );
      expect(tester.getTopLeft(find.text('А-101')).dy - photo.bottom, 16);
      final stripes = tester.widget<AppStripePlaceholder>(
        find.byType(AppStripePlaceholder),
      );
      expect(stripes.borderRadius, BorderRadius.circular(24));
      final cards = find.byType(AppCard);
      expect(cards, findsNWidgets(3));
      final first = tester.getRect(cards.at(0));
      final second = tester.getRect(cards.at(1));
      expect(first.top, second.top);
      expect(first.height, second.height);
      expect(second.left - first.right, 8);
      final route = find.byTooltip('Показать на плане');
      expect(tester.getSize(route), const Size(52, 52));
      expect(tester.getSize(find.byType(AppButton).last).height, 52);
    },
  );

  testWidgets(
    'pending local save shows a loading action and cannot repeat the write',
    (tester) async {
      final pending = Completer<bool>();
      addTearDown(() {
        if (!pending.isCompleted) pending.complete(false);
      });
      when(() => cubit.book(any())).thenAnswer((_) => pending.future);
      await pump(tester);
      await tester.tap(find.text('Сохранить место'));
      await tester.pump();
      final button = tester.widget<AppButton>(find.byType(AppButton).last);
      expect(button.loading, isTrue);
      expect(button.onPressed, isNull);
      verify(() => cubit.book(any())).called(1);
      pending.complete(false);
      await tester.pump();
      expect(
        tester.widget<AppButton>(find.byType(AppButton).last).loading,
        isFalse,
      );
    },
  );
}
