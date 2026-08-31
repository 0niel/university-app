part of 'profile_page.dart';

class _ProfileAccountEntry extends StatelessWidget {
  const _ProfileAccountEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Semantics(
        button: true,
        child: AppPressable(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(NinjaRadius.card),
            ),
            padding: const .fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: .circular(11),
                  ),
                  child: AppLineIconWidget(
                    .settings,
                    size: 18,
                    color: colors.mutedDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.settingsTitle,
                    style: NinjaText.body.copyWith(
                      color: colors.ink,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
