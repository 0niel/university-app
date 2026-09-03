import 'package:equatable/equatable.dart';

enum AbsenceReason { sick, noReason }

class Absence extends Equatable {
  const Absence({
    required this.id,
    required this.subject,
    required this.date,
    required this.reason,
  });

  factory Absence.fromJson(Map<String, dynamic> json) => Absence(
    id: json['id'] as String,
    subject: json['subject'] as String,
    date: DateTime.parse(json['date'] as String),
    reason: AbsenceReason.values.byName(json['reason'] as String),
  );

  final String id;
  final String subject;
  final DateTime date;
  final AbsenceReason reason;

  DateTime get day => DateTime(date.year, date.month, date.day);

  bool get isUnexcused => reason == AbsenceReason.noReason;

  Absence copyWith({AbsenceReason? reason}) => Absence(
    id: id,
    subject: subject,
    date: date,
    reason: reason ?? this.reason,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'date': date.toIso8601String(),
    'reason': reason.name,
  };

  @override
  List<Object?> get props => [id, subject, date, reason];
}
