import 'package:equatable/equatable.dart';

class TimeOfDay extends Equatable {
  const TimeOfDay({required this.hour, required this.minute});

  factory TimeOfDay.fromString(String time) {
    final match = RegExp(r'^(\d{1,2}):(\d{1,2})$').firstMatch(time);
    final hour = match?.group(1);
    final minute = match?.group(2);
    if (hour == null || minute == null) {
      throw FormatException('Invalid time: $time');
    }
    return TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
  }

  final int hour;

  final int minute;

  @override
  String toString() {
    final hourString = hour < 10 ? '0$hour' : '$hour';
    final minuteString = minute < 10 ? '0$minute' : '$minute';
    return '$hourString:$minuteString';
  }

  @override
  List<Object?> get props => [hour, minute];

  @override
  bool get stringify => true;

  bool operator <(TimeOfDay other) => _minutes < other._minutes;

  bool operator >(TimeOfDay other) => _minutes > other._minutes;

  int get _minutes => hour * 60 + minute;
}
