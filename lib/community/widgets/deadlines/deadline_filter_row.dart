import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class DeadlineFilterRow extends StatelessWidget {
  const DeadlineFilterRow({
    required this.selected,
    super.key,
    this.activeCount = 0,
  });

  final DeadlineFilter selected;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = <(DeadlineFilter, String, int?)>[
      (DeadlineFilter.all, l10n.deadlinesFilterAll, activeCount),
      (DeadlineFilter.hot, l10n.deadlinesFilterHot, null),
      (DeadlineFilter.mine, l10n.deadlinesFilterMine, null),
      (DeadlineFilter.group, l10n.deadlinesFilterGroup, null),
      (DeadlineFilter.done, l10n.deadlinesFilterDone, null),
    ];
    return NinjaChipRow(
      children: [
        for (final (filter, label, count) in items)
          NinjaChip(
            label: label,
            count: count != null && count > 0 ? count : null,
            selected: selected == filter,
            onTap: () => context.read<DeadlinesCubit>().filterChanged(filter),
          ),
      ],
    );
  }
}
