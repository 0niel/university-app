part of 'room_booking_cubit.dart';

@freezed
abstract class RoomBooking with _$RoomBooking {
  const factory RoomBooking({
    required String room,
    required DateTime until,
    String? campus,
  }) = _RoomBooking;
}

@freezed
abstract class RoomBookingState with _$RoomBookingState {
  const factory RoomBookingState({RoomBooking? booking}) = _RoomBookingState;

  const RoomBookingState._();

  RoomBooking? activeAt(DateTime now) {
    final current = booking;
    if (current == null || !current.until.isAfter(now)) return null;
    return current;
  }

  bool isBooked(String room, DateTime now, {String? campus}) {
    final active = activeAt(now);
    return active != null &&
        roomKey(active.room) == roomKey(room) &&
        campusKey(active.campus ?? '') == campusKey(campus ?? '');
  }
}
