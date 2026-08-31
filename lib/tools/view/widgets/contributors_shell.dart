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
    final colors = context.ninja;
    final l10n = context.l10n;
    final onBecomeContributor = this.onBecomeContributor;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          Row(
            spacing: 10,
            children: [
              AppLineIconWidget(.people, size: 16, color: colors.ink),
              Expanded(
                child: loading
                    ? const NinjaSkeleton(width: 140, height: 16)
                    : Text(
                        l10n.toolsContributorsCount(contributors.length),
                        style: NinjaText.headline.copyWith(
                          color: colors.ink,
                          fontWeight: .w600,
                        ),
                      ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxWidth < 360 ||
                  MediaQuery.textScalerOf(context).scale(14) > 19;
              final avatars = loading
                  ? const AvatarStackSkeleton()
                  : AvatarStack(contributors: contributors);
              final button = BecomeContributorButton(
                onTap: () =>
                    onBecomeContributor?.call(ToolsLinksConfig.repoUrl),
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 14,
                  children: [
                    avatars,
                    Align(child: button),
                  ],
                );
              }
              return Row(
                spacing: 12,
                children: [
                  Expanded(child: avatars),
                  button,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
