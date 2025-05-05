import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'syncfusion_calendar_view.dart';

class SyncfusionCalendarScreen extends StatelessWidget {
  const SyncfusionCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<ScheduleBloc>().state;
    final lessons = state.selectedSchedule?.schedule.toList() ?? [];

    return Scaffold(appBar: AppBar(title: const Text('Календарь')), body: SyncfusionCalendarView(lessons: lessons));
  }
}
