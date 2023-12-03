import 'package:equatable/equatable.dart';

/// {@template time_of_day}
/// A representation of time of day.
/// {@endtemplate}
class TimeOfDay extends Equatable {
  /// {@macro time_of_day}
  const TimeOfDay({required this.hour, required this.minute});

  /// Hour of the time-of-day representation.
  final int hour;

  /// Minute of the time-of-day representation.
  final int minute;

  @override
  String toString() {
    return '$hour:$minute';
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
