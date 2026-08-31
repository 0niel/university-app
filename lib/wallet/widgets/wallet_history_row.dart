part of 'wallet_history_tab.dart';

class WalletHistoryRow extends StatelessWidget {
  const WalletHistoryRow({required this.entry, super.key});

  final ShurikenEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final emoji = entry.emoji;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          if (emoji.isNotEmpty) ...[
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.title,
                  overflow: TextOverflow.ellipsis,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatWalletHistoryTimestamp(context, entry.createdAt),
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            entry.isSpend ? '−${-entry.amount}' : '+${entry.amount}',
            style: NinjaText.tabular(
              NinjaText.body.copyWith(
                color: entry.isSpend ? colors.muted : colors.brandInk,
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
