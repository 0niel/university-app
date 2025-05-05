import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule/widgets/comparison_lessons_table.dart';
import 'package:university_app_server_api/client.dart';

class ComparisonStickyHeader extends StatelessWidget {
  const ComparisonStickyHeader({super.key, required this.day, required this.lessons, required this.schedules});

  final DateTime day;
  final List<SchedulePart> lessons;
  final List<SelectedSchedule> schedules;

  @override
  Widget build(BuildContext context) {
    // Pre-filter lessons to avoid doing it during build
    final lessonParts = lessons.whereType<LessonSchedulePart>().toList();

    return SliverStickyHeader(
      header: _DayHeader(day: day),
      sliver:
          lessonParts.isEmpty
              ? SliverToBoxAdapter(child: _EmptyDayIndicator())
              : SliverToBoxAdapter(
                child: ComparisonLessonsTable(day: day, schedules: schedules, lessonParts: lessonParts),
              ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, d MMMM', 'ru').format(day);

    return Container(
      color: Theme.of(context).extension<AppColors>()!.background01,
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(HugeIcons.strokeRoundedCalendar04, size: 17.5),
          const SizedBox(width: 8),
          Text(formattedDate, style: AppTextStyle.bodyBold),
        ],
      ),
    );
  }
}

class _EmptyDayIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 100,
      alignment: Alignment.center,
      child: Text(
        'Нет пар в этот день',
        style: AppTextStyle.body.copyWith(
          color: Theme.of(context).extension<AppColors>()!.active,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
