import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule/schedule.dart';
import 'package:wear/schedule/view/schedule_day_picker_button.dart';
import 'package:wear/schedule/view/schedule_lesson_card.dart';

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({
    required this.isAmbient,
    required this.scheduleName,
    required this.lessons,
    required this.currentDayIndex,
    required this.availableDays,
    super.key,
  });

  final bool isAmbient;
  final String scheduleName;
  final List<LessonSchedulePart> lessons;
  final int currentDayIndex;
  final List<DateTime> availableDays;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final isActive = !isAmbient;
    final targetDate = DateTime.now().add(Duration(days: currentDayIndex));
    final dateStr = DateFormat('EEE, d MMM', 'ru').format(targetDate);
    final isToday = currentDayIndex == 0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: isAmbient ? 12 : 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dateStr,
                        style: AppText.heading.copyWith(
                          color: isActive ? colors.active : colors.deactive,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isToday && isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          'Сегодня',
                          style: AppText.chip.copyWith(
                            color: colors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isActive)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ScheduleDayPickerButton(
                          currentDayIndex: currentDayIndex,
                          availableDays: availableDays,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  scheduleName,
                  style: AppText.caption.copyWith(
                    color: colors.deactive,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (lessons.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${lessons.length} ${_pluralizeLessons(lessons.length)}',
                    style: AppText.captionSmall.copyWith(
                      color: colors.deactiveDarker,
                      fontSize: 9,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (lessons.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 40,
                    color: colors.deactive.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Пар нет',
                    style: AppText.heading.copyWith(
                      color: colors.deactive,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Отдыхайте!',
                    style: AppText.caption.copyWith(
                      color: colors.deactiveDarker,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            sliver: SliverList.separated(
              itemCount: lessons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => ScheduleLessonCard(
                lesson: lessons[index],
                isAmbient: isAmbient,
              ),
            ),
          ),
      ],
    );
  }
}

String _pluralizeLessons(int count) {
  if (count % 10 == 1 && count % 100 != 11) return 'пара';
  if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) {
    return 'пары';
  }
  return 'пар';
}
