import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

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

  String _categoryLabel(AppLocalizations l10n, PollCategory category) =>
      switch (category) {
        PollCategory.general => l10n.pollsCategoryGeneral,
        PollCategory.academic => l10n.pollsCategoryAcademic,
        PollCategory.events => l10n.pollsCategoryEvents,
        PollCategory.feedback => l10n.pollsCategoryFeedback,
        PollCategory.other => l10n.pollsCategoryOther,
      };

  (String, AppTagTone) _status(BuildContext context) {
    final l10n = context.l10n;
    if (poll.isEnded) return (l10n.pollsTagEnded, AppTagTone.mute);
    final expiresAt = poll.expiresAt;
    if (expiresAt == null) return (l10n.pollsStatusOpen, AppTagTone.accent);
    final locale = Localizations.localeOf(context).toString();
    final date = DateFormat('d MMM', locale).format(expiresAt.toLocal());
    return (l10n.pollsStatusUntil(date), AppTagTone.warn);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final category = PollCategory.fromWire(poll.category);
    final (statusLabel, statusTone) = _status(context);
    final author = poll.authorName?.trim();
    final authorLabel = (author == null || author.isEmpty)
        ? l10n.pollsAuthorAnonymous
        : author;
    final canTake = !poll.iParticipated && !poll.isEnded;
    final resultsEnabled = poll.canSeeResults || poll.isMine;
    final buttonEnabled = canTake || resultsEnabled;
    return AppCard(
      radius: AppRadius.row,
      onLongPress: onOwnerActions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (MediaQuery.textScalerOf(context).scale(1) > 1.3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xxs,
                  children: [
                    if (category != null)
                      AppTag(
                        label: _categoryLabel(l10n, category),
                        tone: AppTagTone.info,
                      ),
                    AppTag(label: statusLabel, tone: statusTone),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  authorLabel,
                  style: AppText.captionStrong.copyWith(color: colors.muted),
                ),
              ],
            )
          else
            Row(
              children: [
                if (category != null) ...[
                  AppTag(
                    label: _categoryLabel(l10n, category),
                    tone: AppTagTone.info,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    authorLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.captionStrong.copyWith(color: colors.muted),
                  ),
                ),
                const SizedBox(width: AppSpacing.gap),
                AppTag(label: statusLabel, tone: statusTone),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            poll.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.sans(
              16,
              FontWeight.w700,
            ).copyWith(color: colors.ink),
          ),
          if (poll.description.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              poll.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.xxs,
                  runSpacing: AppSpacing.xxs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppLineIconWidget(
                      AppLineIcon.people,
                      size: 15,
                      color: colors.muted2,
                    ),
                    Text(
                      l10n.pollsParticipantsCount(poll.participantsCount),
                      style: AppText.caption.copyWith(color: colors.muted),
                    ),
                    if (poll.iParticipated)
                      AppTag(
                        label: l10n.pollsYouAnswered,
                        tone: AppTagTone.accent,
                      ),
                  ],
                ),
              ),
              if (onOwnerActions != null)
                AppIconButton(
                  tooltip: l10n.pollsOwnerActions,
                  size: AppIconButtonSize.small,
                  shape: AppIconButtonShape.circle,
                  onPressed: onOwnerActions,
                  icon: const AppLineIconWidget(AppLineIcon.more, size: 17),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: canTake ? l10n.pollsTakeAction : l10n.pollsResultsAction,
            size: AppButtonSize.small,
            expanded: true,
            onPressed: buttonEnabled ? onOpen : null,
          ),
          if (canTake && poll.canSeeResults && onResults != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton.text(
              label: l10n.pollsResultsAction,
              onPressed: onResults,
            ),
          ],
          if (poll.iParticipated &&
              poll.allowChange &&
              !poll.isEnded &&
              onChangeAnswers != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton.secondary(
              label: l10n.pollsChangeAnswers,
              expanded: true,
              size: AppButtonSize.small,
              onPressed: onChangeAnswers,
            ),
          ],
        ],
      ),
    );
  }
}
