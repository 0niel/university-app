import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/lesson_field_change_chip.dart';
import 'package:schedule/schedule.dart';

class LessonFieldChangesPanel extends StatelessWidget {
  const LessonFieldChangesPanel({required this.changes, super.key});
  final List<LessonFieldChange> changes;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scale = Theme.of(context).scale;
    return Container(
      padding: .all(scale.space(16)),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.1),
        borderRadius: .circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              AppLineIconWidget(
                AppLineIcon.info,
                color: colors.muted,
                size: scale.icon(16),
              ),
              SizedBox(width: scale.space(6)),
              Text(
                'Детали изменений',
                style: AppText.subtext.copyWith(
                  color: colors.muted,
                  fontWeight: .w600,
                ),
              ),
            ],
          ),
          SizedBox(height: scale.space(8)),
          Wrap(
            spacing: scale.space(8),
            runSpacing: scale.space(8),
            children: changes
                .map((c) => LessonFieldChangeChip(change: c))
                .toList(),
          ),
        ],
      ),
    );
  }
}
