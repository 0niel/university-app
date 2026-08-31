part of '../schedule_details_page.dart';

class _LessonRuntime {
  const _LessonRuntime({
    required this.live,
    required this.past,
    required this.progress,
  });

  final bool live;
  final bool past;
  final double progress;
}
