import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_lesson_card_skeleton.dart';

class ScheduleLessonCardsSkeleton extends StatelessWidget {
  const ScheduleLessonCardsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .only(top: 6, bottom: 84),
      child: Column(
        children: [
          ScheduleLessonCardSkeleton(titleLines: 2),
          ScheduleLessonCardSkeleton(),
          ScheduleLessonCardSkeleton(),
        ],
      ),
    );
  }
}
