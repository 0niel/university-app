import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync.dart';

part 'schedule_preferences_cubit.freezed.dart';
part 'schedule_preferences_cubit.g.dart';
part 'schedule_preferences_state.dart';

class SchedulePreferencesCubit extends HydratedCubit<SchedulePreferencesState>
    with RemotePreferenceSync<SchedulePreferencesState> {
  SchedulePreferencesCubit({this.preferencesRepository})
    : super(const SchedulePreferencesState()) {
    unawaited(restoreFromRemote());
  }

  @override
  final PreferencesRepository? preferencesRepository;

  @override
  String get preferenceKey => 'schedule_preferences';

  @override
  Map<String, dynamic> toPreferencePayload(SchedulePreferencesState state) =>
      state.toJson();

  @override
  SchedulePreferencesState? fromPreferencePayload(
    Map<String, dynamic> payload,
  ) {
    try {
      return SchedulePreferencesState.fromJson(payload);
    } on Object catch (_) {
      return null;
    }
  }

  void applyFilters({
    required bool showLectures,
    required bool showSeminars,
    required bool showLabs,
    required bool showExams,
    required bool showGaps,
    required bool collapsePast,
  }) {
    emit(
      state.copyWith(
        showLectures: showLectures,
        showSeminars: showSeminars,
        showLabs: showLabs,
        showExams: showExams,
        showGaps: showGaps,
        collapsePast: collapsePast,
      ),
    );
  }

  void resetFilters() {
    emit(
      state.copyWith(
        showLectures: true,
        showSeminars: true,
        showLabs: true,
        showExams: true,
        showGaps: true,
        collapsePast: true,
      ),
    );
  }

  void hideSubject(String subject) {
    if (state.hiddenSubjects.contains(subject)) return;
    emit(state.copyWith(hiddenSubjects: [...state.hiddenSubjects, subject]));
  }

  void unhideSubject(String subject) {
    emit(
      state.copyWith(
        hiddenSubjects: state.hiddenSubjects
            .where((name) => name != subject)
            .toList(),
      ),
    );
  }

  @override
  SchedulePreferencesState fromJson(Map<String, dynamic> json) =>
      .fromJson(json);

  @override
  Map<String, dynamic> toJson(SchedulePreferencesState state) => state.toJson();
}
