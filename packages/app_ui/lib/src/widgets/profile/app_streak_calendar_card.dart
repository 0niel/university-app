import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: AppText.title.copyWith(
                color: colors.active,
                letterSpacing: -0.3,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              children: [
                TextSpan(text: streakDaysLabel),
                TextSpan(
                  text: streakWordLabel,
                  style: AppText.body.copyWith(
                    color: colors.deactiveDarker,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            recordDays != null && recordLabel != null ? recordLabel : hintLabel,
            style: AppText.caption.copyWith(color: colors.deactiveDarker),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var index = 0; index < history.length; index++) ...[
                if (index != 0) const SizedBox(width: 4),
                Expanded(
                  child: _buildStreakCell(
                    active: history[index],
                    isToday: index == todayIndex,
                    colors: colors,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(daysAgoLabel, style: _miniLabel(colors)),
              Text(todayLabel, style: _miniLabel(colors)),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildStreakCell({
  required bool active,
  required bool isToday,
  required AppColors colors,
}) {
  final color =
      active ? (isToday ? colors.primary : colors.success) : colors.surfaceHigh;
  return AspectRatio(
    aspectRatio: 1,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: isToday && !active
            ? Border.all(color: colors.primary, width: 1.5)
            : null,
      ),
    ),
  );
}

TextStyle _miniLabel(AppColors colors) => AppText.captionSmall.copyWith(
      color: colors.deactiveDarker,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );
