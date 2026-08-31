part of 'wallet_spend_tab.dart';

class WalletSpendRow extends StatelessWidget {
  const WalletSpendRow({required this.item, this.onTap, super.key});

  final WalletSpendItem item;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final row = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppNinjaMark(size: 14, color: colors.brandInk),
          const SizedBox(width: 5),
          Text(
            item.cost,
            style: NinjaText.tabular(
              NinjaText.body.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.chevron,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return AppPressable(onTap: onTap, child: row);
  }
}
