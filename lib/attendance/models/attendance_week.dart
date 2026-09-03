import 'package:equatable/equatable.dart';

class AttendanceWeek extends Equatable {
  const AttendanceWeek({
    required this.index,
    required this.total,
    required this.misses,
    this.isCurrent = false,
  });

  final int index;
  final int total;
  final int misses;
  final bool isCurrent;

  double? get ratio =>
      total == 0 ? null : ((total - misses) / total).clamp(0, 1).toDouble();

  @override
  List<Object?> get props => [index, total, misses, isCurrent];
}
