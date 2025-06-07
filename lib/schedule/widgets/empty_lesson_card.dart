import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class EmptyLessonCard extends StatelessWidget {
  final int lessonNumber;

  const EmptyLessonCard({super.key, required this.lessonNumber});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Card(
      margin: const EdgeInsets.all(0),
      color: Theme.of(context).extension<AppColors>()!.surface.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).extension<AppColors>()!.background03.withOpacity(0.3), width: 1),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: EdgeInsets.symmetric(vertical: isDesktop ? 10 : 12, horizontal: isDesktop ? 12 : 16),
        child: Row(
          children: [
            Text(
              '$lessonNumber пара',
              style: AppTextStyle.captionL.copyWith(
                color: Theme.of(context).extension<AppColors>()!.deactive.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'Свободно',
              style: AppTextStyle.captionL.copyWith(
                color: Theme.of(context).extension<AppColors>()!.deactive.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
