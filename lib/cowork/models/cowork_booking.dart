import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/cowork/models/cowork_zone.dart';

class CoworkBooking extends Equatable {
  const CoworkBooking({
    required this.seatId,
    required this.zone,
    required this.from,
    required this.until,
  });

  factory CoworkBooking.fromJson(Map<String, dynamic> json) => CoworkBooking(
    seatId: json['seatId'] as String,
    zone: CoworkZone.values.byName(json['zone'] as String),
    from: DateTime.parse(json['from'] as String),
    until: DateTime.parse(json['until'] as String),
  );

  final String seatId;
  final CoworkZone zone;
  final DateTime from;
  final DateTime until;

  bool isActive(DateTime now) =>
      !from.isAfter(now) && until.isAfter(now) && isValid;

  bool get isValid =>
      until.isAfter(from) &&
      List.generate(
        zone.capacity,
        (index) => zone.seatId(index + 1),
      ).contains(seatId);

  CoworkBooking copyWith({DateTime? until}) => CoworkBooking(
    seatId: seatId,
    zone: zone,
    from: from,
    until: until ?? this.until,
  );

  Map<String, dynamic> toJson() => {
    'seatId': seatId,
    'zone': zone.name,
    'from': from.toIso8601String(),
    'until': until.toIso8601String(),
  };

  @override
  List<Object?> get props => [seatId, zone, from, until];
}
