import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'wireValue')
enum ScheduleChangeKind {
  add('add'),
  cancel('cancel'),
  move('move'),
  room('room'),
  teacher('teacher');

  const ScheduleChangeKind(this.wireValue);

  final String wireValue;

  static ScheduleChangeKind fromWireValue(String value) {
    return ScheduleChangeKind.values.firstWhere(
      (kind) => kind.wireValue == value,
      orElse: () => ScheduleChangeKind.move,
    );
  }
}
