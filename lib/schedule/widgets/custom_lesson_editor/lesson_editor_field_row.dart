import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';

class LessonEditorFieldRow extends StatelessWidget {
  const LessonEditorFieldRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.muted = false,
    this.stacked = false,
    this.divider = true,
    super.key,
  });

  final AppLineIcon icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool muted;
  final bool stacked;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final useStackedLayout =
        stacked || MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$label, $value',
      child: Container(
        constraints: const BoxConstraints(
          minHeight: AppControlSize.touchTarget,
        ),
        padding: const .symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sectionGap,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            AppLineIconWidget(icon, size: 20, color: colors.muted),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: useStackedLayout
                  ? _buildStackedValue(context)
                  : _buildInlineValue(context),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppLineIconWidget(.chevronR, size: 16, color: colors.muted2),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedValue(BuildContext context) {
    final colors = context.colors;
    return Column(
      spacing: ScheduleMetrics.compactGap,
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: AppText.captionSmall.copyWith(color: colors.muted),
        ),
        Text(
          value,
          maxLines: 2,
          overflow: .ellipsis,
          style: AppText.body.copyWith(
            color: muted ? colors.muted : colors.ink,
            fontWeight: muted ? .w500 : .w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInlineValue(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppText.captionSmall.copyWith(color: colors.muted),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: .ellipsis,
            style: AppText.tabular(
              AppText.body.copyWith(
                color: colors.ink,
                fontWeight: .w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
