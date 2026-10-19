class LessonDayStatus {
  const LessonDayStatus({
    required this.past,
    required this.live,
    required this.progress,
    required this.minutesLeft,
  });

  final bool past;
  final bool live;
  final double? progress;
  final int minutesLeft;
}
