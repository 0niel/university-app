import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_focus_state.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_timeline_section.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeSelectedDayTimeline extends StatelessWidget {
  const HomeSelectedDayTimeline({
    required this.day,
    required this.lessons,
    required this.now,
    required this.loading,
    super.key,
  });

  final DateTime day;
  final List<LessonSchedulePart> lessons;
  final DateTime now;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final focusState = homeFocusState(day: day, lessons: lessons, now: now);
    final locale = Localizations.localeOf(context).languageCode;
    final title = DateUtils.isSameDay(day, now)
        ? context.l10n.next
        : toBeginningOfSentenceCase(
            DateFormat('EEEE', locale).format(day),
          );
    return HomeTimelineSection(
      title: title,
      loading: loading && lessons.isEmpty,
      lessons: focusState.following.take(3).toList(),
      day: day,
      now: now,
    );
  }
}
