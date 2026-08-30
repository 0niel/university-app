part of 'wallet_view.dart';

class _WalletTabs extends StatelessWidget {
  const _WalletTabs({required this.value, required this.onChanged});

  final WalletTab value;
  final ValueChanged<WalletTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final tabs = [
      (WalletTab.earn, l10n.walletTabEarn),
      (WalletTab.spend, l10n.walletTabSpend),
      (WalletTab.history, l10n.walletTabHistory),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
        vertical: 8,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(NinjaRadius.pill),
        ),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: AppPressable(
                  onTap: () => onChanged(tab.$1),
                  semanticsLabel: tab.$2,
                  semanticsSelected: value == tab.$1,
                  child: AnimatedContainer(
                    duration:
                        MediaQuery.disableAnimationsOf(context) ||
                            MediaQuery.accessibleNavigationOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    constraints: const BoxConstraints(
                      minHeight: NinjaMetrics.minTouchTarget,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: value == tab.$1
                          ? colors.brand
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(NinjaRadius.pill),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tab.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: NinjaText.buttonSmall.copyWith(
                        color: value == tab.$1
                            ? colors.onBrand
                            : colors.mutedDark,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
