final class LessonBellSlotConfig {
  const LessonBellSlotConfig({
    required this.startMinutes,
    required this.endMinutes,
  });

  final int startMinutes;
  final int endMinutes;

  int get startHour => startMinutes ~/ Duration.minutesPerHour;
  int get startMinute => startMinutes % Duration.minutesPerHour;
  int get endHour => endMinutes ~/ Duration.minutesPerHour;
  int get endMinute => endMinutes % Duration.minutesPerHour;

  String get label => _formatMinutes(startMinutes);

  static String _formatMinutes(int minutes) {
    final hour = (minutes ~/ Duration.minutesPerHour).toString().padLeft(
      2,
      '0',
    );
    final minute = (minutes % Duration.minutesPerHour).toString().padLeft(
      2,
      '0',
    );
    return '$hour:$minute';
  }
}
