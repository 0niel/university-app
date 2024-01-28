import 'package:equatable/equatable.dart';

/// {@template time_of_day}
/// A representation of time of day.
/// {@endtemplate}
class TimeOfDay extends Equatable {
  /// {@macro time_of_day}
  const TimeOfDay({required this.hour, required this.minute});

  /// Converts a [String] into a [TimeOfDay] instance.
  factory TimeOfDay.fromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// Hour of the time-of-day representation.
  final int hour;

  /// Minute of the time-of-day representation.
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

  // ignore: public_member_api_docs
  bool operator <(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      if (minute < other.minute) {
        return true;
      }
    }
    return false;
  }

  // ignore: public_member_api_docs
  bool operator >(TimeOfDay other) {
    if (hour > other.hour) {
      return true;
    } else if (hour == other.hour) {
      if (minute > other.minute) {
        return true;
      }
    }
    return false;
  }
}
