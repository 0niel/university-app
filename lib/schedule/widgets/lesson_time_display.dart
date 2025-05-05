import 'package:flutter/material.dart';
import 'package:university_app_server_api/client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';

/// A safe wrapper for displaying lesson time that handles potential null values
class LessonTimeDisplay extends StatelessWidget {
  const LessonTimeDisplay({super.key, required this.lessonBells, this.color, this.showIcon = true});

  final LessonBells lessonBells;
  final Color? color;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    // Safely handle null values
    final startTime = lessonBells.startTime;
    final endTime = lessonBells.endTime;

    final textColor = color ?? Theme.of(context).extension<AppColors>()!.active;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: textColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            '$startTime - $endTime', // Safe to use now as we've checked for null
            style: AppTextStyle.captionL.copyWith(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
