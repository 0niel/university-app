import 'dart:async';

import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_navigation.dart';
import 'package:schedule_repository/schedule_repository.dart';

class TeacherScheduleActivator {
  const TeacherScheduleActivator(this._schedule);

  final ScheduleBloc _schedule;

  Stream<ScheduleState> activate(
    Teacher teacher,
    TeacherScheduleDestination destination,
  ) {
    final export = destination == TeacherScheduleDestination.calendar;
    bool matches(ScheduleState state) {
      final selected = state.selectedSchedule;
      return selected is SelectedTeacherSchedule &&
          selected.teacher.uid == teacher.uid;
    }

    if (matches(_schedule.state) &&
        (!export || _schedule.state.status == ScheduleStatus.loaded)) {
      return Stream.value(_schedule.state);
    }
    StreamSubscription<ScheduleState>? subscription;
    late final StreamController<ScheduleState> controller;
    controller = StreamController<ScheduleState>(
      onListen: () {
        subscription = _schedule.stream
            .where(
              (state) =>
                  matches(state) &&
                  (!export ||
                      state.status == ScheduleStatus.loaded ||
                      state.status == ScheduleStatus.failure),
            )
            .take(1)
            .timeout(
              Duration(seconds: export ? 30 : 5),
              onTimeout: (sink) {
                sink
                  ..addError(TimeoutException('Teacher schedule unavailable'))
                  ..close();
              },
            )
            .listen(
              controller.add,
              onError: controller.addError,
              onDone: controller.close,
            );
        _schedule.add(
          matches(_schedule.state)
              ? const SelectedScheduleRefreshRequested(manual: true)
              : TeacherScheduleRequested(teacher: teacher),
        );
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }
}
