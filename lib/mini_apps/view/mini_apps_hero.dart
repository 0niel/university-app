part of 'mini_apps_page.dart';

class _MiniAppsHero extends StatelessWidget {
  const _MiniAppsHero({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final icon = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.onAccentSoft.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(NinjaRadius.button),
      ),
      child: SizedBox.square(
        dimension: 44,
        child: Center(
          child: AppLineIconWidget(.grid, size: 21, color: colors.onAccentSoft),
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
          style: NinjaText.headline.copyWith(color: colors.onAccentSoft),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.miniAppsSubtitle(count),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: NinjaText.subtext.copyWith(color: colors.onAccentSoftMuted),
        ),
      ],
    );
    final total = Text(
      '$count',
      style: NinjaText.tabular(
        NinjaText.title.copyWith(color: colors.onAccentSoft),
      ),
    );

    return Semantics(
      container: true,
      label: '${l10n.miniAppsTitle}. ${l10n.miniAppsSubtitle(count)}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: largeText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          icon,
                          const SizedBox(width: 12),
                          Expanded(child: labels),
                        ],
                      ),
                      const SizedBox(height: 12),
                      total,
                    ],
                  )
                : Row(
                    children: [
                      icon,
                      const SizedBox(width: 12),
                      Expanded(child: labels),
                      const SizedBox(width: 10),
                      total,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
