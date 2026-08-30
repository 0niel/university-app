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
    final colors = context.ninja;
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
                dimension: NinjaMetrics.minTouchTarget,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isCorrect ? colors.brand : colors.surfaceAlt,
                      shape: BoxShape.circle,
                    ),
                    child: isCorrect
                        ? AppLineIconWidget(
                            AppLineIcon.check,
                            size: 13,
                            color: colors.onBrand,
                            strokeWidth: 3,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
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
            padding: const EdgeInsets.only(left: 8),
            child: Tooltip(
              message: l10n.pollsRemoveOption,
              child: AppPressable(
                onTap: onRemove,
                child: SizedBox.square(
                  dimension: NinjaMetrics.minTouchTarget,
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
