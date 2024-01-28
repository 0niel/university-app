import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class EmptyLessonCard extends StatelessWidget {
  final int lessonNumber;

  const EmptyLessonCard({
    Key? key,
    required this.lessonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.colorsOf(context).background03
          : AppTheme.colorsOf(context).background02,
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
              style: AppTextStyle.body.copyWith(color: AppTheme.colorsOf(context).colorful03),
            ),
          ],
        ),
      ),
    );
  }
}
