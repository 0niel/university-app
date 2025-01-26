import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class EmptyLessonCard extends StatelessWidget {
  final int lessonNumber;

  const EmptyLessonCard({
    super.key,
    required this.lessonNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).extension<AppColors>()!.background03
          : Theme.of(context).extension<AppColors>()!.background02,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Text(
              '$lessonNumber пара',
              style: AppTextStyle.body.copyWith(color: Theme.of(context).extension<AppColors>()!.colorful03),
            ),
          ],
        ),
      ),
    );
  }
}
