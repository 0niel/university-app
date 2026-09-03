import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/app/theme/lesson_type_palette.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

abstract final class LessonCard {
  static Color colorOf(
    LessonSchedulePart lesson, {
    Map<String, int> overrides = const {},
  }) {
    final color = lesson.color;
    return color != null
        ? Color(color)
        : getColorByType(lesson.lessonType, overrides: overrides);
  }

  static Color colorOfFor(
    BuildContext context,
    LessonSchedulePart lesson,
  ) => colorOf(lesson, overrides: LessonTypePalette.of(context));

  static Color getColorByType(
    LessonType lessonType, {
    Map<String, int> overrides = const {},
  }) {
    final override = overrides[lessonType.name];
    if (override != null) return Color(override);
    return Color(
      kDefaultLessonTypeColors[lessonType.name] ??
          kDefaultLessonTypeColors['unknown']!,
    );
  }

  static AppLineIcon getIconByType(LessonType lessonType) {
    return switch (lessonType) {
      .lecture || .consultation || .unknown => AppLineIcon.book,
      .practice || .individualWork => AppLineIcon.pencil,
      .laboratoryWork => AppLineIcon.flask,
      .physicalEducation => AppLineIcon.bolt,
      .exam || .credit => AppLineIcon.clipboard,
      .courseWork || .courseProject => AppLineIcon.folder,
    };
  }

  static Color getColorByTypeFor(BuildContext context, LessonType lessonType) {
    return getColorByType(
      lessonType,
      overrides: LessonTypePalette.of(context),
    );
  }

  static String getLessonTypeName(
    AppLocalizations l10n,
    LessonType lessonType,
  ) {
    return switch (lessonType) {
      .lecture => l10n.lecture,
      .laboratoryWork => l10n.laboratory,
      .practice => l10n.practice,
      .individualWork => l10n.lessonTypeIndividualShort,
      .physicalEducation => l10n.physicalEducation,
      .exam => l10n.exam,
      .consultation => l10n.consultation,
      .courseWork => l10n.lessonTypeCourseWorkShort,
      .courseProject => l10n.lessonTypeCourseProjectShort,
      .credit => l10n.credit,
      .unknown => l10n.unknown,
    };
  }
}
