import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
    final colors = context.ninja;
    final useStackedLayout =
        stacked || MediaQuery.textScalerOf(context).scale(1) > 1.3;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '$label, $value',
      child: Container(
        constraints: const BoxConstraints(
          minHeight: NinjaMetrics.minTouchTarget,
        ),
        padding: const .symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(NinjaRadius.card),
        ),
        child: Row(
          children: [
            AppLineIconWidget(icon, size: 20, color: colors.mutedDark),
            const SizedBox(width: 12),
            Expanded(
              child: useStackedLayout
                  ? _buildStackedValue(context)
                  : _buildInlineValue(context),
            ),
            const SizedBox(width: 8),
            AppLineIconWidget(.chevronR, size: 16, color: colors.chevron),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedValue(BuildContext context) {
    final colors = context.ninja;
    return Column(
      spacing: 3,
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: NinjaText.helper.copyWith(color: colors.muted),
        ),
        Text(
          value,
          maxLines: 2,
          overflow: .ellipsis,
          style: NinjaText.body.copyWith(
            color: muted ? colors.muted : colors.ink,
            fontWeight: muted ? .w500 : .w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInlineValue(BuildContext context) {
    final colors = context.ninja;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: NinjaText.helper.copyWith(color: colors.muted),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: .ellipsis,
            style: NinjaText.tabular(
              NinjaText.body.copyWith(
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
