part of '../changes_page.dart';

class _SubscribeBanner extends StatelessWidget {
  const _SubscribeBanner({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      padding: const .fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Row(
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              shape: .circle,
            ),
            child: AppLineIconWidget(
              .bell,
              size: 19,
              color: colors.mutedDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.changesPushBanner,
              style: NinjaText.subtext.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(width: 12),
          NinjaSwitch(
            value: enabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
