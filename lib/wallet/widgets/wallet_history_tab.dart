import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'wallet_history_row.dart';
part 'wallet_history_row_skeleton.dart';
part 'wallet_history_skeleton.dart';

class WalletHistoryTab extends StatelessWidget {
  const WalletHistoryTab({
    required this.entries,
    this.loading = false,
    super.key,
  });

  final List<ShurikenEntry> entries;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) return const WalletHistorySkeleton();
    if (entries.isEmpty) {
      final l10n = context.l10n;
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.zero,
          AppSpacing.xxl,
          AppSpacing.zero,
          AppSpacing.zero,
        ),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.clock),
          title: l10n.walletHistoryEmptyTitle,
          message: l10n.walletHistoryEmptySub,
        ).animateEmptyState(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, entry) in entries.indexed)
          WalletHistoryRow(entry: entry).animateListItem(index: index),
      ],
    );
  }
}
