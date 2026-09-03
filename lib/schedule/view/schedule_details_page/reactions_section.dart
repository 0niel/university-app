part of '../schedule_details_page.dart';

class _ReactionsSection extends StatelessWidget {
  const _ReactionsSection({
    required this.loading,
    required this.pending,
    required this.response,
    required this.reviews,
    required this.onReactionTap,
    required this.onReviewTap,
  });

  final bool loading;
  final bool pending;
  final LessonReactionResponse? response;
  final List<LessonReview> reviews;
  final Future<void> Function(String) onReactionTap;
  final VoidCallback onReviewTap;

  Future<void> _showAllReactions(BuildContext context) async {
    final counts = response?.counts ?? const <String, int>{};
    final reaction = await showAppSheet<String>(
      context,
      title: context.l10n.reactionSheetTitle,
      child: Builder(
        builder: (sheetContext) => Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in ReactionType.values)
              AppChip(
                key: ValueKey('lesson-reaction-option-${type.name}'),
                label:
                    '${type.emoji} '
                    '${_reactionLabel(sheetContext.l10n, type.name)}'
                    ' · ${counts[type.name] ?? 0}',
                selected: response?.userReaction == type.name,
                onTap: () => Navigator.of(sheetContext).pop(type.name),
              ),
          ],
        ),
      ),
    );
    if (reaction != null && context.mounted) await onReactionTap(reaction);
  }

  @override
  Widget build(BuildContext context) {
    final counts = response?.counts ?? const <String, int>{};
    final topReview = reviews.firstOrNull;
    const mainReactions = ['brain', 'thinking', 'sleepy', 'fire'];
    final shown = [
      ...mainReactions,
      for (final reaction in _reactionOrder)
        if (!mainReactions.contains(reaction) &&
            ((counts[reaction] ?? 0) > 0 || response?.userReaction == reaction))
          reaction,
    ];

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: context.l10n.lessonHowWasIt,
        ),
        AppStateSwitcher(
          child: loading
              ? const _ReactionsSkeleton(key: ValueKey('reactions_skeleton'))
              : AnimatedOpacity(
                  key: const ValueKey('reactions_chips'),
                  opacity: pending ? 0.5 : 1,
                  duration: NinjaMotion.of(context, NinjaMotion.fast),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                    ),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final reaction in shown)
                          AppChip(
                            key: ValueKey('lesson-reaction-$reaction'),
                            label:
                                '${ReactionType.values.byName(reaction).emoji} '
                                '${_reactionLabel(context.l10n, reaction)} · '
                                '${counts[reaction] ?? 0}',
                            selected: response?.userReaction == reaction,
                            onTap: pending
                                ? null
                                : () => unawaited(onReactionTap(reaction)),
                          ),
                        if (shown.length < ReactionType.values.length)
                          AppChip(
                            key: const ValueKey('lesson-reactions-more'),
                            label: context.l10n.more,
                            leadingIcon: AppLineIcon.plus,
                            enabled: !pending,
                            onTap: pending
                                ? null
                                : () => unawaited(_showAllReactions(context)),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        Padding(
          padding: const .fromLTRB(
            AppSpacing.screen,
            AppSpacing.zero,
            AppSpacing.screen,
            AppSpacing.fieldGap,
          ),
          child: Semantics(
            button: true,
            child: AppPressable(
              onTap: onReviewTap,
              child: AppStateSwitcher(
                child: topReview == null
                    ? const _EmptyReviewPrompt(key: ValueKey('review_empty'))
                    : _ReviewPreview(
                        key: const ValueKey('review_preview'),
                        review: topReview,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _reactionLabel(AppLocalizations l10n, String reaction) =>
    switch (reaction) {
      'brain' => l10n.reactionBrain,
      'thinking' => l10n.reactionThinking,
      'sleepy' => l10n.reactionSleepy,
      'fire' => l10n.reactionFire,
      'love' => l10n.reactionLove,
      'sad' => l10n.reactionSad,
      'flushed' => l10n.reactionFlushed,
      'sick' => l10n.reactionSick,
      'poo' => l10n.reactionPoo,
      'skull' => l10n.reactionSkull,
      'mindblown' => l10n.reactionMindblown,
      'respect' => l10n.reactionRespect,
      _ => reaction,
    };
