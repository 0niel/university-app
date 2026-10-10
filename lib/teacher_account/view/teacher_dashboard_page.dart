import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_dashboard_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/cubit/account_persona_cubit.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_dashboard_repository.dart';
import 'package:rtu_mirea_app/teacher_account/data/teacher_schedule_activator.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_lifecycle.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_dashboard_view.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({this.clock, super.key});

  final DateTime Function()? clock;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final account = context.read<AccountPersonaCubit>();
      final schedule = context.read<ScheduleBloc>();
      final now = clock ?? DateTime.now;
      return TeacherDashboardBloc(
        repository: TeacherDashboardRepository(
          schedules: context.read(),
          campus: context.read(),
          cache: () => schedule.state,
          clock: now,
        ),
        activator: TeacherScheduleActivator(schedule),
        account: account.state,
        accountChanges: account.stream,
        clock: now,
      );
    },
    child: const TeacherDashboardLifecycle(child: TeacherDashboardView()),
  );
}
