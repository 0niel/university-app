import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

@immutable
class ScheduleDisplayState {
  const ScheduleDisplayState({
    this.showPast = true,
    this.showCancelled = true,
  });

  factory ScheduleDisplayState.fromJson(Map<String, dynamic> json) {
    return ScheduleDisplayState(
      showPast: json['showPast'] as bool? ?? true,
      showCancelled: json['showCancelled'] as bool? ?? true,
    );
  }

  final bool showPast;
  final bool showCancelled;

  ScheduleDisplayState copyWith({bool? showPast, bool? showCancelled}) {
    return ScheduleDisplayState(
      showPast: showPast ?? this.showPast,
      showCancelled: showCancelled ?? this.showCancelled,
    );
  }

  Map<String, dynamic> toJson() => {
    'showPast': showPast,
    'showCancelled': showCancelled,
  };

  @override
  bool operator ==(Object other) =>
      other is ScheduleDisplayState &&
      other.showPast == showPast &&
      other.showCancelled == showCancelled;

  @override
  int get hashCode => Object.hash(showPast, showCancelled);
}

class ScheduleDisplayCubit extends HydratedCubit<ScheduleDisplayState> {
  ScheduleDisplayCubit() : super(const ScheduleDisplayState());

  void setShowPast({required bool value}) =>
      emit(state.copyWith(showPast: value));

  void setShowCancelled({required bool value}) =>
      emit(state.copyWith(showCancelled: value));

  @override
  ScheduleDisplayState? fromJson(Map<String, dynamic> json) =>
      ScheduleDisplayState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleDisplayState state) => state.toJson();
}
