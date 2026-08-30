import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

part 'schedule_comparison_cubit.freezed.dart';
part 'schedule_comparison_state.dart';

class ScheduleComparisonCubit extends Cubit<ScheduleComparisonState> {
  ScheduleComparisonCubit() : super(const ScheduleComparisonState());

  static const maxSchedules = 3;
}
