import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:schedule_repository/schedule_repository.dart';

bool sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String deadlineDateLabel(
  BuildContext context,
  DateTime due, {
  DateTime? now,
}) {
  final l10n = context.l10n;
  final current = now ?? DateTime.now();
  final locale = Localizations.localeOf(context).toString();
  final time = DateFormat.Hm(locale).format(due);
  if (sameDay(due, current)) {
    return '${l10n.deadlineToday}, $time';
  }
  if (sameDay(due, current.add(const Duration(days: 1)))) {
    return '${l10n.deadlineTomorrow}, $time';
  }
  final today = DateTime(current.year, current.month, current.day);
  final dueDay = DateTime(due.year, due.month, due.day);
  final days = dueDay.difference(today).inDays;
  if (days > 1 && days <= 6) {
    final weekday = DateFormat.E(locale).format(due);
    return '$weekday, ${DateFormat.MMMd(locale).format(due)}';
  }
  return '${DateFormat.MMMd(locale).format(due)} · $time';
}

String deadlineMetaLabel(
  BuildContext context,
  Deadline deadline, {
  DateTime? now,
}) {
  final when = deadlineDateLabel(context, deadline.dueAt, now: now);
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
  if (left.isNegative) {
    final overdue = -left;
    if (overdue.inHours < 24) {
      return l10n.deadlineOverdueByHours(overdue.inHours.clamp(1, 23));
    }
    return l10n.deadlineOverdueByDays(overdue.inDays);
  }
  if (left.inHours < 24) {
    return l10n.deadlineDueInHours(left.inHours.clamp(1, 23));
  }
  if (left.inDays < 14) return l10n.deadlineDueInDays(left.inDays);
  return l10n.deadlineDueInWeeks((left.inDays / 7).round());
}

enum DeadlineUrgencyTier { danger, warn, normal, done }

DeadlineUrgencyTier deadlineUrgencyTierAt(Deadline deadline, DateTime now) {
  if (deadline.isDone) return DeadlineUrgencyTier.done;
  if (deadline.isUrgentAt(now)) return DeadlineUrgencyTier.danger;
  if (deadline.isWarnAt(now)) return DeadlineUrgencyTier.warn;
  return DeadlineUrgencyTier.normal;
}

Color deadlineUrgencyColor(BuildContext context, DeadlineUrgencyTier tier) {
  final colors = context.colors;
  return switch (tier) {
    DeadlineUrgencyTier.done => colors.muted2,
    DeadlineUrgencyTier.danger => colors.danger,
    DeadlineUrgencyTier.warn => colors.warn,
    DeadlineUrgencyTier.normal => colors.muted,
  };
}
