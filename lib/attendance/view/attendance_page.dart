import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/attendance/cubit/attendance_cubit.dart';
import 'package:rtu_mirea_app/attendance/data/absences_repository.dart';
import 'package:rtu_mirea_app/attendance/view/attendance_view.dart';
import 'package:rtu_mirea_app/grades/models/grades_term.dart';
import 'package:rtu_mirea_app/grades/utils/schedule_subjects.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AttendanceCubit(
          repository: LocalAbsencesRepository(
            userId: context.read<AppBloc>().state.user.id,
          ),
        )..lessonsChanged(_lessonsOf(context.read<ScheduleBloc>().state));
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocListener<ScheduleBloc, ScheduleState>(
        listenWhen: (previous, current) =>
            previous.selectedSchedule != current.selectedSchedule,
        listener: (context, state) =>
            context.read<AttendanceCubit>().lessonsChanged(_lessonsOf(state)),
        child: const AttendanceView(),
      ),
    );
  }

  static List<LessonSchedulePart> _lessonsOf(ScheduleState state) => lessonsFor(
    state.selectedSchedule?.schedule ?? const [],
    GradesTerm.of(DateTime.now()),
  );
}
