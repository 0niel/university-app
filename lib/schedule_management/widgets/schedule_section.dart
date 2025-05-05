import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:rtu_mirea_app/search/search.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleSection<T> extends StatelessWidget {
  final String title;
  final List<(String, T, List<SchedulePart>)> schedules;
  final ScheduleState state;
  final String scheduleType;

  const ScheduleSection({
    super.key,
    required this.title,
    required this.schedules,
    required this.state,
    required this.scheduleType,
  });

  @override
  Widget build(BuildContext context) {
    if (schedules.isEmpty) {
      return Animate(
        effects: const [FadeEffect(duration: Duration(milliseconds: 400))],
        child: _buildEmptyState(context),
      );
    }

    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 400)),
        SlideEffect(begin: Offset(0, 0.1), end: Offset.zero, duration: Duration(milliseconds: 400)),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchHeadlineText(headerText: title),
          const SizedBox(height: 12),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: schedules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ScheduleCard(
                schedule: schedule,
                state: state,
                scheduleType: scheduleType,
              ).animate(delay: (50 * index).milliseconds).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchHeadlineText(headerText: title),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
          ),
          child: Center(
            child: Text(
              'Нет доступных расписаний',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
