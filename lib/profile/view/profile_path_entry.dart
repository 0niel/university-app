part of 'profile_page.dart';

class _ProfilePathEntry extends StatelessWidget {
  const _ProfilePathEntry({
    required this.questsDone,
    required this.questsTotal,
    required this.groupRank,
    required this.onTap,
  });

  final int questsDone;
  final int questsTotal;
  final int? groupRank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final details = <String>[
      if (questsTotal > 0) '$questsDone / $questsTotal',
      if (groupRank case final rank?) '#$rank',
    ];
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: Semantics(
        button: true,
        label: l10n.ninjaPathTitle,
        child: AppPressable(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.accentSoft,
              borderRadius: .circular(NinjaRadius.card),
            ),
            child: Padding(
              padding: const .fromLTRB(16, 16, 12, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: colors.onAccentSoft.withValues(alpha: .12),
                      borderRadius: .circular(14),
                    ),
                    child: AppLineIconWidget(
                      .spark,
                      size: 21,
                      color: colors.onAccentSoft,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          l10n.ninjaPathTitle,
                          style: NinjaText.headline.copyWith(
                            color: colors.onAccentSoft,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          [
                            l10n.profileQuestsOfDay,
                            if (details.isNotEmpty) details.join(' · '),
                          ].join('  '),
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: NinjaText.subtext.copyWith(
                            color: colors.onAccentSoftMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppLineIconWidget(
                    .chevronR,
                    size: 16,
                    color: colors.onAccentSoftMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
