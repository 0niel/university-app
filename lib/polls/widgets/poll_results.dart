import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<void> showPollResultsSheet(BuildContext context, {required Poll poll}) {
  return showAppSheet<void>(
    context,
    title: poll.title,
    maxHeightFraction: .92,
    child: PollResults(poll: poll),
  );
}

class PollResults extends StatelessWidget {
  const PollResults({required this.poll, super.key});

  final Poll poll;

  @override
  Widget build(BuildContext context) {
    if (!poll.canSeeResults) {
      return AppBanner(message: context.l10n.pollsResultsHidden);
    }
    if (poll.questions.isEmpty) {
      return NinjaEmptyState(
        title: context.l10n.pollsEmptyQuestions,
        icon: const AppLineIconWidget(AppLineIcon.chart),
      );
    }
    final questions = [...poll.questions]
      ..sort((a, b) => a.position.compareTo(b.position));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, question) in questions.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sectionGap),
          _QuestionResult(question: question),
        ],
      ],
    );
  }
}

class _QuestionResult extends StatelessWidget {
  const _QuestionResult({required this.question});

  final PollQuestion question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.text,
          style: AppText.bodyStrong.copyWith(color: colors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        switch (question.kind) {
          PollQuestionKind.single ||
          PollQuestionKind.quiz ||
          PollQuestionKind.multiple => _ChoiceResults(question: question),
          PollQuestionKind.text => _TextResults(question: question),
          PollQuestionKind.rating => _RatingResults(question: question),
        },
      ],
    );
  }
}

class _ChoiceResults extends StatelessWidget {
  const _ChoiceResults({required this.question});

  final PollQuestion question;

  @override
  Widget build(BuildContext context) {
    final total = question.totalVotes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (total == 0) ...[
          Text(
            context.l10n.pollsResultsNoAnswers,
            style: AppText.caption.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        for (final (index, option) in question.options.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          _OptionResultBar(
            option: option,
            total: total,
            mine: question.myOptionIds.contains(option.id),
            correct: question.kind == PollQuestionKind.quiz && option.isCorrect,
          ),
        ],
      ],
    );
  }
}

class _OptionResultBar extends StatelessWidget {
  const _OptionResultBar({
    required this.option,
    required this.total,
    required this.mine,
    required this.correct,
  });

  final PollOption option;
  final int total;
  final bool mine;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final share = option.share(total).clamp(0.0, 1.0);
    final percent = (share * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (mine) ...[
              AppLineIconWidget(
                AppLineIcon.check,
                size: 14,
                strokeWidth: 2.4,
                color: colors.accent,
              ),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Expanded(
              child: Text(
                option.text,
                style: AppText.bodyStrong.copyWith(
                  color: mine ? colors.accent : colors.ink,
                ),
                semanticsLabel: mine
                    ? '${option.text}, ${l10n.pollsMyChoice}'
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              l10n.pollsSharePercent(percent),
              style: AppText.tabular(
                AppText.bodyStrong.copyWith(
                  color: mine ? colors.accent : colors.muted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        AppProgressBar(
          value: share,
          color: mine ? colors.accent : colors.ink,
        ),
        if (correct)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: AppTag(
              label: l10n.pollsCorrectAnswer,
              tone: AppTagTone.live,
            ),
          ),
      ],
    );
  }
}

class _TextResults extends StatelessWidget {
  const _TextResults({required this.question});

  final PollQuestion question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    if (question.textAnswers.isEmpty) {
      return Text(
        l10n.pollsResultsNoAnswers,
        style: AppText.caption.copyWith(color: colors.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, answer) in question.textAnswers.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.sm),
          AppCard(
            color: colors.surface2,
            radius: AppRadius.tile,
            padding: const EdgeInsets.all(AppSpacing.md),
            width: double.infinity,
            child: Text(
              answer,
              style: AppText.body.copyWith(color: colors.ink),
            ),
          ),
        ],
      ],
    );
  }
}

class _RatingResults extends StatelessWidget {
  const _RatingResults({required this.question});

  final PollQuestion question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final average = question.ratingAverage;
    if (question.ratingCount == 0 || average == null) {
      return Text(
        l10n.pollsResultsNoAnswers,
        style: AppText.caption.copyWith(color: colors.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.pollsRatingAverage(average.toStringAsFixed(1)),
                style: AppText.bodyStrong.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                l10n.pollsRatingResponses(question.ratingCount),
                style: AppText.caption.copyWith(color: colors.muted),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        AppProgressBar(value: (average / 5).clamp(0.0, 1.0)),
        if (question.myRating != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '${l10n.pollsMyChoice}: ${question.myRating}/5',
            style: AppText.caption.copyWith(color: colors.accent),
          ),
        ],
      ],
    );
  }
}
