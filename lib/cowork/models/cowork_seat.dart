import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/cowork/models/cowork_zone.dart';

enum CoworkSeatStatus { unknown, mine }

class CoworkSeat extends Equatable {
  const CoworkSeat({
    required this.zone,
    required this.number,
    required this.status,
  });

  final CoworkZone zone;
  final int number;
  final CoworkSeatStatus status;

  String get id => zone.seatId(number);

  bool get isFree => status == CoworkSeatStatus.unknown;

  @override
  List<Object?> get props => [zone, number, status];
}
