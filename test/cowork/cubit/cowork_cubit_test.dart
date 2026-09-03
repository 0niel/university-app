import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_cubit.dart';
import 'package:rtu_mirea_app/cowork/data/cowork_repository.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';

class _Repository implements CoworkRepository {
  CoworkBooking? saved;
  bool fail = false;
  Completer<void>? pending;
  int saves = 0;

  @override
  Future<CoworkBooking?> loadBooking() async => saved;

  @override
  Future<void> saveBooking(CoworkBooking? booking) async {
    saves++;
    await pending?.future;
    if (fail) throw StateError('storage failed');
    saved = booking;
  }
}

void main() {
  late _Repository repository;
  late CoworkCubit cubit;
  late DateTime now;

  setUp(() {
    now = DateTime(2026, 9, 2, 12);
    repository = _Repository();
    cubit = CoworkCubit(repository: repository, now: () => now);
  });
  tearDown(() => cubit.close());

  test('all unsaved seats have unknown availability', () async {
    await cubit.load();
    expect(cubit.state.status, CoworkStatus.ready);
    expect(cubit.state.seats, hasLength(24));
    expect(
      cubit.state.seats.every(
        (seat) => seat.status == CoworkSeatStatus.unknown,
      ),
      isTrue,
    );
    expect(cubit.state.friendsHere, isEmpty);
  });

  test('select, save, reload and remove a personal seat', () async {
    await cubit.load();
    cubit.seatTapped('Т2');
    final result = await cubit.book();
    expect(result?.seatId, 'Т2');
    expect(repository.saved, result);
    expect(cubit.state.hasBooking, isTrue);
    expect(result?.until, now.add(const Duration(hours: 2)));
    await cubit.load();
    expect(cubit.state.booking, result);
    expect(await cubit.cancel(), isTrue);
    expect(repository.saved, isNull);
  });

  test(
    'storage failure preserves selection and never confirms a save',
    () async {
      await cubit.load();
      cubit.seatTapped('Т2');
      repository.fail = true;
      expect(await cubit.book(), isNull);
      expect(cubit.state.booking, isNull);
      expect(cubit.state.selectedSeatId, 'Т2');
      expect(cubit.state.saveFailed, isTrue);
      expect(cubit.state.saving, isFalse);
    },
  );

  test('failed removal preserves the saved seat', () async {
    await cubit.load();
    cubit.seatTapped('Т2');
    final result = await cubit.book();
    repository.fail = true;
    expect(await cubit.cancel(), isFalse);
    expect(cubit.state.booking, result);
  });

  test('duplicate taps cannot queue a second save or change zones', () async {
    await cubit.load();
    cubit.seatTapped('Т2');
    repository.pending = Completer<void>();
    final operation = cubit.book();
    expect(cubit.state.saving, isTrue);
    expect(await cubit.book(), isNull);
    cubit.zoneChanged(CoworkZone.meeting);
    expect(cubit.state.zone, CoworkZone.quiet);
    repository.pending!.complete();
    await operation;
    expect(repository.saves, 1);
  });

  test('does not save before or after the local planning window', () async {
    await cubit.load();
    cubit.seatTapped('Т2');
    now = DateTime(2026, 9, 2, 7);
    expect(await cubit.book(), isNull);
    now = DateTime(2026, 9, 2, 22);
    expect(await cubit.book(), isNull);
    expect(repository.saves, 0);
  });

  test('extension is capped and expired plans cannot be extended', () async {
    now = DateTime(2026, 9, 2, 19, 30);
    await cubit.load();
    cubit.seatTapped('Т2');
    await cubit.book();
    await cubit.extend();
    expect(cubit.state.booking?.until, DateTime(2026, 9, 2, 22));
    expect(cubit.state.extendedUntil, isNull);
    now = DateTime(2026, 9, 3, 10);
    final saves = repository.saves;
    await cubit.extend();
    expect(repository.saves, saves);
  });

  test(
    'ignores invalid seat ids and clears selection on zone change',
    () async {
      await cubit.load();
      cubit.seatTapped('Т100');
      expect(cubit.state.selectedSeatId, isNull);
      cubit
        ..seatTapped('Т1')
        ..zoneChanged(CoworkZone.meeting);
      expect(cubit.state.selectedSeatId, isNull);
      expect(cubit.state.seats, hasLength(10));
    },
  );

  test('expired persisted plan is removed during load', () async {
    repository.saved = CoworkBooking(
      seatId: 'Т1',
      zone: CoworkZone.quiet,
      from: now.subtract(const Duration(hours: 3)),
      until: now.subtract(const Duration(hours: 1)),
    );
    await cubit.load();
    expect(cubit.state.booking, isNull);
    expect(repository.saved, isNull);
  });

  test('finishing a save after closing cannot emit state', () async {
    await cubit.load();
    cubit.seatTapped('Т1');
    repository.pending = Completer<void>();
    final operation = cubit.book();
    await cubit.close();
    repository.pending!.complete();
    expect(await operation, isNull);
  });
}
