part of 'nfc_pass_card.dart';

class _NfcCardContent extends StatelessWidget {
  const _NfcCardContent({
    required this.passId,
    required this.emulationOff,
  });

  final String passId;
  final bool emulationOff;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final foreground = AppColors.dark.ink;
    final identifier = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.nfcPassIdField,
          style: AppText.caption.copyWith(
            color: foreground.withValues(alpha: .78),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _maskId(passId),
          style: AppText.code.copyWith(color: foreground),
        ),
      ],
    );
    final status = AppBadge(
      label: emulationOff ? l10n.biometricOff : l10n.nfcPassActiveStatus,
      tone: emulationOff ? AppBadgeTone.warn : AppBadgeTone.lecture,
      dot: true,
      textStyle: AppText.caption.copyWith(color: foreground),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: AppSpacing.xsm,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.nfcPass,
                  style: AppText.sectionSmall.copyWith(color: foreground),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              ExcludeSemantics(
                child: AppLineIconWidget(
                  AppLineIcon.contactless,
                  color: AppColors.dark.accent,
                  size: AppIconSize.xl,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxlg),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [identifier, status],
          ),
        ],
      ),
    );
  }

  String _maskId(String id) {
    if (id.length <= 4) return id;
    final first = id.substring(0, 2);
    final last = id.substring(id.length - 2);
    return '$first ${'•' * (id.length - 4).clamp(2, 6)} $last';
  }
}
