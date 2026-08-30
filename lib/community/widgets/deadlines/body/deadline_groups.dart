part of '../deadlines_body.dart';

List<Widget> _deadlineGroupSlivers(
  BuildContext context, {
  required DeadlinesState state,
  required ValueChanged<String> onToggle,
}) {
  final l10n = context.l10n;
  final groups = [
    (id: 'hot', title: l10n.deadlinesFilterHot, items: state.inBucket(.hot)),
    (
      id: 'week',
      title: l10n.deadlinesGroupWeek,
      items: state.inBucket(.week),
    ),
    (
      id: 'later',
      title: l10n.deadlinesGroupLater,
      items: state.inBucket(.later),
    ),
    (
      id: 'done',
      title: l10n.deadlinesFilterDone,
      items: state.inBucket(.done),
    ),
  ];
  return [
    for (final group in groups)
      if (group.items.isNotEmpty)
        DeadlineGroup(
          key: ValueKey('${state.filter.name}-${group.id}'),
          title: group.title,
          deadlines: group.items,
          pendingDeadlineIds: state.pendingDeadlineIds,
          onToggle: onToggle,
        ),
  ];
}
