import 'package:schedule_repository/schedule_repository.dart';

enum DeadlineGroupKind { today, week, later }

DeadlineGroupKind deadlineGroupKind(Deadline deadline, {DateTime? now}) {
  final current = now ?? DateTime.now();
  final today = DateTime(current.year, current.month, current.day);
  final due = deadline.dueAt;
  final dueDay = DateTime(due.year, due.month, due.day);
  final days = dueDay.difference(today).inDays;
  if (days <= 0) return DeadlineGroupKind.today;
  if (days <= 7) return DeadlineGroupKind.week;
  return DeadlineGroupKind.later;
}

List<Deadline> deadlinesInGroup(
  List<Deadline> deadlines,
  DeadlineGroupKind kind, {
  DateTime? now,
}) {
  final items =
      [
        for (final deadline in deadlines)
          if (deadlineGroupKind(deadline, now: now) == kind) deadline,
      ]..sort((a, b) {
        if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
        return a.dueAt.compareTo(b.dueAt);
      });
  return items;
}
