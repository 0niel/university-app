import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/lost_and_found/cubit/lost_found_cubit.dart';
import 'package:rtu_mirea_app/lost_and_found/models/models.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_row.dart';
import 'package:rtu_mirea_app/lost_and_found/widgets/lost_found_skeleton.dart';

class LostFoundBody extends StatelessWidget {
  const LostFoundBody({
    required this.state,
    required this.tab,
    required this.onItemTap,
    required this.onContact,
    required this.onRetry,
    super.key,
  });

  final LostFoundState state;
  final LostFoundTab tab;
  final ValueChanged<LostFoundItem> onItemTap;
  final ValueChanged<LostFoundItem> onContact;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _content(context));
  }

  Widget _content(BuildContext context) {
    final l10n = context.l10n;
    if (state.status == .loading && state.items.isEmpty) {
      return const LostFoundSkeleton(key: ValueKey('lost-found-loading'));
    }
    if (state.status == .failure && state.items.isEmpty) {
      return NinjaErrorState(
        key: const ValueKey('lost-found-failure'),
        title: l10n.lostFoundLoadError,
        message: l10n.lostFoundLoadErrorSub,
        retryLabel: l10n.retry,
        onRetry: onRetry,
      );
    }
    final items = state.items.where(tab.matches).toList(growable: false);
    if (items.isEmpty) {
      return AppListGroup(
        key: ValueKey('lost-found-empty-${tab.name}'),
        children: [
          NinjaEmptyState.compact(
            title: switch (tab) {
              LostFoundTab.all => l10n.lostFoundEmptyAll,
              LostFoundTab.found => l10n.lostFoundEmptyFound,
              LostFoundTab.lost => l10n.lostFoundEmptyLost,
            },
            message: l10n.lostFoundEmptySub,
          ),
        ],
      );
    }
    return AppListGroup(
      key: ValueKey('lost-found-list-${tab.name}'),
      children: [
        for (final (index, item) in items.indexed)
          LostFoundRow(
            key: ValueKey(item.id),
            item: item,
            onTap: () => onItemTap(item),
            onContact: () => onContact(item),
          ).animateListItem(index: index),
      ],
    );
  }
}
