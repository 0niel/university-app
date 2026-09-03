import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PollOptionBar extends StatelessWidget {
  const PollOptionBar({
    required this.option,
    required this.poll,
    required this.showResults,
    required this.selected,
    required this.selectable,
    required this.onTap,
    super.key,
  });

  final PollOption option;
  final Poll poll;
  final bool showResults;
  final bool selected;
  final bool selectable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final share = showResults
        ? option.share(poll.totalVotes).clamp(0.0, 1.0)
        : 0.0;
    final percent = (share * 100).round();
    final correct = poll.pollType == .quiz && poll.hasVoted && option.isCorrect;
    final highlight = option.votedByMe || correct || selected;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    return AppPressable(
      enabled: selectable,
      onTap: selectable ? onTap : null,
      semanticsLabel: option.text,
      semanticsButton: selectable,
      semanticsSelected: selected || option.votedByMe,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: SizedBox(
          height:
              AppControlSize.buttonSmall *
              MediaQuery.textScalerOf(context).scale(1).clamp(1, 2),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    color: highlight ? colors.tint : colors.surface2,
                  ),
                ),
                AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  width: constraints.maxWidth * share,
                  height: double.infinity,
                  color: highlight ? colors.tint2 : colors.surface,
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sectionGap,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyStrong.copyWith(
                              color: highlight ? colors.accent : colors.ink,
                            ),
                          ),
                        ),
                        if (correct) ...[
                          const SizedBox(width: AppSpacing.sm),
                          AppLineIconWidget(
                            AppLineIcon.check,
                            size: 16,
                            strokeWidth: 2.4,
                            color: colors.accent,
                          ),
                        ],
                        if (showResults) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            l10n.pollsSharePercent(percent),
                            style: AppText.tabular(
                              AppText.bodyStrong.copyWith(
                                color: highlight ? colors.accent : colors.ink,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
