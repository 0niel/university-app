part of '../changes_page.dart';

class _SubscribeBanner extends StatelessWidget {
  const _SubscribeBanner({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Container(
            width: AppControlSize.touchTarget,
            height: AppControlSize.touchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              .bell,
              size: 19,
              color: colors.muted,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              context.l10n.changesPushBanner,
              style: AppText.subtext.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppSwitch(
            value: enabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
