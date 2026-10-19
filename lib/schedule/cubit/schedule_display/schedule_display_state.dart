import 'package:flutter/foundation.dart';

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
