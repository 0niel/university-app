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
    final colors = context.colors;
    final l10n = context.l10n;
    final icon = switch (kind) {
      .face => AppLineIcon.face,
      .fingerprint || .iris || .none => AppLineIcon.fingerprint,
    };
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: AppControlSize.iconButton,
                    height: AppControlSize.iconButton,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.tint,
                      shape: BoxShape.circle,
                    ),
                    child: AppLineIconWidget(
                      icon,
                      size: 21,
                      color: colors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.passLockTitle,
                  textAlign: TextAlign.center,
                  style: AppText.headline.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.passLockSubtitle,
                  textAlign: TextAlign.center,
                  style: AppText.subtext.copyWith(
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
