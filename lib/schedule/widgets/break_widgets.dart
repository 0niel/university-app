import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:university_app_server_api/client.dart';

class ConsecutiveBreakWidget extends StatelessWidget {
  final List<LessonSchedulePart> currentLessons;
  final List<LessonSchedulePart> nextLessons;

  const ConsecutiveBreakWidget({super.key, required this.currentLessons, required this.nextLessons});

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  Widget _buildContent(String breakText) {
    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>()!;

        return Row(
          children: [
            Text(
              'Перерыв',
              style: AppTextStyle.captionL.copyWith(color: colors.deactive.withAlpha(150), fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(breakText, style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w600)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMax = currentLessons.map((l) => _toMinutes(l.lessonBells.endTime)).reduce((a, b) => a > b ? a : b);
    final nextMin = nextLessons.map((l) => _toMinutes(l.lessonBells.startTime)).reduce((a, b) => a < b ? a : b);
    final breakDuration = nextMin - currentMax;
    final breakText = breakDuration > 0 ? '$breakDuration мин' : 'отсутствует';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: _buildContent(breakText),
    );
  }
}

class WindowBreakWidget extends StatelessWidget {
  final int windowCount;

  const WindowBreakWidget({super.key, required this.windowCount});

  String _pluralizeWindow(int count) {
    return Intl.plural(count, one: '$count пару', few: '$count пары', many: '$count пар', other: '$count пар');
  }

  @override
  Widget build(BuildContext context) {
    final windowText = _pluralizeWindow(windowCount);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(icon: HugeIcons.strokeRoundedCalendar02, size: 16, color: colors.deactive),
              const SizedBox(width: 6),
              Text(
                'Окно в $windowText',
                style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
