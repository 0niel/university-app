part of 'poll_creator_sheet.dart';

class _OptionField extends StatelessWidget {
  const _OptionField({
    required this.controller,
    required this.hint,
    required this.isQuiz,
    required this.isCorrect,
    required this.onMarkCorrect,
    required this.canRemove,
    required this.onRemove,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final bool isQuiz;
  final bool isCorrect;
  final VoidCallback onMarkCorrect;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Row(
      children: [
        if (isQuiz) ...[
          Semantics(
            button: true,
            selected: isCorrect,
            label: '$hint, ${l10n.pollsTypeQuiz}',
            child: AppPressable(
              onTap: onMarkCorrect,
              child: SizedBox.square(
                dimension: AppControlSize.iconButton,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCorrect ? colors.accent : colors.surface2,
                      shape: BoxShape.circle,
                    ),
                    child: isCorrect
                        ? AppLineIconWidget(
                            AppLineIcon.check,
                            size: 13,
                            color: colors.onAccent,
                            strokeWidth: 3,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.gap),
        ],
        Expanded(
          child: NinjaInput(
            controller: controller,
            maxLength: 80,
            placeholder: hint,
          ),
        ),
        if (canRemove)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Tooltip(
              message: l10n.pollsRemoveOption,
              child: AppPressable(
                onTap: onRemove,
                child: SizedBox.square(
                  dimension: AppControlSize.iconButton,
                  child: Center(
                    child: AppLineIconWidget(
                      .close,
                      size: 16,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
