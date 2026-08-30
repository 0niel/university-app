enum ScheduleTargetType {
  group('group'),
  teacher('teacher'),
  classroom('classroom');

  const ScheduleTargetType(this.wireValue);

  final String wireValue;
}
