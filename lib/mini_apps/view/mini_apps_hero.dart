part of 'mini_apps_page.dart';

class _MiniAppsHero extends StatelessWidget {
  const _MiniAppsHero({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final icon = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.ink.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: SizedBox.square(
        dimension: AppControlSize.touchTarget,
        child: Center(
          child: AppLineIconWidget(.grid, size: 21, color: colors.ink),
        ),
      ),
    );
    final labels = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.miniAppsCatalogSection,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.headline.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.miniAppsSubtitle(count),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppText.subtext.copyWith(color: colors.muted),
        ),
      ],
    );
    final total = Text(
      '$count',
      style: AppText.tabular(
        AppText.title.copyWith(color: colors.ink),
      ),
    );

    return Semantics(
      container: true,
      label: '${l10n.miniAppsTitle}. ${l10n.miniAppsSubtitle(count)}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.tint2,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: largeText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          icon,
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: labels),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      total,
                    ],
                  )
                : Row(
                    children: [
                      icon,
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: labels),
                      const SizedBox(width: AppSpacing.gap),
                      total,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
