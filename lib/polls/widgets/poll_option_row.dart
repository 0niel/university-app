part of 'poll_card.dart';

class _PollOptionRow extends StatelessWidget {
  const _PollOptionRow({
    required this.option,
    required this.poll,
    required this.showResults,
    required this.selected,
    required this.selectable,
    required this.onTap,
  });

  final PollOption option;
  final Poll poll;
  final bool showResults;
  final bool selected;
  final bool selectable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final share = option.share(poll.totalVotes).clamp(0.0, 1.0);
    final isQuizCorrect =
        poll.pollType == .quiz && poll.hasVoted && option.isCorrect;
    final highlight = option.votedByMe || isQuizCorrect;
    final percent = (share * 100).round();

    return Semantics(
      button: selectable,
      enabled: selectable,
      selected: selected || option.votedByMe,
      value: showResults ? l10n.pollsSharePercent(percent) : null,
      child: AppPressable(
        enabled: selectable,
        onTap: selectable ? onTap : null,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: highlight ? colors.brandTint : colors.surfaceAlt,
            borderRadius: BorderRadius.circular(NinjaRadius.control),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  if (!showResults && selectable) ...[
                    _SelectionDot(
                      selected: selected,
                      multi: poll.pollType == .multi,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      option.text,
                      style: NinjaText.body.copyWith(
                        color: colors.ink,
                        fontWeight: highlight
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isQuizCorrect) ...[
                    const SizedBox(width: 8),
                    AppLineIconWidget(
                      AppLineIcon.check,
                      size: 17,
                      color: colors.brandInk,
                    ),
                  ],
                  if (showResults) ...[
                    const SizedBox(width: 8),
                    Text(
                      l10n.pollsSharePercent(percent),
                      style: NinjaText.tabular(
                        NinjaText.buttonSmall.copyWith(
                          color: highlight ? colors.brandInk : colors.mutedDark,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (showResults) ...[
                const SizedBox(height: 9),
                _PollShareBar(value: share, highlight: highlight),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
