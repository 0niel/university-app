part of 'nfc_pass_page.dart';

class _PassLockScreen extends StatelessWidget {
  const _PassLockScreen({
    required this.kind,
    required this.busy,
    required this.onUnlock,
  });

  final BiometricKind kind;
  final bool busy;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final icon = switch (kind) {
      .face => AppLineIcon.face,
      .fingerprint || .iris || .none => AppLineIcon.fingerprint,
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(NinjaMetrics.screenPadding),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: NinjaMetrics.minTouchTarget,
                    height: NinjaMetrics.minTouchTarget,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.brandTint,
                      shape: BoxShape.circle,
                    ),
                    child: AppLineIconWidget(
                      icon,
                      size: 21,
                      color: colors.brandInk,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.passLockTitle,
                  textAlign: TextAlign.center,
                  style: NinjaText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.passLockSubtitle,
                  textAlign: TextAlign.center,
                  style: NinjaText.subtext.copyWith(
                    height: 1.5,
                    color: colors.muted,
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: NinjaButton.primary(
                    label: l10n.passUnlock,
                    size: NinjaButtonSize.large,
                    loading: busy,
                    onPressed: onUnlock,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
