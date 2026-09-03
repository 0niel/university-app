part of 'search_zero_state.dart';

class _SearchDiscoveryIntro extends StatelessWidget {
  const _SearchDiscoveryIntro({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      padding: const .all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: AppControlSize.iconButton,
            height: AppControlSize.iconButton,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.tint,
              borderRadius: .circular(AppRadius.md),
            ),
            child: AppLineIconWidget(
              .search,
              size: AppIconSize.md,
              color: colors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: AppText.title.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
