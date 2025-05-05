import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:app_ui/app_ui.dart';

import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleCard extends StatelessWidget {
  final (UID, dynamic, List<SchedulePart>) schedule;
  final ScheduleState state;
  final String scheduleType;

  const ScheduleCard({super.key, required this.schedule, required this.state, required this.scheduleType});

  @override
  Widget build(BuildContext context) {
    final bool isSelected = SelectedSchedule.isScheduleSelected(state.selectedSchedule, schedule.$2);
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final hasComments = _hasComments(context);

    return Dismissible(
          key: Key('${schedule.$1}_$scheduleType'),
          direction: isSelected ? DismissDirection.none : DismissDirection.endToStart,
          onDismissed: (_) {
            if (!isSelected) {
              context.read<ScheduleBloc>().add(
                DeleteSchedule(
                  identifier: schedule.$1,
                  target: SelectedSchedule.toScheduleTarget(
                    SelectedSchedule.createSelectedSchedule(schedule.$2, schedule.$3).type,
                  ),
                ),
              );
              _showFeedbackSnackBar(context, 'Расписание удалено', isError: false);
            }
          },
          confirmDismiss: (_) async {
            if (isSelected) return false;
            return await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Удаление расписания'),
                    content: const Text('Вы уверены, что хотите удалить это расписание?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Удалить'),
                      ),
                    ],
                  ),
            );
          },
          background: Container(
            decoration: BoxDecoration(color: appColors.error, borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Удалить', style: AppTextStyle.body.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: isSelected ? 1 : 0,
            clipBehavior: Clip.antiAlias,
            color: isSelected ? appColors.primary.withOpacity(0.07) : null,
            child: InkWell(
              onTap: () {
                context.read<ScheduleBloc>().add(
                  SetSelectedSchedule(
                    selectedSchedule: SelectedSchedule.createSelectedSchedule(schedule.$2, schedule.$3),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _buildTypeIcon(context, isSelected),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule.$2.name,
                                style: AppTextStyle.titleM.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? appColors.primary : appColors.active,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(context).withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _getTypeName(),
                                      style: AppTextStyle.captionL.copyWith(
                                        color: _getTypeColor(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),

                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: appColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle, size: 12, color: appColors.primary),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Активно',
                                            style: AppTextStyle.captionL.copyWith(
                                              color: appColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (!isSelected)
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _showOptionsBottomSheet(context),
                            iconSize: 20,
                            splashRadius: 20,
                          )
                        else
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: appColors.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Icon(Icons.check, color: appColors.primary, size: 18)),
                          ),
                      ],
                    ),
                  ),

                  if (hasComments) CommentSection(schedule: schedule, state: state, scheduleType: scheduleType),

                  if (!isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap:
                                () => _showSetCommentBottomSheet(
                                  context,
                                  state.scheduleComments
                                      .firstWhereOrNull(
                                        (comment) => comment.scheduleName == '${schedule.$1}_$scheduleType',
                                      )
                                      ?.text,
                                ),
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    hasComments ? Icons.chat_bubble : Icons.chat_bubble_outline,
                                    size: 14,
                                    color: hasComments ? appColors.primary : appColors.deactive,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    hasComments ? 'Комментарии' : 'Комментарий',
                                    style: AppTextStyle.captionL.copyWith(
                                      fontSize: 12,
                                      color: hasComments ? appColors.primary : appColors.deactive,
                                      fontWeight: hasComments ? FontWeight.w500 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Make active button
                          InkWell(
                            onTap: () {
                              context.read<ScheduleBloc>().add(
                                SetSelectedSchedule(
                                  selectedSchedule: SelectedSchedule.createSelectedSchedule(schedule.$2, schedule.$3),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.visibility_outlined, size: 14, color: appColors.active),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Активировать',
                                    style: AppTextStyle.captionL.copyWith(fontSize: 12, color: appColors.active),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1.0, 1.0),
          duration: 250.ms,
          curve: Curves.easeOutQuad,
        );
  }

  Widget _buildTypeIcon(BuildContext context, bool isSelected) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final color = isSelected ? appColors.primary : _getTypeColor(context);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Center(child: _getTypeIcon(context, isSelected)),
    );
  }

  Widget _getTypeIcon(BuildContext context, bool isSelected) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final color = isSelected ? appColors.primary : _getTypeColor(context);

    switch (scheduleType) {
      case 'group':
        return Icon(Icons.people_outline_rounded, color: color, size: 20);
      case 'teacher':
        return Icon(Icons.person_outline_rounded, color: color, size: 20);
      case 'classroom':
        return Icon(Icons.meeting_room_outlined, color: color, size: 20);
      default:
        return Icon(Icons.calendar_today_outlined, color: color, size: 20);
    }
  }

  Color _getTypeColor(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    switch (scheduleType) {
      case 'group':
        return appColors.primary;
      case 'teacher':
        return Colors.deepPurple;
      case 'classroom':
        return Colors.teal;
      default:
        return appColors.active;
    }
  }

  String _getTypeName() {
    switch (scheduleType) {
      case 'group':
        return 'Группа';
      case 'teacher':
        return 'Преподаватель';
      case 'classroom':
        return 'Аудитория';
      default:
        return 'Расписание';
    }
  }

  bool _hasComments(BuildContext context) {
    final uniqueKey = '${schedule.$1}_$scheduleType';
    return state.scheduleComments.any((comment) => comment.scheduleName == uniqueKey && comment.text.isNotEmpty);
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
          final comment = ScheduleComment(scheduleName: uniqueKey, text: text ?? '');

          if (text == null || text.isEmpty) {
            scheduleBloc.add(RemoveScheduleComment(uniqueKey));
            _showFeedbackSnackBar(context, 'Комментарий удален');
          } else {
            scheduleBloc.add(SetScheduleComment(comment));
            _showFeedbackSnackBar(context, 'Комментарий сохранен');
          }
        },
      ),
      title: 'Комментарий к расписанию',
      description: 'Добавьте или отредактируйте заметку к расписанию',
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.visibility, color: appColors.primary),
                title: const Text('Сделать активным'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ScheduleBloc>().add(
                    SetSelectedSchedule(
                      selectedSchedule: SelectedSchedule.createSelectedSchedule(schedule.$2, schedule.$3),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: appColors.active),
                title: Text(_hasComments(context) ? 'Редактировать комментарий' : 'Добавить комментарий'),
                onTap: () {
                  Navigator.pop(context);
                  _showSetCommentBottomSheet(
                    context,
                    state.scheduleComments
                        .firstWhereOrNull((comment) => comment.scheduleName == '${schedule.$1}_$scheduleType')
                        ?.text,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: appColors.error),
                title: const Text('Удалить расписание'),
                onTap: () async {
                  Navigator.pop(context);
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Удаление расписания'),
                          content: const Text('Вы уверены, что хотите удалить это расписание?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Отмена')),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                  );

                  if (shouldDelete == true) {
                    if (context.mounted) {
                      context.read<ScheduleBloc>().add(
                        DeleteSchedule(
                          identifier: schedule.$1,
                          target: SelectedSchedule.toScheduleTarget(
                            SelectedSchedule.createSelectedSchedule(schedule.$2, schedule.$3).type,
                          ),
                        ),
                      );
                      _showFeedbackSnackBar(context, 'Расписание удалено', isError: false);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeedbackSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: isError ? Colors.red.shade800 : Theme.of(context).extension<AppColors>()!.primary,
      ),
    );
  }
}
