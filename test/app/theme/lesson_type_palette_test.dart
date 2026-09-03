import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _Lesson extends Mock implements LessonSchedulePart {}

void main() {
  test('stored defaults resolve to theme-aware semantic colors', () {
    for (final accent in AppAccent.values) {
      for (final base in [AppColors.light, AppColors.dark]) {
        final colors = base.withAccent(accent);
        final palette = LessonTypePalette.resolve(
          colors,
          kDefaultLessonTypeColors,
        );
        expect(palette['lecture'], colors.lecture.toARGB32());
        expect(palette['practice'], colors.practice.toARGB32());
        expect(palette['laboratoryWork'], colors.lab.toARGB32());
        expect(palette['exam'], colors.exam.toARGB32());
        expect(palette['credit'], colors.warn.toARGB32());
        expect(palette['unknown'], colors.muted.toARGB32());
      }
    }
  });

  test('explicit custom colors survive theme and accent changes', () {
    const custom = 0xFFCC33AA;
    final overrides = {...kDefaultLessonTypeColors, 'lecture': custom};
    for (final base in [AppColors.light, AppColors.dark]) {
      final colors = base.withAccent(AppAccent.green);
      final palette = LessonTypePalette.resolve(colors, overrides);
      expect(palette['lecture'], custom);
      expect(palette['practice'], colors.practice.toARGB32());
      expect(overrides['lecture'], custom);
      expect(overrides['practice'], kDefaultLessonTypeColors['practice']);
    }
  });

  test(
    'legacy defaults follow dark tokens without rewriting stored colors',
    () {
      final saved = {
        ...kDefaultLessonTypeColors,
        'lecture': 0xFF087F5B,
        'physicalEducation': 0xFF087F5B,
        'credit': 0xFFDB8B00,
        'unknown': 0xFF74747D,
        'exam': 0xFFCC33AA,
      };
      final original = {...saved};
      final resolved = LessonTypePalette.resolve(AppColors.dark, saved);
      expect(resolved['lecture'], AppColors.dark.lecture.toARGB32());
      expect(resolved['physicalEducation'], AppColors.dark.lecture.toARGB32());
      expect(resolved['credit'], AppColors.dark.warn.toARGB32());
      expect(resolved['unknown'], AppColors.dark.muted.toARGB32());
      expect(resolved['exam'], 0xFFCC33AA);
      expect(saved, original);
    },
  );

  for (final suppliedDefaults in [false, true]) {
    testWidgets('dark lesson colors resolve with defaults=$suppliedDefaults', (
      tester,
    ) async {
      Color? lecture;
      Color? practice;
      Widget probe() => Builder(
        builder: (context) {
          lecture = LessonCard.getColorByTypeFor(context, LessonType.lecture);
          practice = LessonCard.getColorByTypeFor(context, LessonType.practice);
          return const SizedBox();
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: suppliedDefaults
              ? LessonTypePalette(
                  colors: kDefaultLessonTypeColors,
                  child: probe(),
                )
              : probe(),
        ),
      );
      expect(lecture, AppColors.dark.lecture);
      expect(practice, AppColors.dark.practice);
    });
  }

  testWidgets('individual lesson color overrides stay literal in dark mode', (
    tester,
  ) async {
    final lesson = _Lesson();
    final savedColor = kDefaultLessonTypeColors['lecture']!;
    when(() => lesson.color).thenReturn(savedColor);
    Color? actual;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: LessonTypePalette(
          colors: kDefaultLessonTypeColors,
          child: Builder(
            builder: (context) {
              actual = LessonCard.colorOfFor(context, lesson);
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    expect(actual, Color(savedColor));
  });
}
