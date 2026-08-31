import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'wireValue')
enum DeadlinePriority {
  low('low'),
  medium('medium'),
  urgent('urgent');

  const DeadlinePriority(this.wireValue);

  final String wireValue;

  static DeadlinePriority fromWire(String? value) {
    for (final priority in values) {
      if (priority.wireValue == value) return priority;
    }
    return medium;
  }
}
