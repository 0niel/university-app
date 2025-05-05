import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:app_ui/app_ui.dart';

class ComparisonManager extends StatelessWidget {
  const ComparisonManager({super.key});

  String _getScheduleTitle(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.name;
    } else if (schedule is SelectedCustomSchedule) {
      return schedule.name;
    }
    return 'Неизвестно';
  }

  @override
  Widget build(BuildContext context) {
    // Use select instead of builder for more efficient rebuilds
    final savedGroups = context.select((ScheduleBloc bloc) => bloc.state.groupsSchedule);
    final savedTeachers = context.select((ScheduleBloc bloc) => bloc.state.teachersSchedule);
    final savedClassrooms = context.select((ScheduleBloc bloc) => bloc.state.classroomsSchedule);
    final customSchedules = context.select((ScheduleBloc bloc) => bloc.state.customSchedules);
    final comparisonSchedules = context.select((ScheduleBloc bloc) => bloc.state.comparisonSchedules);

    // Pre-compute saved schedules
    final savedSchedules = [
      ...savedGroups.map((e) => SelectedGroupSchedule(group: e.$2, schedule: e.$3)),
      ...savedTeachers.map((e) => SelectedTeacherSchedule(teacher: e.$2, schedule: e.$3)),
      ...savedClassrooms.map((e) => SelectedClassroomSchedule(classroom: e.$2, schedule: e.$3)),
      ...customSchedules.map(
        (e) => SelectedCustomSchedule(id: e.id, name: e.name, description: e.description, schedule: e.lessons),
      ),
    ];

    return SizedBox(
      height: min(420, MediaQuery.of(context).size.height * 0.3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Выберите расписания для сравнения (до 3)',
              style: AppTextStyle.titleS,
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: savedSchedules.length,
              itemBuilder: (context, index) {
                final schedule = savedSchedules[index];
                final isInComparison = comparisonSchedules.contains(schedule);
                final isDisabled = !isInComparison && comparisonSchedules.length >= 3;

                return ComparisonScheduleListTile(
                  schedule: schedule,
                  isInComparison: isInComparison,
                  isDisabled: isDisabled,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrimaryButton(
              text: 'Применить',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Extracted into a separate stateful widget for better performance
class ComparisonScheduleListTile extends StatefulWidget {
  const ComparisonScheduleListTile({
    super.key,
    required this.schedule,
    required this.isInComparison,
    required this.isDisabled,
  });

  final SelectedSchedule schedule;
  final bool isInComparison;
  final bool isDisabled;

  @override
  State<ComparisonScheduleListTile> createState() => _ComparisonScheduleListTileState();
}

class _ComparisonScheduleListTileState extends State<ComparisonScheduleListTile> {
  bool _isProcessing = false;

  String _getScheduleTitle(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return schedule.group.name;
    } else if (schedule is SelectedTeacherSchedule) {
      return schedule.teacher.name;
    } else if (schedule is SelectedClassroomSchedule) {
      return schedule.classroom.name;
    } else if (schedule is SelectedCustomSchedule) {
      return schedule.name;
    }
    return 'Неизвестно';
  }

  String _getScheduleType(SelectedSchedule schedule) {
    if (schedule is SelectedGroupSchedule) {
      return 'Группа';
    } else if (schedule is SelectedTeacherSchedule) {
      return 'Преподаватель';
    } else if (schedule is SelectedClassroomSchedule) {
      return 'Аудитория';
    } else if (schedule is SelectedCustomSchedule) {
      return 'Мое расписание';
    }
    return '';
  }

  void _toggleComparison() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (widget.isInComparison) {
        context.read<ScheduleBloc>().add(RemoveScheduleFromComparison(widget.schedule));
      } else {
        if (!widget.isDisabled) {
          context.read<ScheduleBloc>().add(AddScheduleToComparison(widget.schedule));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Максимум 3 расписания для сравнения'), duration: Duration(seconds: 1)),
          );
        }
      }
    } finally {
      // Add a small delay to prevent rapid consecutive taps
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(
        _getScheduleTitle(widget.schedule),
        style: AppTextStyle.bodyBold.copyWith(color: widget.isDisabled ? Colors.grey : AppColors.dark.active),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _getScheduleType(widget.schedule),
        style: AppTextStyle.captionL.copyWith(color: widget.isDisabled ? Colors.grey : null),
      ),
      trailing:
          _isProcessing
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: widget.isInComparison,
                  onChanged: widget.isDisabled && !widget.isInComparison ? null : (_) => _toggleComparison(),
                ),
              ),
      onTap: _toggleComparison,
    );
  }
}
