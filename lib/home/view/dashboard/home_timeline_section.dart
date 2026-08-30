import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_bell_time.dart';
import 'package:rtu_mirea_app/home/view/home_empty_row.dart';
import 'package:rtu_mirea_app/home/view/home_section_header.dart';
import 'package:rtu_mirea_app/home/view/home_section_list.dart';
import 'package:rtu_mirea_app/home/view/home_timeline_skeleton.dart';
import 'package:rtu_mirea_app/home/view/home_today_row.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeTimelineSection extends StatelessWidget {
  const HomeTimelineSection({
    required this.title,
    required this.loading,
    required this.lessons,
    required this.day,
    required this.now,
    super.key,
  });

  final String title;
  final bool loading;
  final List<LessonSchedulePart> lessons;
  final DateTime day;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        HomeSectionHeader(
          title: title,
          action: l10n.all.toLowerCase(),
          onAction: () => context.go('/schedule'),
        ),
        NinjaStateSwitcher(child: _content(context)),
      ],
    );
  }

  Widget _content(BuildContext context) {
    if (loading) {
      return const HomeSectionList(
        key: ValueKey('home-timeline-loading'),
        children: [HomeTimelineSkeleton()],
      );
    }
    if (lessons.isEmpty) {
      return HomeSectionList(
        key: const ValueKey('home-timeline-empty'),
        children: [
          HomeEmptyRow(
            text: context.l10n.homeNoMoreToday,
            onTap: () => context.go('/schedule'),
          ),
        ],
      );
    }
    return HomeSectionList(
      key: const ValueKey('home-timeline-lessons'),
      children: [
        for (final (index, lesson) in lessons.indexed)
          HomeTodayRow(
            lesson: lesson,
            isNext: index == 0 && !_isPast(lesson),
            isPast: _isPast(lesson),
          ).animateListItem(index: index),
      ],
    );
  }

  bool _isPast(LessonSchedulePart lesson) =>
      lesson.lessonBells.endTime.toDateTime(day).isBefore(now);
}
