import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:flutter/widgets.dart';

class AppStreakCalendarCard extends StatelessWidget {
  const AppStreakCalendarCard({
    required this.streakDays,
    required this.history,
    required this.streakDaysLabel,
    required this.streakWordLabel,
    required this.hintLabel,
    required this.daysAgoLabel,
    required this.todayLabel,
    super.key,
    this.recordLabel,
    this.recordDays,
  });

  final int streakDays;
  final List<bool> history;
  final String streakDaysLabel;
  final String streakWordLabel;
  final String hintLabel;
  final String? recordLabel;
  final String daysAgoLabel;
  final String todayLabel;
  final int? recordDays;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final todayIndex = history.length - 1;
    final recordLabel = this.recordLabel;
    final miniLabel = AppText.sans(9, FontWeight.w500).copyWith(
      color: colors.muted2,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              style: AppText.tabular(AppText.title).copyWith(color: colors.ink),
              children: [
                TextSpan(text: streakDaysLabel),
                TextSpan(
                  text: streakWordLabel,
                  style: AppText.body.copyWith(color: colors.muted2),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            recordDays != null && recordLabel != null ? recordLabel : hintLabel,
            style: AppText.caption.copyWith(color: colors.muted2),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          Row(
            children: [
              for (var index = 0; index < history.length; index++) ...[
                if (index != 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _StreakCell(
                    active: history[index],
                    isToday: index == todayIndex,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xsm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(daysAgoLabel, style: miniLabel),
              Text(todayLabel, style: miniLabel),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakCell extends StatelessWidget {
  const _StreakCell({required this.active, required this.isToday});

  final bool active;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color =
        active ? (isToday ? colors.accent : colors.lecture) : colors.surface2;

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.focusOutline),
          border: isToday && !active
              ? Border.all(color: colors.accent, width: 2)
              : null,
        ),
      ),
    );
  }
}
