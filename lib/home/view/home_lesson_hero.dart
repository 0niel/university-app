import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/home/view/dashboard/home_day_status.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'hero_progress.dart';
part 'hero_status_line.dart';
part 'hero_subject.dart';
part 'hero_time_column.dart';
part 'hero_time_range.dart';

class HomeLessonHero extends StatelessWidget {
  const HomeLessonHero({
    required this.lesson,
    required this.day,
    required this.now,
    required this.isCurrent,
    super.key,
  });

  final LessonSchedulePart lesson;
  final DateTime day;
  final DateTime now;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final start = lesson.lessonBells.startTime.toDateTime(day);
    final end = lesson.lessonBells.endTime.toDateTime(day);
    final span = end.difference(start).inSeconds;
    final progress = span <= 0
        ? 1.0
        : (now.difference(start).inSeconds / span).clamp(0.0, 1.0);
    final room = lesson.classrooms.isEmpty
        ? '—'
        : lesson.classrooms.map((classroom) => classroom.name).join(', ');
    final teacher = lesson.teachers.map((item) => item.name).join(', ');
    final accessible = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    final isToday = DateUtils.isSameDay(day, now);
    final countdown = isCurrent
        ? l10n.minutesLeft(homeCountdownMinutes(end.difference(now)))
        : _upcomingCountdown(context, start: start, isToday: isToday);

    return AppPressable(
      onTap: () => context.go('/schedule'),
      semanticsLabel: '${lesson.subject}, $room',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, isCurrent ? 16 : 18),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  _HeroStatusLine(
                    isCurrent: isCurrent,
                    countdown: countdown,
                  ),
                  SizedBox(height: accessible ? 12 : 10),
                  if (accessible) ...[
                    _HeroTimeRange(start: start, end: end),
                    const SizedBox(height: 10),
                    _HeroSubject(
                      lesson: lesson,
                      room: room,
                      teacher: teacher,
                      accessible: accessible,
                    ),
                  ] else
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        _HeroTimeColumn(start: start, end: end),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _HeroSubject(
                            lesson: lesson,
                            room: room,
                            teacher: teacher,
                            accessible: accessible,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (isCurrent)
              Padding(
                padding: const .fromLTRB(16, 0, 16, 16),
                child: _HeroProgress(progress: progress),
              ),
          ],
        ),
      ),
    );
  }

  String? _upcomingCountdown(
    BuildContext context, {
    required DateTime start,
    required bool isToday,
  }) {
    if (!isToday) return null;
    final minutes = homeCountdownMinutes(start.difference(now));
    if (minutes <= 0 || minutes > 180) return null;
    return context.l10n.homeInMinutes(minutes);
  }
}

extension on TimeOfDay {
  DateTime toDateTime(DateTime day) =>
      .new(day.year, day.month, day.day, hour, minute);
}
