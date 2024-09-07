import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';
import 'package:rtu_mirea_app/presentation/widgets/bottom_modal_sheet.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleCard<T> extends StatelessWidget {
  final (UID, T, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    required this.state,
    required this.scheduleType,
  }) : super(key: key);

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isSelected ? AppTheme.colorsOf(context).primary.withOpacity(0.05) : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    SelectedSchedule.getScheduleName<T>(schedule.$2),
                    style: AppTextStyle.titleM,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppTheme.colorsOf(context).primary : null,
                    ),
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
                      icon: HugeIcons.strokeRoundedNote01,
                      color: AppTheme.colorsOf(context).active,
                    ),
                    onPressed: () => _showAddCommentBottomSheet(context),
                  ),
                ],
              ),
              if (_hasComments(context)) ...[
                CommentSection<T>(schedule: schedule, state: state, scheduleType: scheduleType),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _hasComments(BuildContext context) {
    final uniqueKey = '${schedule.$1}_$scheduleType';
    return state.scheduleComments.any((comment) => comment.scheduleName == uniqueKey);
  }

  void _showAddCommentBottomSheet(BuildContext context) {
    BottomModalSheet.show(
      context,
      child: AddCommentBottomSheetContent(
        schedule: schedule,
        onConfirm: (text) {
          final uniqueKey = '${schedule.$1}_$scheduleType';
          final comment = ScheduleComment(scheduleName: uniqueKey, text: text);
          context.read<ScheduleBloc>().add(AddScheduleComment(comment));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Комментарий добавлен'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      title: 'Добавить комментарий',
      description: 'Добавьте комментарий для группы, преподавателя или аудитории.',
    );
  }
}
