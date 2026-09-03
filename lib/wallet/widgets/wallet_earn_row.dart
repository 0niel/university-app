part of 'wallet_earn_tab.dart';

class WalletEarnRow extends StatelessWidget {
  const WalletEarnRow({required this.way, this.muted = false, super.key});

  final WalletEarnWay way;

  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final titleColor = muted ? colors.muted : colors.ink;
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Text(
              way.title,
              style: AppText.headline.copyWith(color: titleColor),
            ),
            if (way.live)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.tint,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: AppSpacing.xs,
                  ),
                  child: Text(
                    l10n.walletEarnLiveTag,
                    style: AppText.badge.copyWith(color: colors.accent),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          way.description,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
    final reward = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          way.value,
          style: AppText.tabular(
            AppText.headline.copyWith(color: titleColor),
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          way.per,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
      ],
    );
    return Semantics(
      container: true,
      label: '${way.title}, ${way.value}, ${way.per}',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.gap),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.5;
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details,
                  const SizedBox(height: AppSpacing.md),
                  Align(alignment: Alignment.centerRight, child: reward),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: AppSpacing.md),
                reward,
              ],
            );
          },
        ),
      ),
    );
  }
}
