import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/field_info.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/lesson_field_changes_panel.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/when_and_number.dart';
import 'package:schedule/schedule.dart';

class ScheduleDiffItemCard extends StatelessWidget {
  const ScheduleDiffItemCard({
    required this.detail,
    super.key,
    this.isLast = false,
  });

  final LessonChangeDetail detail;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    final color = changeColor(detail.kind, colors);
    return NinjaScheduleSurface(
      color: colors.surfaceAlt,
      padding: .all(scale.space(16)),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Container(
                width: scale.size(36),
                height: scale.size(36),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: AppLineIconWidget(
                  changeIcon(detail.kind),
                  color: color,
                  size: 18,
                ),
              ),
              SizedBox(width: scale.space(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      detail.subject,
                      style: NinjaText.body.copyWith(
                        fontWeight: .bold,
                        color: colors.ink,
                      ),
                    ),
                    SizedBox(height: scale.space(8)),
                    WhenAndNumber(lessonBells: detail.lessonBells),
                  ],
                ),
              ),
              Container(
                padding: .symmetric(
                  horizontal: scale.space(12),
                  vertical: scale.space(8),
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: .circular(NinjaRadius.pill),
                ),
                child: Text(
                  changeLabel(detail.kind, context.l10n),
                  style: NinjaText.helper.copyWith(
                    color: color,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
          if (detail.fieldChanges.isNotEmpty) ...[
            SizedBox(height: scale.space(24)),
            LessonFieldChangesPanel(changes: detail.fieldChanges),
          ],
        ],
      ),
    );
  }
}
