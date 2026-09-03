part of 'wallet_spend_tab.dart';

class WalletSpendRow extends StatelessWidget {
  const WalletSpendRow({required this.item, this.onTap, super.key});

  final WalletSpendItem item;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final row = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.gap),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
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
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  item.description,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppNinjaMark(size: 14, color: colors.accent),
          const SizedBox(width: 5),
          Text(
            item.cost,
            style: AppText.tabular(
              AppText.body.copyWith(
                color: colors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.xsm),
            AppLineIconWidget(
              AppLineIcon.chevronR,
              size: 16,
              color: colors.muted2,
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return row;
    return AppPressable(onTap: onTap, child: row);
  }
}
