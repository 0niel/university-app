import 'package:gamification_repository/gamification_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';

abstract final class PreviewFixtures {
  static final now = DateTime(2026, 9, 1, 11, 22);
  static const name = 'Олег Ковалёв';
  static const group = 'ИКБО-01-24';
  static const course = 3;
  static const groupRank = 4;
  static const gpa = '4.8';
  static const attendance = '94%';
  static const daysToExam = '12';
  static const profile = UserGamificationProfile(
    userId: 'design-preview',
    level: 7,
    xp: 2340,
    streakDays: 12,
  );
  static final deadlines = [
    Deadline(
      id: 'preview-lab',
      title: 'Отчёт по лабораторной №3',
      subjectName: 'Программирование',
      dueAt: now.add(const Duration(hours: 7)),
      source: DeadlineSource.me,
      isMine: true,
    ),
    Deadline(
      id: 'preview-essay',
      title: 'Эссе: My future career',
      subjectName: 'Английский язык',
      dueAt: now.add(const Duration(days: 2)),
      source: DeadlineSource.me,
      isMine: true,
    ),
  ];
  static final List<LessonSchedulePart> lessons = [
    for (var day = 0; day < 14; day++)
      if (day % 7 != 5)
        for (final row in [
          (
            'Математический анализ',
            LessonType.lecture,
            9,
            0,
            'А-318',
            'Смирнова Е. В.',
          ),
          (
            'Программирование на Python',
            LessonType.practice,
            10,
            40,
            'И-204',
            'Кузнецов А. П.',
          ),
          (
            'Физика',
            LessonType.laboratoryWork,
            12,
            40,
            'Б-112',
            'Иванов Д. С.',
          ),
          if (day.isEven)
            (
              'Английский язык',
              LessonType.practice,
              14,
              20,
              'А-401',
              'Морозова К. Л.',
            ),
        ])
          LessonSchedulePart(
            subject: row.$1,
            lessonType: row.$2,
            teachers: [Teacher(name: row.$6)],
            classrooms: [Classroom(name: row.$5)],
            dates: [DateTime(2026, 8, 31 + day)],
            lessonBells: LessonBells(
              startTime: TimeOfDay(hour: row.$3, minute: row.$4),
              endTime: TimeOfDay(
                hour: row.$3 + (row.$4 + 90) ~/ 60,
                minute: (row.$4 + 90) % 60,
              ),
            ),
          ),
  ];
}
