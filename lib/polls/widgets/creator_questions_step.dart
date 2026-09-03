part of 'poll_creator_sheet.dart';

class _QuestionsStep extends StatelessWidget {
  const _QuestionsStep({
    required this.questions,
    required this.showError,
    required this.onAdd,
    required this.onRemove,
    required this.onMove,
    required this.onKindChanged,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onRequiredChanged,
    required this.onChanged,
  });

  final List<_QuestionDraft> questions;
  final bool showError;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final void Function(int index, int delta) onMove;
  final void Function(int index, PollQuestionKind kind) onKindChanged;
  final ValueChanged<int> onAddOption;
  final void Function(int index, int optionIndex) onRemoveOption;
  final void Function(int index, {required bool value}) onRequiredChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, question) in questions.indexed) ...[
          if (index > 0) const SizedBox(height: AppSpacing.md),
          _QuestionCard(
            key: ValueKey(question),
            index: index,
            question: question,
            showError: showError,
            canRemove: questions.length > 1,
            canMoveUp: index > 0,
            canMoveDown: index < questions.length - 1,
            onRemove: () => onRemove(index),
            onMoveUp: () => onMove(index, -1),
            onMoveDown: () => onMove(index, 1),
            onKindChanged: (kind) => onKindChanged(index, kind),
            onAddOption: () => onAddOption(index),
            onRemoveOption: (optionIndex) => onRemoveOption(index, optionIndex),
            onRequiredChanged: (value) =>
                onRequiredChanged(index, value: value),
            onChanged: onChanged,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        if (questions.length < 10)
          AppButton.secondary(
            label: l10n.pollsAddQuestion,
            icon: const AppLineIconWidget(AppLineIcon.plus, size: 16),
            expanded: true,
            onPressed: onAdd,
          ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.showError,
    required this.canRemove,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onKindChanged,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onRequiredChanged,
    required this.onChanged,
    super.key,
  });

  final int index;
  final _QuestionDraft question;
  final bool showError;
  final bool canRemove;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final ValueChanged<PollQuestionKind> onKindChanged;
  final VoidCallback onAddOption;
  final ValueChanged<int> onRemoveOption;
  final ValueChanged<bool> onRequiredChanged;
  final VoidCallback onChanged;

  String _kindLabel(AppLocalizations l10n, PollQuestionKind kind) =>
      switch (kind) {
        PollQuestionKind.single => l10n.pollsQuestionKindSingle,
        PollQuestionKind.multiple => l10n.pollsQuestionKindMultiple,
        PollQuestionKind.text => l10n.pollsQuestionKindText,
        PollQuestionKind.rating => l10n.pollsQuestionKindRating,
        PollQuestionKind.quiz => l10n.pollsTypeQuiz,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textInvalid =
        showError && question.textController.text.trim().isEmpty;
    final optionsInvalid =
        showError && question.hasOptions && !question.isValid;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sectionGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.pollsQuestionNumber(index + 1),
                    style: AppText.captionStrong.copyWith(
                      color: colors.muted,
                    ),
                  ),
                ),
                if (canMoveUp)
                  AppIconButton(
                    tooltip: l10n.pollsMoveUp,
                    size: AppIconButtonSize.small,
                    shape: AppIconButtonShape.circle,
                    tone: AppIconButtonTone.plain,
                    icon: const AppLineIconWidget(
                      AppLineIcon.chevronU,
                      size: 16,
                    ),
                    onPressed: onMoveUp,
                  ),
                if (canMoveDown)
                  AppIconButton(
                    tooltip: l10n.pollsMoveDown,
                    size: AppIconButtonSize.small,
                    shape: AppIconButtonShape.circle,
                    tone: AppIconButtonTone.plain,
                    icon: const AppLineIconWidget(
                      AppLineIcon.chevronD,
                      size: 16,
                    ),
                    onPressed: onMoveDown,
                  ),
                if (canRemove)
                  AppIconButton(
                    tooltip: l10n.pollsRemoveQuestion,
                    size: AppIconButtonSize.small,
                    shape: AppIconButtonShape.circle,
                    tone: AppIconButtonTone.plain,
                    icon: const AppLineIconWidget(AppLineIcon.trash, size: 16),
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInputField(
              controller: question.textController,
              placeholder: l10n.pollsQuestionTextHint,
              errorText: textInvalid ? l10n.pollsQuestionTextRequired : null,
              maxLength: 300,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final kind in PollQuestionKind.values)
                  AppChip.filter(
                    label: _kindLabel(l10n, kind),
                    selected: question.kind == kind,
                    onTap: () => onKindChanged(kind),
                  ),
              ],
            ),
            if (question.hasOptions) ...[
              const SizedBox(height: AppSpacing.sm),
              for (final (optionIndex, controller)
                  in question.optionControllers.indexed) ...[
                if (optionIndex > 0) const SizedBox(height: AppSpacing.xsm),
                Row(
                  key: ValueKey(controller),
                  children: [
                    if (question.kind == PollQuestionKind.quiz)
                      AppRadio<int>(
                        value: optionIndex,
                        groupValue: question.correctIndex,
                        semanticsLabel:
                            '${l10n.pollsOptionHint(optionIndex + 1)}, '
                            '${l10n.pollsTypeQuiz}',
                        onChanged: (value) {
                          question.correctIndex = value;
                          onChanged();
                        },
                      ),
                    Expanded(
                      child: AppInputField(
                        controller: controller,
                        placeholder: l10n.pollsOptionHint(optionIndex + 1),
                        maxLength: 200,
                        onChanged: (_) => onChanged(),
                      ),
                    ),
                    if (question.optionControllers.length > 2)
                      AppIconButton(
                        tooltip: l10n.pollsRemoveOption,
                        size: AppIconButtonSize.small,
                        shape: AppIconButtonShape.circle,
                        tone: AppIconButtonTone.plain,
                        icon: const AppLineIconWidget(
                          AppLineIcon.close,
                          size: 14,
                        ),
                        onPressed: () => onRemoveOption(optionIndex),
                      ),
                  ],
                ),
              ],
              if (optionsInvalid)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxs),
                  child: Text(
                    l10n.pollsDistinctOptionsRequired,
                    style: AppText.caption.copyWith(color: colors.danger),
                  ),
                ),
              if (question.optionControllers.length < 10)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xsm),
                  child: AppButton.text(
                    label: l10n.pollsAddOption,
                    icon: const AppLineIconWidget(AppLineIcon.plus, size: 14),
                    onPressed: onAddOption,
                  ),
                ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: AppCheckbox(
                value: question.isRequired,
                label: l10n.pollsQuestionRequired,
                onChanged: onRequiredChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
