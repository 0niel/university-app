import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

@immutable
class ScheduleDisplayState {
  const ScheduleDisplayState({
    this.showPast = true,
    this.showCancelled = true,
    this.lessonActionsHintShown = false,
  });

  factory ScheduleDisplayState.fromJson(Map<String, dynamic> json) {
    return ScheduleDisplayState(
      showPast: json['showPast'] as bool? ?? true,
      showCancelled: json['showCancelled'] as bool? ?? true,
      lessonActionsHintShown: json['lessonActionsHintShown'] as bool? ?? false,
    );
  }

  final bool showPast;
  final bool showCancelled;
  final bool lessonActionsHintShown;

  ScheduleDisplayState copyWith({
    bool? showPast,
    bool? showCancelled,
    bool? lessonActionsHintShown,
  }) {
    return ScheduleDisplayState(
      showPast: showPast ?? this.showPast,
      showCancelled: showCancelled ?? this.showCancelled,
      lessonActionsHintShown:
          lessonActionsHintShown ?? this.lessonActionsHintShown,
    );
  }

  Map<String, dynamic> toJson() => {
    'showPast': showPast,
    'showCancelled': showCancelled,
    'lessonActionsHintShown': lessonActionsHintShown,
  };

  @override
  bool operator ==(Object other) =>
      other is ScheduleDisplayState &&
      other.showPast == showPast &&
      other.showCancelled == showCancelled &&
      other.lessonActionsHintShown == lessonActionsHintShown;

  @override
  int get hashCode =>
      Object.hash(showPast, showCancelled, lessonActionsHintShown);
}

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
  ScheduleDisplayState? fromJson(Map<String, dynamic> json) =>
      ScheduleDisplayState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleDisplayState state) => state.toJson();
}
