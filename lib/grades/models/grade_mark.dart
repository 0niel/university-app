import 'package:equatable/equatable.dart';

class GradeMark extends Equatable {
  const GradeMark({required this.value, required this.date});

  factory GradeMark.fromJson(Map<String, dynamic> json) => GradeMark(
    value: json['value'] as int,
    date: DateTime.parse(json['date'] as String),
  );

  final int value;
  final DateTime date;

  Map<String, dynamic> toJson() => {
    'value': value,
    'date': date.toIso8601String(),
  };

  @override
  List<Object?> get props => [value, date];
}
