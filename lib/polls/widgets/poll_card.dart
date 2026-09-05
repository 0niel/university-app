import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/widgets/poll_card_preview.dart';
import 'package:rtu_mirea_app/polls/widgets/poll_creator_sheet.dart';

class PollCard extends StatelessWidget {
  const PollCard({
    required this.poll,
    required this.onOpen,
    this.onOwnerActions,
    this.onChangeAnswers,
    this.onResults,
    super.key,
  });

  final Poll poll;
  final VoidCallback onOpen;
  final VoidCallback? onOwnerActions;
  final VoidCallback? onChangeAnswers;
  final VoidCallback? onResults;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final ended = poll.isEnded;
    final canTake = !poll.iParticipated && !ended;
    final canChange =
        poll.iParticipated &&
        poll.allowChange &&
        !ended &&
        onChangeAnswers != null;
    final category = PollCategory.fromWire(poll.category);
    final author = poll.authorName?.trim();
    final questions = [...poll.questions]
      ..sort((a, b) => a.position.compareTo(b.position));
    final first = questions.firstOrNull;
    final showPreview =
        poll.canSeeResults &&
        (poll.iParticipated || ended) &&
        questions.length == 1 &&
        first != null &&
        (first.kind == PollQuestionKind.single ||
            first.kind == PollQuestionKind.quiz) &&
        first.totalVotes > 0;
    final status = ended
        ? l10n.pollsTagEnded
        : poll.iParticipated
        ? l10n.pollsYouAnswered
        : l10n.pollsStatusOpen;
    final primary = canTake
        ? onOpen
        : poll.canSeeResults
        ? onOpen
        : canChange
        ? onChangeAnswers
        : null;
    final primaryLabel = canTake
        ? l10n.pollsTakeAction
        : poll.canSeeResults
        ? l10n.pollsResultsAction
        : l10n.pollsChangeAnswers;
    final secondary = canTake && poll.canSeeResults
        ? onResults
        : poll.canSeeResults && canChange
        ? onChangeAnswers
        : null;
    final secondaryLabel = canTake
        ? l10n.pollsResultsAction
        : l10n.pollsChangeAnswers;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final expiresAt = poll.expiresAt;
    final metadata = [
      l10n.pollsParticipantsCount(poll.participantsCount),
      if (questions.isNotEmpty) l10n.pollsQuestionsCount(questions.length),
      if (!ended && expiresAt != null)
        l10n.pollsStatusUntil(
          DateFormat(
            'd MMM',
            Localizations.localeOf(context).toString(),
          ).format(expiresAt.toLocal()),
        ),
    ];
    return AppCard(
      onTap: primary,
      onLongPress: onOwnerActions,
      semanticsLabel: poll.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      status,
                      style: AppText.captionStrong.copyWith(
                        color: ended ? colors.muted : colors.accent,
                      ),
                    ),
                    if (category != null)
                      Text(
                        pollCategoryLabel(l10n, category),
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    if (poll.isAnonymous)
                      Text(
                        l10n.pollsTagAnonymous,
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                  ],
                ),
              ),
              if (onOwnerActions != null)
                AppIconButton(
                  tooltip: l10n.pollsOwnerActions,
                  size: AppIconButtonSize.small,
                  onPressed: onOwnerActions,
                  icon: const AppLineIconWidget(AppLineIcon.more),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            poll.title,
            maxLines: largeText ? 5 : 3,
            overflow: TextOverflow.ellipsis,
            style: AppText.title.copyWith(color: colors.ink),
          ),
          if (poll.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              poll.description.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.subtext.copyWith(color: colors.muted, height: 1.4),
            ),
          ],
          if (first != null && first.text.trim() != poll.title.trim()) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              first.text,
              maxLines: largeText ? 4 : 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyStrong.copyWith(color: colors.ink),
            ),
          ],
          if (showPreview) ...[
            const SizedBox(height: AppSpacing.md),
            PollCardPreview(question: first),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            metadata.join(' · '),
            style: AppText.caption.copyWith(color: colors.muted),
          ),
          if (author != null && author.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.muted2),
            ),
          ],
          if (primary != null) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton.tonal(
                  label: primaryLabel,
                  onPressed: primary,
                  size: AppButtonSize.small,
                ),
                if (secondary != null)
                  AppButton.text(
                    label: secondaryLabel,
                    onPressed: secondary,
                    size: AppButtonSize.small,
                  ),
              ],
            ),
          ],
          if (!canTake && !poll.canSeeResults) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.pollsResultsHidden,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
        ],
      ),
    );
  }
}
