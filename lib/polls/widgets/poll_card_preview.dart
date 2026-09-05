import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PollCardPreview extends StatelessWidget {
  const PollCardPreview({required this.question, super.key});

  final PollQuestion question;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final options = [...question.options]
      ..sort((a, b) => a.position.compareTo(b.position));
    return Column(
      spacing: AppSpacing.sm,
      children: [
        for (final option in options.take(3))
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              Row(
                children: [
                  if (question.myOptionIds.contains(option.id)) ...[
                    AppLineIconWidget(
                      AppLineIcon.check,
                      size: 14,
                      color: colors.accent,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Expanded(
                    child: Text(
                      option.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      semanticsLabel: question.myOptionIds.contains(option.id)
                          ? '${option.text}, ${context.l10n.pollsMyChoice}'
                          : null,
                      style: AppText.subtext.copyWith(color: colors.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n.pollsSharePercent(
                      (option.share(question.totalVotes).clamp(0.0, 1.0) * 100)
                          .round(),
                    ),
                    style: AppText.tabular(
                      AppText.captionStrong.copyWith(color: colors.muted),
                    ),
                  ),
                ],
              ),
              AppProgressBar(
                value: option.share(question.totalVotes).clamp(0.0, 1.0),
                color: question.myOptionIds.contains(option.id)
                    ? colors.accent
                    : colors.muted2,
              ),
            ],
          ),
      ],
    );
  }
}
