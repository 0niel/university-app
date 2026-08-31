import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/generated/app_localizations.dart';
import 'package:schedule/schedule.dart';

class FieldInfo {
  const FieldInfo(this.label, this.icon, this.color);
  final String label;
  final AppLineIcon icon;
  final Color color;
}

FieldInfo fieldInfo(
  LessonField field,
  AppLocalizations l10n,
  NinjaColors palette,
) {
  switch (field) {
    case .lessonType:
      return FieldInfo(
        l10n.scheduleDiffFieldLessonType,
        AppLineIcon.book,
        palette.indigo,
      );
    case .time:
      return FieldInfo(
        l10n.scheduleDiffFieldTime,
        AppLineIcon.clock,
        palette.scarlet,
      );
    case .number:
      return FieldInfo(
        l10n.scheduleDiffFieldNumber,
        AppLineIcon.focus,
        palette.orange,
      );
    case .teachers:
      return FieldInfo(
        l10n.scheduleDiffFieldTeachers,
        AppLineIcon.school,
        palette.indigo,
      );
    case .classrooms:
      return FieldInfo(
        l10n.scheduleDiffFieldClassrooms,
        AppLineIcon.pin,
        palette.green,
      );
    case .dates:
      return FieldInfo(
        l10n.scheduleDiffFieldDates,
        AppLineIcon.calendar,
        palette.amber,
      );
    case .groups:
      return FieldInfo(
        l10n.scheduleDiffFieldGroups,
        AppLineIcon.people,
        palette.scarlet,
      );
  }
}

Color changeColor(ChangeKind kind, NinjaColors colors) {
  switch (kind) {
    case .added:
      return colors.green;
    case .modified:
      return colors.amber;
    case .removed:
      return colors.scarlet;
  }
}

AppLineIcon changeIcon(ChangeKind kind) => switch (kind) {
  .added => AppLineIcon.plus,
  .modified => AppLineIcon.pencil,
  .removed => AppLineIcon.trash,
};

String changeLabel(ChangeKind kind, AppLocalizations l10n) {
  switch (kind) {
    case .added:
      return l10n.scheduleDiffKindNew;
    case .modified:
      return l10n.scheduleDiffKindModified;
    case .removed:
      return l10n.scheduleDiffKindRemoved;
  }
}

String formatDiffDate(DateTime date, String locale) {
  return '${DateFormat('dd.MM', locale).format(date)} '
      '(${DateFormat('E', locale).format(date)})';
}
