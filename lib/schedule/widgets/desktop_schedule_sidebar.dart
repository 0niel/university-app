import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/widgets/calendar/format_toggle.dart';
import 'package:rtu_mirea_app/schedule/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class DesktopScheduleSidebar extends StatelessWidget {
  const DesktopScheduleSidebar({
    super.key,
    required this.pageController,
    required this.calendarFormat,
    required this.onFormatChanged,
    required this.isStoriesVisible,
    required this.onStoriesLoaded,
  });

  final PageController pageController;
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final bool isStoriesVisible;
  final ValueChanged<bool> onStoriesLoaded;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScheduleBloc>().state;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [BoxShadow(color: colors.background03.withOpacity(0.5), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Calendar section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Calendar stories using the wrapper instead of sliver
                  CalendarStoriesWrapper(isStoriesVisible: isStoriesVisible, onStoriesLoaded: onStoriesLoaded),

                  // Calendar
                  Calendar(
                    pageViewController: pageController,
                    schedule: state.selectedSchedule?.schedule ?? [],
                    comments: state.comments,
                    showCommentsIndicators: state.showCommentsIndicators,
                    calendarFormat: calendarFormat,
                    canChangeFormat: true,
                  ),

                  // Format toggle
                  const SizedBox(height: 8),
                  CalendarFormatToggle(currentFormat: calendarFormat, onFormatChanged: onFormatChanged),
                ],
              ),
            ),
          ),

          // Settings panel
          _buildSettingsPanel(context),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel(BuildContext context) {
    final state = context.watch<ScheduleBloc>().state;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background02.withOpacity(0.3),
        border: Border(top: BorderSide(color: colors.background03, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Настройки отображения',
            style: AppTextStyle.captionL.copyWith(
              color: colors.deactive,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsSwitch(
            context,
            title: 'Показывать пустые пары',
            value: state.showEmptyLessons,
            onChanged: (value) {
              context.read<ScheduleBloc>().add(ScheduleSetEmptyLessonsDisplaying(showEmptyLessons: value));
            },
          ),
          _buildSettingsSwitch(
            context,
            title: 'Показывать индикаторы комментариев',
            value: state.showCommentsIndicators,
            onChanged: (value) {
              context.read<ScheduleBloc>().add(SetShowCommentsIndicator(showCommentsIndicators: value));
            },
          ),
          _buildSettingsSwitch(
            context,
            title: 'Компактный режим карточек',
            value: state.isMiniature,
            onChanged: (value) {
              context.read<ScheduleBloc>().add(ScheduleSetDisplayMode(isMiniature: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSwitch(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.body.copyWith(color: colors.active)),
          Switch.adaptive(value: value, activeColor: colors.primary, onChanged: onChanged),
        ],
      ),
    );
  }
}
