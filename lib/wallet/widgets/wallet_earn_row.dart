part of 'wallet_earn_tab.dart';

class WalletEarnRow extends StatelessWidget {
  const WalletEarnRow({required this.way, this.muted = false, super.key});

  final WalletEarnWay way;

  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
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
              style: NinjaText.headline.copyWith(color: titleColor),
            ),
            if (way.live)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.brandTint,
                  borderRadius: BorderRadius.circular(NinjaRadius.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  child: Text(
                    l10n.walletEarnLiveTag,
                    style: NinjaText.badge.copyWith(color: colors.brandInk),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          way.description,
          style: NinjaText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
    final reward = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          way.value,
          style: NinjaText.tabular(
            NinjaText.headline.copyWith(color: titleColor),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          way.per,
          style: NinjaText.helper.copyWith(color: colors.muted),
        ),
      ],
    );
    return Semantics(
      container: true,
      label: '${way.title}, ${way.value}, ${way.per}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
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
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: reward),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: 12),
                reward,
              ],
            );
          },
        ),
      ),
    );
  }
}
