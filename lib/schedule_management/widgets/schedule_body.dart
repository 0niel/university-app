import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/presentation/constants.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/models/selected_schedule.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:rtu_mirea_app/schedule_management/widgets/widgets.dart';
import 'package:university_app_server_api/client.dart';

class ScheduleBody extends StatefulWidget {
  final ScheduleState state;

  const ScheduleBody({super.key, required this.state});

  @override
  State<ScheduleBody> createState() => _ScheduleBodyState();
}

class _ScheduleBodyState extends State<ScheduleBody> {
  void _showSecretJsonDialog(BuildContext context) {
    BottomModalSheet.show(
      context,
      child: AddScheduleJsonBottomSheetContent(
        onConfirm: (jsonString) {
          context.read<ScheduleBloc>().add(ImportScheduleFromJson(jsonString));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Расписание добавлено'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      title: 'Импорт из JSON',
      description: 'Эта функция предназначена для отладки. Введите JSON строку для добавления расписания.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryButton(
            text: 'Добавить расписание',
            onClick: () => context.go('/schedule/search'),
            onLongPress: () => _showSecretJsonDialog(context),
          ),
          const SizedBox(height: 16),
          if (widget.state.groupsSchedule.isNotEmpty)
            ScheduleSection<Group>(
              title: "Группы",
              schedules: _getUniqueSchedules<Group>(widget.state.groupsSchedule),
              state: widget.state,
              scheduleType: 'group',
            ),
          if (widget.state.teachersSchedule.isNotEmpty)
            ScheduleSection<Teacher>(
              title: "Преподаватели",
              schedules: _getUniqueSchedules<Teacher>(widget.state.teachersSchedule),
              state: widget.state,
              scheduleType: 'teacher',
            ),
          if (widget.state.classroomsSchedule.isNotEmpty)
            ScheduleSection<Classroom>(
              title: "Аудитории",
              schedules: _getUniqueSchedules<Classroom>(widget.state.classroomsSchedule),
              state: widget.state,
              scheduleType: 'classroom',
            ),
          const SizedBox(height: bottomNavigationBarHeight),
        ],
      ),
    );
  }

  List<(UID, T, List<SchedulePart>)> _getUniqueSchedules<T>(List<(UID, T, List<SchedulePart>)> schedules) {
    final uniqueSchedules = <String, (UID, T, List<SchedulePart>)>{};

    for (var schedule in schedules) {
      final scheduleName = SelectedSchedule.getScheduleName<T>(schedule.$2);
      if (!uniqueSchedules.containsKey(scheduleName)) {
        uniqueSchedules[scheduleName] = schedule;
      }
    }

    return uniqueSchedules.values.toList();
  }
}
