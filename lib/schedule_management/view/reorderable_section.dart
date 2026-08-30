part of 'edit_schedules_page.dart';

class _ReorderableSection extends StatelessWidget {
  const _ReorderableSection({
    required this.title,
    required this.target,
    required this.entries,
  });

  final String title;
  final ScheduleTarget target;
  final List<_EditEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final colors = context.ninja;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              10,
              NinjaMetrics.screenPadding,
              10,
            ),
            child: Text(
              title,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
          ),
          ReorderableListView.builder(
            shrinkWrap: true,
            buildDefaultDragHandles: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: entries.length,
            onReorderItem: (oldIndex, newIndex) =>
                _onReorder(context, oldIndex, newIndex),
            itemBuilder: (itemContext, index) {
              final entry = entries[index];
              return _EditRow(
                key: ValueKey(entry.id),
                target: target,
                entry: entry,
                index: index,
                onRemove: () => _onRemove(itemContext, entry),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onReorder(BuildContext context, int oldIndex, int newIndex) {
    final ids = [for (final entry in entries) entry.id];
    final id = ids.removeAt(oldIndex);
    ids.insert(newIndex, id);
    context.read<ScheduleBloc>().add(
      ScheduleReordered(target: target, orderedIds: ids),
    );
  }

  void _onRemove(BuildContext context, _EditEntry entry) {
    context.read<ScheduleBloc>().add(
      ScheduleDeleteRequested(identifier: entry.id, target: target),
    );
    NinjaToastHost.maybeOf(
      context,
    )?.show(NinjaToastData(message: context.l10n.scheduleRemovedToast));
  }
}
