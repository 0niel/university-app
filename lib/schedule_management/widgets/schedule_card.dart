import 'package:collection/collection.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleCard<T> extends StatelessWidget {
  final (UID, T, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.state,
    required this.scheduleType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = SelectedSchedule.isScheduleSelected<T>(state.selectedSchedule, schedule.$2);
    return Dismissible(
      key: Key('${schedule.$1}_$scheduleType'),
      direction: isSelected ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (_) {
        if (!isSelected) {
          context.read<ScheduleBloc>().add(
                DeleteSchedule(
                  identifier: schedule.$1,
                  target: SelectedSchedule.toScheduleTarget(
                    SelectedSchedule.createSelectedSchedule<T>(schedule.$2, schedule.$3).type,
                  ),
                ),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Расписание удалено')),
          );
        }
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        child: PlatformInkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.read<ScheduleBloc>().add(
                  SetSelectedSchedule(
                    selectedSchedule: SelectedSchedule.createSelectedSchedule<T>(
                      schedule.$2,
                      schedule.$3,
                    ),
                  ),
                );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        SelectedSchedule.getScheduleName<T>(schedule.$2),
                        style: AppTextStyle.titleM,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isSelected)
                      IconButton(
                        icon: Animate(
                          child: Icon(
                            Icons.check_circle,
                            color: Theme.of(context).extension<AppColors>()!.primary,
                          ),
                        ).fadeIn(duration: 200.ms),
                        onPressed: () {
                          context.read<ScheduleBloc>().add(
                                SetSelectedSchedule(
                                  selectedSchedule: SelectedSchedule.createSelectedSchedule<T>(
                                    schedule.$2,
                                    schedule.$3,
                                  ),
                                ),
                              );
                        },
                      ),
                    IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedNoteEdit,
                        color: Theme.of(context).extension<AppColors>()!.active,
                      ),
                      onPressed: () => _showSetCommentBottomSheet(
                        context,
                        state.scheduleComments
                            .firstWhereOrNull(
                              (comment) => comment.scheduleName == '${schedule.$1}_$scheduleType',
                            )
                            ?.text,
                      ),
                    ),
                  ],
                ),
                if (_hasComments(context)) ...[
                  CommentSection<T>(schedule: schedule, state: state, scheduleType: scheduleType)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slide(duration: 400.ms),
                  const SizedBox(height: 8)
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _hasComments(BuildContext context) {
    final uniqueKey = '${schedule.$1}_$scheduleType';
    return state.scheduleComments.any((comment) => comment.scheduleName == uniqueKey);
  }

  void _showSetCommentBottomSheet(BuildContext context, String? currentComment) {
    final scheduleBloc = context.read<ScheduleBloc>();

    BottomModalSheet.show(
      context,
      child: SetCommentBottomSheetContent(
        schedule: schedule,
        initialComment: currentComment,
        onConfirm: (text) {
          final uniqueKey = '${schedule.$1}_$scheduleType';
          final comment = ScheduleComment(
            scheduleName: uniqueKey,
            text: text ?? '',
          );

          if (text == null || text.isEmpty) {
            scheduleBloc.add(RemoveScheduleComment(uniqueKey));
          } else {
            scheduleBloc.add(SetScheduleComment(comment));
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text == null ? 'Комментарий удален' : 'Комментарий сохранен'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
      title: 'Редактировать комментарий',
      description: 'Добавьте или удалите комментарий для группы, преподавателя или аудитории.',
    );
  }
}
