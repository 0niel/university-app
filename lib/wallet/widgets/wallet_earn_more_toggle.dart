part of 'wallet_earn_tab.dart';

class WalletEarnMoreToggle extends StatelessWidget {
  const WalletEarnMoreToggle({
    required this.count,
    required this.expanded,
    required this.onTap,
    super.key,
  });

  final int count;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: expanded
          ? l10n.hideLessonAction
          : '${l10n.loginComingSoon} · $count',
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  expanded
                      ? l10n.hideLessonAction
                      : '${l10n.loginComingSoon} · $count',
                  style: NinjaText.body.copyWith(color: colors.muted),
                ),
              ),
              AnimatedRotation(
                turns: expanded ? .5 : 0,
                duration:
                    MediaQuery.disableAnimationsOf(context) ||
                        MediaQuery.accessibleNavigationOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                child: AppLineIconWidget(
                  AppLineIcon.chevronD,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
