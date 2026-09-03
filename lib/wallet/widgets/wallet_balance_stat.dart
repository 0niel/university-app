part of 'wallet_balance_block.dart';

class _WalletBalanceStat extends StatelessWidget {
  const _WalletBalanceStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.canvas.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sectionGap,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.tabular(
                AppText.headline.copyWith(color: colors.canvas),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.subtext.copyWith(
                color: colors.canvas,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
