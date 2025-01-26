import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class ComparisonStickyHeader extends StatelessWidget {
  const ComparisonStickyHeader({
    super.key,
    required this.day,
    required this.lessons,
    required this.schedules,
  });

  final DateTime day;
  final List<SchedulePart> lessons;
  final List<SelectedSchedule> schedules;

  @override
  Widget build(BuildContext context) {
    final lessonParts = lessons.whereType<LessonSchedulePart>().toList();

    return SliverStickyHeader(
      header: _DayHeader(day: day),
      sliver: lessonParts.isEmpty
          ? SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  'Пар нет',
                  style: AppTextStyle.body.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.active,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : SliverToBoxAdapter(
              child: ComparisonLessonsTable(
                day: day,
                schedules: schedules,
                lessonParts: lessonParts,
              ),
            ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.day,
  });

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).extension<AppColors>()!.background01,
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            HugeIcons.strokeRoundedCalendar04,
            size: 17.5,
          ),
          const SizedBox(width: 8),
          Text(
            DateFormat('EEEE, d MMMM', 'ru').format(day),
            style: AppTextStyle.bodyBold,
          ),
        ],
      ),
    );
  }
}
