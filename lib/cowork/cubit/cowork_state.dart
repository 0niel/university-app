import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/cowork/models/models.dart';

enum CoworkStatus { initial, loading, ready, failure }

class CoworkState extends Equatable {
  const CoworkState({
    this.status = CoworkStatus.initial,
    this.zone = CoworkZone.quiet,
    this.selectedSeatId,
    this.booking,
    this.friendsHere = const [],
    this.now,
    this.saving = false,
    this.saveFailed = false,
  });

  static const closingHour = 22;
  static const bookingLength = Duration(hours: 2);
  static const extensionLength = Duration(hours: 1);

  final CoworkStatus status;
  final CoworkZone zone;
  final String? selectedSeatId;
  final CoworkBooking? booking;
  final List<String> friendsHere;
  final DateTime? now;
  final bool saving;
  final bool saveFailed;

  DateTime get current => now ?? DateTime.now();

  CoworkBooking? get activeBooking {
    final booking = this.booking;
    return booking != null && booking.isActive(current) ? booking : null;
  }

  bool get hasBooking => activeBooking != null;

  bool get canPlan => current.hour >= 8 && current.hour < closingHour;

  DateTime closingAt(DateTime date) =>
      DateTime(date.year, date.month, date.day, closingHour);

  DateTime bookingUntil(DateTime from) {
    final until = from.add(bookingLength);
    final closing = closingAt(from);
    return until.isAfter(closing) ? closing : until;
  }

  DateTime? get extendedUntil {
    final booking = activeBooking;
    if (booking == null) return null;
    final closing = closingAt(booking.from);
    if (!booking.until.isBefore(closing)) return null;
    final until = booking.until.add(extensionLength);
    return until.isAfter(closing) ? closing : until;
  }

  List<CoworkSeat> get seats => [
    for (var number = 1; number <= zone.capacity; number++)
      CoworkSeat(
        zone: zone,
        number: number,
        status: activeBooking?.seatId == zone.seatId(number)
            ? CoworkSeatStatus.mine
            : CoworkSeatStatus.unknown,
      ),
  ];

  CoworkState copyWith({
    CoworkStatus? status,
    CoworkZone? zone,
    String? Function()? selectedSeatId,
    CoworkBooking? Function()? booking,
    List<String>? friendsHere,
    DateTime? now,
    bool? saving,
    bool? saveFailed,
  }) => CoworkState(
    status: status ?? this.status,
    zone: zone ?? this.zone,
    selectedSeatId: selectedSeatId == null
        ? this.selectedSeatId
        : selectedSeatId(),
    booking: booking == null ? this.booking : booking(),
    friendsHere: friendsHere ?? this.friendsHere,
    now: now ?? this.now,
    saving: saving ?? this.saving,
    saveFailed: saveFailed ?? this.saveFailed,
  );

  @override
  List<Object?> get props => [
    status,
    zone,
    selectedSeatId,
    booking,
    friendsHere,
    now,
    saving,
    saveFailed,
  ];
}
