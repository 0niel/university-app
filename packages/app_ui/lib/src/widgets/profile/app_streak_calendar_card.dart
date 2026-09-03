import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_activity_heatmap.dart';
import 'package:app_ui/src/widgets/app_card.dart';
import 'package:flutter/widgets.dart';

class AppStreakCalendarCard extends StatelessWidget {
  const AppStreakCalendarCard({
    required this.streakDays,
    required this.days,
    required this.streakDaysLabel,
    required this.streakWordLabel,
    required this.hintLabel,
    super.key,
    this.recordLabel,
    this.today,
    this.weekdayLabels,
    this.monthLabelBuilder,
    this.tooltipBuilder,
    this.legendLessLabel,
    this.legendMoreLabel,
    this.trailing,
  });

  final int streakDays;
  final List<AppHeatmapDay> days;
  final String streakDaysLabel;
  final String streakWordLabel;
  final String hintLabel;
  final String? recordLabel;
  final DateTime? today;
  final List<String?>? weekdayLabels;
  final String Function(DateTime monthStart)? monthLabelBuilder;
  final String Function(DateTime day, int count)? tooltipBuilder;
  final String? legendLessLabel;
  final String? legendMoreLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final recordLabel = this.recordLabel;

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
            recordLabel ?? hintLabel,
            style: AppText.caption.copyWith(color: colors.muted2),
          ),
          if (days.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            AppActivityHeatmap(
              days: days,
              today: today,
              weekdayLabels: weekdayLabels,
              monthLabelBuilder: monthLabelBuilder,
              tooltipBuilder: tooltipBuilder,
              legendLessLabel: legendLessLabel,
              legendMoreLabel: legendMoreLabel,
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(height: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
