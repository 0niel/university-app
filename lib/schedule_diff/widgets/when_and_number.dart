import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:schedule/schedule.dart';

class WhenAndNumber extends StatelessWidget {
  const WhenAndNumber({required this.lessonBells, super.key});
  final LessonBells lessonBells;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    String two(int n) => n.toString().padLeft(2, '0');
    String formatTime(TimeOfDay time) =>
        '${two(time.hour)}:${two(time.minute)}';
    final start = formatTime(lessonBells.startTime);
    final end = formatTime(lessonBells.endTime);
    return Row(
      children: [
        AppLineIconWidget(
          AppLineIcon.clock,
          color: colors.muted,
          size: scale.icon(14),
        ),
        SizedBox(width: scale.space(8)),
        Text(
          '$start - $end',
          style: NinjaText.subtext.copyWith(
            color: colors.muted,
            fontWeight: .w500,
          ),
        ),
        if (lessonBells.number != null) ...[
          SizedBox(width: scale.space(16)),
          Container(
            padding: .symmetric(
              horizontal: scale.space(12),
              vertical: scale.space(8),
            ),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.5),
              borderRadius: .circular(scale.radius(4)),
            ),
            child: Text(
              '${lessonBells.number} пара',
              style: NinjaText.helper.copyWith(
                color: colors.muted,
                fontWeight: .w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
