part of 'study_group_page.dart';

class NinjaStudyGroupRequestCard extends StatelessWidget {
  const NinjaStudyGroupRequestCard({
    required this.request,
    required this.onAccept,
    required this.onDecline,
    this.pending = false,
    super.key,
  });

  final StudyGroupJoinRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final handle = request.handle;
    return Padding(
      padding: const .only(bottom: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(AppRadius.card),
        ),
        child: Padding(
          padding: const .all(16),
          child: Row(
            spacing: 14,
            children: [
              NinjaAvatar(initials: ninjaInitials(request.fullName)),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      request.fullName,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: AppText.headline.copyWith(color: colors.ink),
                    ),
                    if (handle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        '@$handle',
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppText.subtext.copyWith(color: colors.muted),
                      ),
                    ],
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: pending ? 0.5 : 1,
                duration: NinjaMotion.of(context, NinjaMotion.fast),
                child: Row(
                  spacing: 6,
                  children: [
                    NinjaIconButton(
                      icon: AppLineIconWidget(
                        .check,
                        size: 20,
                        color: colors.accent,
                      ),
                      tooltip: l10n.studyGroupAccept,
                      onPressed: pending ? null : onAccept,
                    ),
                    NinjaIconButton(
                      icon: AppLineIconWidget(
                        .close,
                        size: 20,
                        color: colors.exam,
                      ),
                      tooltip: l10n.studyGroupDecline,
                      onPressed: pending ? null : onDecline,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
