import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

bool sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String deadlineMetaLabel(
  BuildContext context,
  Deadline deadline, {
  DateTime? now,
}) {
  final l10n = context.l10n;
  final current = now ?? DateTime.now();
  final due = deadline.dueAt;
  final locale = Localizations.localeOf(context).toString();
  final time = DateFormat.Hm(locale).format(due);
  final when = sameDay(due, current)
      ? '${l10n.deadlineToday} $time'
      : sameDay(due, current.add(const Duration(days: 1)))
      ? '${l10n.deadlineTomorrow} $time'
      : DateFormat('d MMM, HH:mm', locale).format(due);
  final subject = deadline.subjectName.trim();
  return subject.isEmpty ? when : '$subject · $when';
}

String deadlineLeftLabel(
  BuildContext context,
  Deadline deadline, {
  DateTime? now,
}) {
  final l10n = context.l10n;
  if (deadline.isDone) return l10n.deadlineLeftDone;
  final left = deadline.timeLeftAt(now ?? DateTime.now());
  if (left.isNegative) return l10n.deadlineOverdue;
  if (left.inHours < 24) return l10n.deadlineLeftHours(left.inHours);
  if (left.inDays < 14) return l10n.deadlineLeftDays(left.inDays);
  return l10n.deadlineLeftWeeks((left.inDays / 7).round());
}
