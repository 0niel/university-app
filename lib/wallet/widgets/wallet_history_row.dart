part of 'wallet_history_tab.dart';

class WalletHistoryRow extends StatelessWidget {
  const WalletHistoryRow({required this.entry, super.key});

  final ShurikenEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final emoji = entry.emoji;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.gap),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          if (emoji.isNotEmpty) ...[
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: AppSpacing.gap),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.title,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatWalletHistoryTimestamp(context, entry.createdAt),
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            entry.isSpend ? '−${-entry.amount}' : '+${entry.amount}',
            style: AppText.tabular(
              AppText.body.copyWith(
                color: entry.isSpend ? colors.ink : colors.lecture,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatWalletHistoryTimestamp(BuildContext context, DateTime? date) {
  if (date == null) return '';
  final l10n = context.l10n;
  final locale = Localizations.localeOf(context).toString();
  final local = date.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final time = DateFormat.Hm(locale).format(local);
  if (day == today) return l10n.walletHistoryToday(time);
  if (day == today.subtract(const Duration(days: 1))) {
    return l10n.walletHistoryYesterday(time);
  }
  return DateFormat('d MMM', locale).format(local);
}
