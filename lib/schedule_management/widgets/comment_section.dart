import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class CommentSection<T> extends StatelessWidget {
  final (UID, T, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const CommentSection({
    super.key,
    required this.schedule,
    required this.state,
    required this.scheduleType,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueKey = '${schedule.$1}_$scheduleType';
    final scheduleComments = state.scheduleComments.where((comment) => comment.scheduleName == uniqueKey).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...scheduleComments.map(
          (comment) {
            return Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).extension<AppColors>()!.colorful07,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    comment.text,
                    style: AppTextStyle.captionL.copyWith(color: Theme.of(context).extension<AppColors>()!.colorful07),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
