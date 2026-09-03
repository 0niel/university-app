part of 'contributors_card.dart';

class _ContributorsShell extends StatelessWidget {
  const _ContributorsShell({
    required this.loading,
    required this.contributors,
    this.onBecomeContributor,
  });

  final bool loading;
  final List<Contributor> contributors;
  final ValueChanged<String>? onBecomeContributor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final onBecomeContributor = this.onBecomeContributor;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          Row(
            spacing: 10,
            children: [
              AppLineIconWidget(
                .people,
                size: AppIconSize.sm,
                color: colors.ink,
              ),
              Expanded(
                child: loading
                    ? const NinjaSkeleton(width: 140, height: 16)
                    : Text(
                        l10n.toolsContributorsCount(contributors.length),
                        style: AppText.headline.copyWith(
                          color: colors.ink,
                          fontWeight: .w600,
                        ),
                      ),
              ),
            ],
          ),
          if (loading)
            const AvatarStackSkeleton()
          else
            AvatarStack(contributors: contributors),
          BecomeContributorButton(
            onTap: () => onBecomeContributor?.call(ToolsLinksConfig.repoUrl),
          ),
        ],
      ),
    );
  }
}
