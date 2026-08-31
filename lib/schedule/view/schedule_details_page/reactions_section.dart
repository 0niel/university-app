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

  @override
  Widget build(BuildContext context) {
    final counts = response?.counts ?? const <String, int>{};
    final totalVotes = counts.values.fold(0, (sum, count) => sum + count);
    final topReview = reviews.firstOrNull;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _SectionTitle(
          title: context.l10n.lessonDetailsGroupReactions,
          subtitle: context.l10n.lessonDetailsVotesAnon(totalVotes),
        ),
        NinjaStateSwitcher(
          child: loading
              ? const _ReactionsSkeleton(key: ValueKey('reactions_skeleton'))
              : AnimatedOpacity(
                  key: const ValueKey('reactions_chips'),
                  opacity: pending ? 0.5 : 1,
                  duration: NinjaMotion.of(context, NinjaMotion.fast),
                  child: NinjaChipRow(
                    children: [
                      for (final reaction in _reactionOrder)
                        NinjaChip(
                          label:
                              '${_reactionEmoji[reaction] ?? ''} '
                              '${counts[reaction] ?? 0}',
                          selected: response?.userReaction == reaction,
                          onTap: pending
                              ? null
                              : () => unawaited(onReactionTap(reaction)),
                        ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const .fromLTRB(
            NinjaMetrics.screenPadding,
            0,
            NinjaMetrics.screenPadding,
            18,
          ),
          child: Semantics(
            button: true,
            child: AppPressable(
              onTap: onReviewTap,
              child: NinjaStateSwitcher(
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
