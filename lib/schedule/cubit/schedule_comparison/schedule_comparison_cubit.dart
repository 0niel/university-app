import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

part 'schedule_comparison_cubit.freezed.dart';
part 'schedule_comparison_state.dart';

class ScheduleComparisonCubit extends Cubit<ScheduleComparisonState> {
  ScheduleComparisonCubit() : super(const ScheduleComparisonState());

  static const maxSchedules = 3;

  String? _friendName;

  SelectedSchedule? get friend => state.schedules.firstOrNull;

  String get friendName => _friendName ?? friend?.name ?? '';

  void start(SelectedSchedule schedule, {String? friendName}) {
    _friendName = friendName;
    emit(state.copyWith(schedules: {schedule}, isEnabled: true));
  }

  void stop() {
    _friendName = null;
    emit(const ScheduleComparisonState());
  }
}
