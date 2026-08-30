import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations_ru.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule/schedule.dart';

void main() {
  final l10n = AppLocalizationsRu();

  test('provides a stable display name for every lesson type', () {
    const expectedNames = {
      LessonType.practice: 'Практика',
      LessonType.lecture: 'Лекция',
      LessonType.laboratoryWork: 'Лабораторная',
      LessonType.individualWork: 'Сам. работа',
      LessonType.physicalEducation: 'Физкультура',
      LessonType.consultation: 'Консультация',
      LessonType.exam: 'Экзамен',
      LessonType.credit: 'Зачет',
      LessonType.courseWork: 'Курс. раб.',
      LessonType.courseProject: 'Курс. проект',
      LessonType.unknown: 'Неизвестно',
    };

    expect(
      {
        for (final type in LessonType.values)
          type: LessonCard.getLessonTypeName(l10n, type),
      },
      expectedNames,
    );
  });

  test('provides an opaque display color for every lesson type', () {
    for (final type in LessonType.values) {
      expect(LessonCard.getColorByType(type).a, 1);
    }
  });
}
