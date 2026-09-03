import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/cowork/cubit/cowork_state.dart';
import 'package:rtu_mirea_app/cowork/data/cowork_repository.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';

export 'cowork_state.dart';

class CoworkCubit extends Cubit<CoworkState> {
  CoworkCubit({
    required this._repository,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const CoworkState()) {
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isClosed) emit(state.copyWith(now: _now()));
    });
  }

  final CoworkRepository _repository;
  final DateTime Function() _now;
  Timer? _clock;
  var _loadRevision = 0;

  Future<void> load() async {
    if (state.saving) return;
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading, now: _now()));
    try {
      var booking = await _repository.loadBooking();
      final now = _now();
      if (booking != null && !booking.isActive(now)) {
        booking = null;
        await _repository.saveBooking(null);
      }
      if (isClosed || revision != _loadRevision) return;
      emit(
        state.copyWith(
          status: .ready,
          booking: () => booking,
          selectedSeatId: () => null,
          zone: booking?.zone,
          now: now,
          saveFailed: false,
        ),
      );
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void zoneChanged(CoworkZone zone) {
    if (state.saving || zone == state.zone) return;
    emit(state.copyWith(zone: zone, selectedSeatId: () => null));
  }

  void seatTapped(String seatId) {
    if (state.saving ||
        state.hasBooking ||
        state.status != CoworkStatus.ready) {
      return;
    }
    final seat = state.seats.where((seat) => seat.id == seatId).firstOrNull;
    if (seat == null || !seat.isFree) return;
    emit(
      state.copyWith(
        selectedSeatId: () => state.selectedSeatId == seatId ? null : seatId,
        now: _now(),
        saveFailed: false,
      ),
    );
  }

  Future<CoworkBooking?> book() async {
    final seatId = state.selectedSeatId;
    final now = _now();
    final current = state.copyWith(now: now);
    if (seatId == null ||
        current.hasBooking ||
        !current.canPlan ||
        state.saving ||
        state.status != CoworkStatus.ready) {
      return null;
    }
    final booking = CoworkBooking(
      seatId: seatId,
      zone: state.zone,
      from: now,
      until: state.bookingUntil(now),
    );
    if (!booking.isValid) return null;
    return await _persist(booking) ? booking : null;
  }

  Future<void> extend() async {
    final current = state.copyWith(now: _now());
    final booking = current.activeBooking;
    final until = current.extendedUntil;
    if (booking == null || until == null || state.saving) return;
    await _persist(booking.copyWith(until: until));
  }

  Future<bool> cancel() => _persist(null);

  Future<bool> _persist(CoworkBooking? booking) async {
    if (state.saving || state.status != CoworkStatus.ready) return false;
    ++_loadRevision;
    emit(state.copyWith(saving: true, saveFailed: false));
    try {
      await _repository.saveBooking(booking);
      if (isClosed) return false;
      emit(
        state.copyWith(
          booking: () => booking,
          selectedSeatId: () => null,
          now: _now(),
          saving: false,
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(saving: false, saveFailed: true));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  @override
  Future<void> close() {
    _clock?.cancel();
    return super.close();
  }
}
