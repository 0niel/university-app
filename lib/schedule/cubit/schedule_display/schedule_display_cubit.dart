import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_state.dart';

export 'schedule_display_state.dart';

class ScheduleDisplayCubit extends HydratedCubit<ScheduleDisplayState> {
  ScheduleDisplayCubit() : super(const ScheduleDisplayState());

  void setShowPast({required bool value}) =>
      emit(state.copyWith(showPast: value));

  void setShowCancelled({required bool value}) =>
      emit(state.copyWith(showCancelled: value));

  void markLessonActionsHintShown() {
    if (state.lessonActionsHintShown) return;
    emit(state.copyWith(lessonActionsHintShown: true));
  }

  @override
  ScheduleDisplayState fromJson(Map<String, dynamic> json) =>
      ScheduleDisplayState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ScheduleDisplayState state) => state.toJson();
}
