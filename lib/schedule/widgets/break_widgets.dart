import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:university_app_server_api/client.dart';

class ConsecutiveBreakWidget extends StatelessWidget {
  final List<LessonSchedulePart> currentLessons;
  final List<LessonSchedulePart> nextLessons;

  const ConsecutiveBreakWidget({
    super.key,
    required this.currentLessons,
    required this.nextLessons,
  });

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  @override
  Widget build(BuildContext context) {
    final currentMax = currentLessons.map((l) => _toMinutes(l.lessonBells.endTime)).reduce((a, b) => a > b ? a : b);
    final nextMin = nextLessons.map((l) => _toMinutes(l.lessonBells.startTime)).reduce((a, b) => a < b ? a : b);
    final breakDuration = nextMin - currentMax;
    final breakText = breakDuration > 0 ? '$breakDuration мин' : 'отсутствует';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).extension<AppColors>()!.deactiveDarker),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'Перерыв',
              style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
            ),
            const Spacer(),
            HugeIcon(
              icon: HugeIcons.strokeRoundedTime01,
              color: Theme.of(context).extension<AppColors>()!.deactive,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              breakText,
              style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowBreakWidget extends StatelessWidget {
  final int windowCount;

  const WindowBreakWidget({
    super.key,
    required this.windowCount,
  });

  String _pluralizeWindow(int count) {
    return Intl.plural(
      count,
      one: '$count пару',
      few: '$count пары',
      many: '$count пар',
      other: '$count пар',
    );
  }

  @override
  Widget build(BuildContext context) {
    final windowText = 'Окно в ${_pluralizeWindow(windowCount)}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).extension<AppColors>()!.divider),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            windowText,
            style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.deactive),
          ),
        ),
      ),
    );
  }
}
