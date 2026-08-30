import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_board_opener.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_focus_state.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_selected_day_timeline.dart';
import 'package:rtu_mirea_app/home/view/home_lesson_hero.dart';
import 'package:rtu_mirea_app/home/view/home_no_lessons_card.dart';
import 'package:rtu_mirea_app/home/view/home_now_skeleton.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class HomeDayBoard extends StatelessWidget {
  const HomeDayBoard({
    required this.day,
    required this.lessons,
    required this.now,
    required this.loading,
    required this.failed,
    required this.showTimeline,
    required this.onRetry,
    super.key,
  });

  final DateTime day;
  final List<LessonSchedulePart> lessons;
  final DateTime now;
  final bool loading;
  final bool failed;
  final bool showTimeline;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final focusState = homeFocusState(day: day, lessons: lessons, now: now);

    return AppTourAnchor(
      target: .homeBoard,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          HomeBoardOpener(
            child: NinjaStateSwitcher(child: _opener(context, focusState)),
          ),
          if (showTimeline)
            HomeSelectedDayTimeline(
              day: day,
              lessons: lessons,
              now: now,
              loading: loading,
            ),
        ],
      ),
    );
  }

  Widget _opener(BuildContext context, HomeFocusState focusState) {
    final focus = focusState.focus;
    if (focus != null) {
      return HomeLessonHero(
        key: ValueKey('focus-${focus.subject}-$day'),
        lesson: focus,
        day: day,
        now: now,
        isCurrent: focusState.current != null,
      );
    }
    if (loading && lessons.isEmpty) {
      return const HomeNowSkeleton(key: ValueKey('loading'));
    }
    if (failed) {
      final l10n = context.l10n;
      return NinjaErrorCard(
        key: const ValueKey('failed'),
        title: l10n.errorLoadingSchedule,
        message: l10n.lessonDetailsCheckConnection,
        actionLabel: l10n.retry,
        onAction: onRetry,
      );
    }
    return HomeNoLessonsCard(
      key: ValueKey('empty-$day'),
      hadLessons: DateUtils.isSameDay(day, now) && lessons.isNotEmpty,
    );
  }
}
