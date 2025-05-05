import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class DesktopAppBar extends StatelessWidget {
  final String title;
  final String scheduleType;
  final DateTime selectedDay;
  final VoidCallback onTodayPressed;
  final VoidCallback? onWeekSelectPressed;
  final VoidCallback? onPreviousDay;
  final VoidCallback? onNextDay;
  final VoidCallback? onSelectSchedule;
  final VoidCallback? onRefreshData;

  const DesktopAppBar({
    super.key,
    required this.title,
    required this.scheduleType,
    required this.selectedDay,
    required this.onTodayPressed,
    this.onWeekSelectPressed,
    this.onPreviousDay,
    this.onNextDay,
    this.onSelectSchedule,
    this.onRefreshData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isToday = _isToday(selectedDay);
    final weekNumber = _getWeekNumber(selectedDay);
    final formattedDate = DateFormat('d MMMM yyyy', 'ru_RU').format(selectedDay);
    final state = context.watch<ScheduleBloc>().state;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.background03)),
        boxShadow: [BoxShadow(color: colors.background03.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Schedule info with icon and select button
          _buildScheduleInfo(context, state.selectedSchedule),

          const SizedBox(width: 16),
          // Selected date display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colors.background03.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              formattedDate,
              style: AppTextStyle.body.copyWith(color: colors.deactive, fontWeight: FontWeight.w500),
            ),
          ),

          const Spacer(),

          // Action buttons
          _buildActionButtons(context, state),

          const SizedBox(width: 16),

          // Week indicator with button to select week
          GestureDetector(
            onTap: onWeekSelectPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.background02,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.background03),
              ),
              child: Row(
                children: [
                  Icon(HugeIcons.strokeRoundedCalendar04, size: 18, color: colors.colorful04),
                  const SizedBox(width: 8),
                  Text(
                    '$weekNumber неделя',
                    style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w500, color: colors.active),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: colors.deactive),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Navigation buttons
          Row(
            children: [
              _buildNavButton(
                context,
                icon: HugeIcons.strokeRoundedArrowLeft01,
                tooltip: 'Предыдущий день',
                onPressed: onPreviousDay ?? () {},
              ),
              const SizedBox(width: 8),
              _buildNavButton(
                context,
                icon: HugeIcons.strokeRoundedArrowRight01,
                tooltip: 'Следующий день',
                onPressed: onNextDay ?? () {},
              ),
              const SizedBox(width: 16),

              // Today button
              TextButton.icon(
                onPressed: isToday ? null : onTodayPressed,
                style: TextButton.styleFrom(
                  backgroundColor: isToday ? colors.background03.withOpacity(0.3) : colors.primary.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar04,
                  color: isToday ? colors.deactive : colors.primary,
                  size: 16,
                ),
                label: Text(
                  'Сегодня',
                  style: AppTextStyle.captionL.copyWith(
                    color: isToday ? colors.deactive : colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleInfo(BuildContext context, SelectedSchedule? selectedSchedule) {
    final colors = Theme.of(context).extension<AppColors>()!;

    Color avatarColor;
    IconData avatarIcon;

    if (selectedSchedule is SelectedGroupSchedule) {
      avatarColor = colors.colorful01;
      avatarIcon = HugeIcons.strokeRoundedUserGroup;
    } else if (selectedSchedule is SelectedTeacherSchedule) {
      avatarColor = colors.colorful02;
      avatarIcon = HugeIcons.strokeRoundedTeacher;
    } else {
      avatarColor = colors.colorful03;
      avatarIcon = HugeIcons.strokeRoundedBuilding04;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onSelectSchedule,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: avatarColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Center(child: HugeIcon(icon: avatarIcon, size: 18, color: avatarColor)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: AppTextStyle.titleS.copyWith(fontWeight: FontWeight.bold, color: colors.active)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.background03.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(scheduleType, style: AppTextStyle.captionS.copyWith(color: colors.deactive)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ScheduleState state) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        // Refresh button
        _buildActionIconButton(
          context,
          icon: HugeIcons.strokeRoundedRefresh,
          tooltip: 'Обновить данные',
          onPressed: onRefreshData,
        ),

        const SizedBox(width: 8),

        // Compare schedules
        _buildActionIconButton(
          context,
          icon: HugeIcons.strokeRoundedGitCompare,
          tooltip: 'Сравнение расписаний',
          onPressed: () => context.read<ScheduleBloc>().add(const ToggleComparisonMode()),
          isActive: state.isComparisonModeEnabled,
        ),

        const SizedBox(width: 8),

        // Analytics
        _buildActionIconButton(
          context,
          icon: HugeIcons.strokeRoundedChart,
          tooltip: 'Аналитика расписания',
          onPressed:
              () => context.read<ScheduleBloc>().add(SetAnalyticsVisibility(showAnalytics: !state.showAnalytics)),
          isActive: state.showAnalytics,
        ),

        const SizedBox(width: 8),

        // List mode
        _buildActionIconButton(
          context,
          icon: HugeIcons.strokeRoundedListView,
          tooltip: 'Список всех пар',
          onPressed: () => context.read<ScheduleBloc>().add(const ToggleListMode()),
          isActive: state.isListModeEnabled,
        ),
      ],
    );
  }

  Widget _buildActionIconButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
    bool isActive = false,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isActive ? colors.primary.withOpacity(0.1) : colors.background02,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isActive ? colors.primary.withOpacity(0.3) : colors.background03),
            ),
            child: Center(child: HugeIcon(icon: icon, size: 18, color: isActive ? colors.primary : colors.active)),
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  int _getWeekNumber(DateTime date) {
    // Simple approach - can be replaced with your actual week calculation logic
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays;
    return (dayOfYear / 7).ceil() % 52 + 1;
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.background02,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.background03),
            ),
            child: Center(child: HugeIcon(icon: icon, size: 18, color: colors.active)),
          ),
        ),
      ),
    );
  }
}
