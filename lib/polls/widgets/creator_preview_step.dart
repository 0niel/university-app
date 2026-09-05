part of 'poll_creator_sheet.dart';

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    required this.anonymous,
    required this.closesAt,
    required this.onEditBasics,
    required this.onEditQuestion,
  });

  final String title;
  final String description;
  final PollCategory? category;
  final List<_QuestionDraft> questions;
  final bool anonymous;
  final DateTime? closesAt;
  final VoidCallback? onEditBasics;
  final ValueChanged<int>? onEditQuestion;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final at = closesAt;
    final validQuestions = questions
        .where((question) => question.isValid)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (validQuestions == 0) ...[
          AppBanner(
            message: l10n.pollsPreviewEmptyQuestions,
            tone: AppBannerTone.warn,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                title.isEmpty ? l10n.pollsTitleHint : title,
                style: AppText.bodyStrong.copyWith(color: colors.ink),
              ),
            ),
            AppIconButton(
              tooltip: '${l10n.edit}: ${l10n.pollsStepBasics}',
              icon: const AppLineIconWidget(AppLineIcon.pencil),
              tone: AppIconButtonTone.plain,
              onPressed: onEditBasics,
            ),
          ],
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            description,
            style: AppText.caption.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (category != null)
              AppTag(
                label: pollCategoryLabel(l10n, category!),
                tone: AppTagTone.info,
              ),
            if (anonymous) AppTag(label: l10n.pollsTagAnonymous),
            AppTag(
              label: at != null
                  ? l10n.pollsStatusUntil(
                      DateFormat(
                        'd MMM',
                        Localizations.localeOf(context).toString(),
                      ).format(at),
                    )
                  : l10n.pollsClosesAtNone,
              tone: AppTagTone.warn,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final (index, question) in questions.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.pollsQuestionNumber(index + 1)}. '
                  '${_questionText(question)}',
                  style: AppText.bodyStrong.copyWith(color: colors.ink),
                ),
              ),
              AppIconButton(
                tooltip: '${l10n.edit}: ${l10n.pollsQuestionNumber(index + 1)}',
                icon: const AppLineIconWidget(AppLineIcon.pencil),
                tone: AppIconButtonTone.plain,
                onPressed: onEditQuestion == null
                    ? null
                    : () => onEditQuestion!(index),
              ),
            ],
          ),
          if (question.hasOptions)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Text(
                [
                  for (final controller in question.optionControllers)
                    if (controller.text.trim().isNotEmpty)
                      controller.text.trim(),
                ].join(' · '),
                style: AppText.caption.copyWith(color: colors.muted),
              ),
            ),
        ],
      ],
    );
  }

  String _questionText(_QuestionDraft question) {
    final text = question.textController.text.trim();
    return text.isEmpty ? '—' : text;
  }
}
