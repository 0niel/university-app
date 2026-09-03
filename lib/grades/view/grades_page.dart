import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/grades/cubit/grades_cubit.dart';
import 'package:rtu_mirea_app/grades/data/grades_repository.dart';
import 'package:rtu_mirea_app/grades/models/models.dart';
import 'package:rtu_mirea_app/grades/utils/schedule_subjects.dart';
import 'package:rtu_mirea_app/grades/view/grades_view.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit =
            GradesCubit(
              repository: LocalGradesRepository(
                userId: context.read<AppBloc>().state.user.id,
              ),
            )..scheduleSubjectsChanged(
              _subjectsOf(context.read<ScheduleBloc>().state),
            );
        unawaited(cubit.load());
        return cubit;
      },
      child: BlocListener<ScheduleBloc, ScheduleState>(
        listenWhen: (previous, current) =>
            previous.selectedSchedule != current.selectedSchedule,
        listener: (context, state) =>
            context.read<GradesCubit>().scheduleSubjectsChanged(
              _subjectsOf(state),
            ),
        child: const GradesView(),
      ),
    );
  }

  static List<SubjectGrades> _subjectsOf(ScheduleState state) =>
      scheduleSubjectsFor(
        state.selectedSchedule?.schedule ?? const [],
        GradesTerm.of(DateTime.now()),
      );
}
