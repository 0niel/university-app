part of 'wallet_balance_block.dart';

class _WalletBalanceStat extends StatelessWidget {
  const _WalletBalanceStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onAccentSoft.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(NinjaRadius.control),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.tabular(
                NinjaText.headline.copyWith(color: colors.onAccentSoft),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.subtext.copyWith(
                color: colors.onAccentSoftMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
