part of 'search_zero_state.dart';

class _SearchDiscoveryIntro extends StatelessWidget {
  const _SearchDiscoveryIntro({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      padding: const .all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: NinjaMetrics.minTouchTarget,
            height: NinjaMetrics.minTouchTarget,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.brandTint,
              borderRadius: .circular(AppRadius.md),
            ),
            child: AppLineIconWidget(.search, size: 20, color: colors.brand),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: NinjaText.title.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
