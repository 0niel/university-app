import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/schedule_comment.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart' show ScheduleState, UID;
import 'package:university_app_server_api/client.dart';

class CommentSection extends StatelessWidget {
  final (UID, dynamic, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const CommentSection({super.key, required this.schedule, required this.state, required this.scheduleType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final uniqueKey = '${schedule.$1}_$scheduleType';
    final comment = state.scheduleComments.firstWhere(
      (comment) => comment.scheduleName == uniqueKey,
      orElse: () => ScheduleComment(scheduleName: uniqueKey, text: ''),
    );

    if (comment.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.1), width: 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.comment_outlined, size: 16, color: theme.colorScheme.primary.withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Text(
                    'Комментарий',
                    style: AppTextStyle.body.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: appColors.active.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: appColors.active.withOpacity(0.08)),
                ),
                child: Text(
                  comment.text,
                  style: AppTextStyle.body.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.75)),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 350.ms)
        .scale(
          begin: const Offset(0.97, 0.97),
          end: const Offset(1.0, 1.0),
          duration: 350.ms,
          curve: Curves.easeOutQuad,
        );
  }
}
