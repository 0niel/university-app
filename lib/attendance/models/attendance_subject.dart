import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/attendance/models/absence.dart';

class AttendanceSubject extends Equatable {
  const AttendanceSubject({
    required this.subject,
    required this.total,
    this.misses = const [],
  });

  static const riskThreshold = 70;

  final String subject;
  final int total;
  final List<Absence> misses;

  int get attended => math.max(0, total - misses.length);

  int get percent => total == 0
      ? (misses.isEmpty ? 100 : 0)
      : (attended / total * 100).round();

  bool get isRisk => total > 0 && percent < riskThreshold;

  int get unexcusedCount => misses.where((miss) => miss.isUnexcused).length;

  @override
  List<Object?> get props => [subject, total, misses];
}
