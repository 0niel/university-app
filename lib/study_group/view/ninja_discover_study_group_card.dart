import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

class NinjaDiscoverStudyGroupCard extends StatelessWidget {
  const NinjaDiscoverStudyGroupCard({
    required this.group,
    required this.requested,
    required this.onRequest,
    super.key,
  });

  final StudyGroupSummary group;
  final bool requested;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        10,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: .circular(NinjaRadius.control),
                ),
                child: Text(group.emoji, style: const TextStyle(fontSize: 22)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      group.name,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.headline.copyWith(color: colors.ink),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        l10n.studyGroupMembersCount(group.memberCount),
                        if (group.ownerName.isNotEmpty)
                          l10n.studyGroupOwnerName(group.ownerName),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: NinjaText.subtext.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              if (requested)
                NinjaBadge(l10n.studyGroupRequested, tone: .ink)
              else
                NinjaButton.primary(
                  label: l10n.studyGroupRequestJoin,
                  size: .small,
                  onPressed: onRequest,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
