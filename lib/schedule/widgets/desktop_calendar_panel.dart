import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/format_toggle.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:university_app_server_api/client.dart';

class DesktopCalendarPanel extends StatelessWidget {
  final PageController pageController;
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;
  final List<SchedulePart> schedule;
  final List<LessonComment> comments;
  final bool showCommentsIndicators;

  const DesktopCalendarPanel({
    super.key,
    required this.pageController,
    required this.calendarFormat,
    required this.onFormatChanged,
    required this.isStoriesVisible,
    required this.onStoriesLoaded,
    required this.schedule,
    required this.comments,
    required this.showCommentsIndicators,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final currentDay = Calendar.firstCalendarDay.add(Duration(days: pageController.initialPage));

    return Container(
      decoration: BoxDecoration(color: colors.surface, border: Border(right: BorderSide(color: colors.background03))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stories placeholder
          CalendarStoriesWrapper(isStoriesVisible: isStoriesVisible, onStoriesLoaded: onStoriesLoaded),

          // Calendar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Calendar(
                    pageViewController: pageController,
                    schedule: schedule,
                    comments: comments,
                    showCommentsIndicators: showCommentsIndicators,
                    calendarFormat: calendarFormat,
                    canChangeFormat: true,
                  ),

                  // Format toggle
                  const SizedBox(height: 16),
                  CalendarFormatToggle(currentFormat: calendarFormat, onFormatChanged: onFormatChanged),

                  // Today's statistics
                  const SizedBox(height: 32),
                  _buildTodayStatistics(context),

                  // Calendar legend
                  const SizedBox(height: 32),
                  _buildCalendarLegend(context),

                  // Additional spacing at bottom
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(BuildContext context, DateTime day) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final month = DateFormat.MMMM('ru_RU').format(day);
    final year = day.year.toString();

    return Container(
      color: colors.background02.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Month and year
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month[0].toUpperCase() + month.substring(1),
                  style: AppTextStyle.bodyL.copyWith(fontWeight: FontWeight.w600, color: colors.active),
                ),
                Text(year, style: AppTextStyle.captionL.copyWith(color: colors.deactive, fontWeight: FontWeight.w500)),
              ],
            ),
          ),

          // Navigation buttons
          Row(
            children: [
              _buildNavButton(
                context,
                icon: HugeIcons.strokeRoundedArrowLeft01,
                onPressed: () {
                  final prevMonth = DateTime(day.year, day.month - 1, 1);
                  final prevPage = Calendar.getPageIndex(prevMonth);
                  pageController.animateToPage(
                    prevPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                context,
                icon: HugeIcons.strokeRoundedArrowRight01,
                onPressed: () {
                  final nextMonth = DateTime(day.year, day.month + 1, 1);
                  final nextPage = Calendar.getPageIndex(nextMonth);
                  pageController.animateToPage(
                    nextPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: colors.background03.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
        child: Center(child: HugeIcon(icon: icon, size: 16, color: colors.active)),
      ),
    );
  }

  Widget _buildTodayStatistics(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final todayLessons =
        Calendar.getSchedulePartsByDay(
          schedule: schedule,
          day: DateTime.now(),
        ).whereType<LessonSchedulePart>().toList();

    final lectureCount = todayLessons.where((l) => l.lessonType == LessonType.lecture).length;
    final practiceCount = todayLessons.where((l) => l.lessonType == LessonType.practice).length;
    final labCount = todayLessons.where((l) => l.lessonType == LessonType.laboratoryWork).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Сегодня',
            style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.w600, color: colors.active),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colors.background02.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _buildStatItem(
                    context,
                    count: todayLessons.length,
                    label: 'Всего',
                    icon: HugeIcons.strokeRoundedClock01,
                    color: colors.colorful04,
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    context,
                    count: lectureCount,
                    label: 'Лекции',
                    icon: HugeIcons.strokeRoundedPresentation01,
                    color: colors.colorful01,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatItem(
                    context,
                    count: practiceCount,
                    label: 'Практ.',
                    icon: HugeIcons.strokeRoundedBook03,
                    color: colors.colorful03,
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    context,
                    count: labCount,
                    label: 'Лаб.',
                    icon: HugeIcons.strokeRoundedGivePill,
                    color: colors.colorful02,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required int count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.background03, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Center(child: HugeIcon(icon: icon, size: 16, color: color)),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count', style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.bold, color: colors.active)),
                Text(label, style: AppTextStyle.captionS.copyWith(color: colors.deactive)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarLegend(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Обозначения', style: AppTextStyle.body.copyWith(color: colors.active, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.background03.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildLegendItem(context, 'Лекция', colors.colorful01),
                const SizedBox(height: 8),
                _buildLegendItem(context, 'Практика', colors.colorful03),
                const SizedBox(height: 8),
                _buildLegendItem(context, 'Лабораторная', colors.colorful02),
                const SizedBox(height: 8),
                _buildLegendItem(context, 'Экзамен', colors.colorful06),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String text, Color color) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyle.captionL.copyWith(color: colors.deactive)),
      ],
    );
  }
}
