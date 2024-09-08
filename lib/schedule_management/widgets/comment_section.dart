import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class CommentSection<T> extends StatelessWidget {
  final (UID, T, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const CommentSection({
    Key? key,
    required this.schedule,
    required this.state,
    required this.scheduleType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uniqueKey = '${schedule.$1}_$scheduleType';
    final scheduleComments = state.scheduleComments.where((comment) => comment.scheduleName == uniqueKey).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...scheduleComments.map(
          (comment) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      comment.text,
                      style: AppTextStyle.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
