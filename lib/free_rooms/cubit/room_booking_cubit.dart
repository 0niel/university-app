import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_filter.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';

part 'room_booking_cubit.freezed.dart';
part 'room_booking_state.dart';

class RoomBookingCubit extends HydratedCubit<RoomBookingState> {
  RoomBookingCubit({Storage? storage, DateTime Function()? now})
    : _storage = storage ?? HydratedBloc.storage,
      _now = now ?? DateTime.now,
      super(const RoomBookingState(), storage: storage);

  final Storage _storage;
  final DateTime Function() _now;
  bool _saving = false;

  @override
  String get storagePrefix => 'RoomBookingCubit';

  Future<bool> book(RoomBooking booking) async {
    if (booking.room.trim().isEmpty || !booking.until.isAfter(_now())) {
      return false;
    }
    return _persist(RoomBookingState(booking: booking));
  }

  Future<bool> release() => _persist(const RoomBookingState());

  Future<bool> _persist(RoomBookingState next) async {
    if (_saving || isClosed) return false;
    _saving = true;
    try {
      await _storage.write(storageToken, toJson(next));
      if (isClosed) return false;
      emit(next);
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
      return false;
    } finally {
      _saving = false;
    }
  }

  @override
  RoomBookingState? fromJson(Map<String, dynamic> json) {
    final room = json['room'];
    final until = json['until'];
    if (room is! String || until is! String) return const RoomBookingState();
    final parsed = DateTime.tryParse(until);
    if (parsed == null || room.trim().isEmpty) return const RoomBookingState();
    return RoomBookingState(
      booking: RoomBooking(
        room: room,
        until: parsed,
        campus: json['campus'] is String ? json['campus'] as String : null,
      ),
    );
  }

  @override
  Map<String, dynamic>? toJson(RoomBookingState state) {
    final booking = state.booking;
    if (booking == null) return {};
    return {
      'room': booking.room,
      'until': booking.until.toIso8601String(),
      if (booking.campus != null) 'campus': booking.campus,
    };
  }
}
