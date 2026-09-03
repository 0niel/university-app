import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/day_timeline.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_test_data.dart';

void main() {
  final day = DateTime(2026, 9, 2);

  ScheduleDayTimeline build({
    required List<LessonSchedulePart> lessons,
    List<ScheduleChange> changes = const [],
    bool past = true,
    bool cancelled = true,
    DateTime? now,
  }) => buildDayTimeline(
    lessons: lessons,
    changes: changes,
    day: day,
    now: now ?? DateTime(2026, 9, 2, 12),
    showPast: past,
    showCancelled: cancelled,
    showGaps: true,
  );

  test('hiding past lessons does not leave a gap before the first row', () {
    final result = build(
      past: false,
      lessons: [
        scheduleTestLesson(),
        scheduleTestLesson(start: 760, end: 850),
      ],
    );
    expect(result.visibleLessons, 1);
    expect(result.entries.whereType<ScheduleGapEntry>(), isEmpty);
  });

  test('cancelled lessons stay visible without being counted as active', () {
    final result = build(
      lessons: [scheduleTestLesson()],
      changes: [
        ScheduleChange(
          id: 'change',
          kind: ScheduleChangeKind.cancel,
          subject: 'Математика',
          lessonDate: day,
          createdAt: day,
        ),
      ],
    );
    expect(result.visibleLessons, 1);
    expect(result.totalLessons, 0);
    expect(
      result.entries.whereType<ScheduleLessonEntry>().single.cancelled,
      isTrue,
    );
  });

  test('now marker is absent overnight and on another date', () {
    for (final now in [DateTime(2026, 9, 2, 2), DateTime(2026, 9, 3, 12)]) {
      expect(
        build(
          lessons: [scheduleTestLesson()],
          now: now,
        ).entries.whereType<ScheduleNowEntry>(),
        isEmpty,
      );
    }
  });

  test('overlapping groups retain all lessons and separate touching slots', () {
    final result = build(
      lessons: [
        scheduleTestLesson(subject: 'A'),
        scheduleTestLesson(subject: 'B', end: 650),
        scheduleTestLesson(subject: 'C', start: 640, end: 680),
        scheduleTestLesson(subject: 'D', start: 680, end: 720),
      ],
    );
    expect(
      groupTimelineLessons(
        result.entries,
      ).map((group) => group.map((entry) => entry.lesson.subject).toList()),
      [
        ['A', 'B', 'C'],
        ['D'],
      ],
    );
  });
}
