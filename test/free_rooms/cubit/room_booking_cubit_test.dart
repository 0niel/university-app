import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/room_booking_cubit.dart';

class _Storage extends Mock implements Storage {}

void main() {
  late _Storage storage;
  late RoomBookingCubit cubit;
  final now = DateTime(2026, 9, 2, 12);
  final booking = RoomBooking(
    room: 'А-101',
    campus: 'mp1',
    until: now.add(const Duration(hours: 1)),
  );

  setUp(() {
    storage = _Storage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    cubit = RoomBookingCubit(storage: storage, now: () => now);
  });
  tearDown(() => cubit.close());

  test('save and release wait for durable local storage', () async {
    final pending = Completer<void>();
    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenAnswer((_) => pending.future);
    final operation = cubit.book(booking);
    expect(cubit.state.booking, isNull);
    pending.complete();
    expect(await operation, isTrue);
    expect(cubit.state.booking, booking);
    expect(await cubit.release(), isTrue);
    expect(cubit.state.booking, isNull);
  });

  test('write failure never confirms a saved room', () async {
    when(
      () => storage.write(any(), any<dynamic>()),
    ).thenThrow(StateError('disk'));
    expect(await cubit.book(booking), isFalse);
    expect(cubit.state.booking, isNull);
  });

  test('expired availability cannot be saved', () async {
    expect(await cubit.book(booking.copyWith(until: now)), isFalse);
    expect(cubit.state.booking, isNull);
  });

  test('same room number in another campus is not the saved room', () async {
    await cubit.book(booking);
    expect(cubit.state.isBooked('А 101', now, campus: 'МП-1'), isTrue);
    expect(cubit.state.isBooked('А-101', now, campus: 'В-78'), isFalse);
    expect(cubit.state.isBooked('А-101', now), isFalse);
  });

  test('malformed hydration payload does not throw', () {
    expect(cubit.fromJson({'room': 123, 'until': false})?.booking, isNull);
    expect(
      cubit
          .fromJson({
            'room': 'А-101',
            'until': now.add(const Duration(hours: 1)).toIso8601String(),
            'campus': 22,
          })
          ?.booking
          ?.campus,
      isNull,
    );
  });

  test('stored schema stays compatible', () {
    final encoded = cubit.toJson(RoomBookingState(booking: booking));
    expect(cubit.fromJson(encoded!)?.booking, booking);
  });
}
