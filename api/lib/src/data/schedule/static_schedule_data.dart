part of 'in_memory_schedule_data_source.dart';

const groups = [
  'ИКБО-01-19',
  'ИКБО-02-19',
  'ИКБО-03-19',
  'ИКБО-04-19',
  'ИКБО-05-19',
];

const campus = Campus(
  name: 'Проспект Вернадского, 78',
  shortName: 'В-78',
  latitude: 55.676098,
  longitude: 37.516845,
);

final schedules = <SchedulePart>[
  LessonSchedulePart(
    subject: 'Математический анализ',
    lessonType: LessonType.practice,
    teachers: [const Teacher(name: 'Зуев Андрей Сергеевич', email: 'zuev_a@mirea.ru')],
    classrooms: [
      const Classroom(
        name: 'А-401',
        campus: campus,
      ),
    ],
    lessonBells: LessonBells(
      number: 1,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
    ),
    dates: [
      DateTime(2023, 12, 1),
    ],
  ),
  HolidaySchedulePart(
    title: 'Новый год',
    dates: [
      DateTime(2023, 1, 1),
    ],
  ),
];
