import 'package:rtu_mirea_app/community/view/deadlines/deadline_group_kind.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'deadline_group_kind.dart';

List<DeadlineGroupKind> get deadlineGroupOrder => const [
  DeadlineGroupKind.overdue,
  DeadlineGroupKind.today,
  DeadlineGroupKind.tomorrow,
  DeadlineGroupKind.week,
  DeadlineGroupKind.later,
  DeadlineGroupKind.done,
];

DeadlineGroupKind deadlineGroupKind(Deadline deadline, {DateTime? now}) {
  if (deadline.isDone) return DeadlineGroupKind.done;
  final current = now ?? DateTime.now();
  if (deadline.dueAt.isBefore(current)) return DeadlineGroupKind.overdue;
  final today = DateTime(current.year, current.month, current.day);
  final due = deadline.dueAt;
  final dueDay = DateTime(due.year, due.month, due.day);
  final days = dueDay.difference(today).inDays;
  if (days == 0) return DeadlineGroupKind.today;
  if (days == 1) return DeadlineGroupKind.tomorrow;
  if (days <= 7) return DeadlineGroupKind.week;
  return DeadlineGroupKind.later;
}

List<Deadline> deadlinesInGroup(
  List<Deadline> deadlines,
  DeadlineGroupKind kind, {
  DateTime? now,
}) {
  final items = [
    for (final deadline in deadlines)
      if (deadlineGroupKind(deadline, now: now) == kind) deadline,
  ]..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  return items;
}

Map<DeadlineGroupKind, List<Deadline>> deadlineGroups(
  List<Deadline> deadlines, {
  DateTime? now,
}) => {
  for (final kind in deadlineGroupOrder)
    kind: deadlinesInGroup(deadlines, kind, now: now),
};
