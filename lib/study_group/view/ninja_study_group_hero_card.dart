part of 'study_group_page.dart';

class NinjaStudyGroupHeroCard extends StatelessWidget {
  const NinjaStudyGroupHeroCard({required this.group, super.key});

  final StudyGroup group;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final description = group.description;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: .circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              spacing: 14,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.onAccentSoft.withValues(alpha: .12),
                    borderRadius: .circular(NinjaRadius.control),
                  ),
                  child: Text(
                    group.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        group.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: NinjaText.title.copyWith(
                          color: colors.onAccentSoft,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.studyGroupMembersCount(group.memberCount),
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: NinjaText.subtext.copyWith(
                          color: colors.onAccentSoftMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                maxLines: 3,
                overflow: .ellipsis,
                style: NinjaText.subtext.copyWith(
                  color: colors.onAccentSoftMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
