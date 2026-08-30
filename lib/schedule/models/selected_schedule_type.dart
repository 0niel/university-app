enum SelectedScheduleType {
  group,
  teacher,
  classroom,
  custom;

  static SelectedScheduleType parse(Object? value) => switch (value) {
    'group' => .group,
    'teacher' => .teacher,
    'classroom' => .classroom,
    'custom' => .custom,
    _ => throw FormatException('Unknown selected schedule type', value),
  };
}
