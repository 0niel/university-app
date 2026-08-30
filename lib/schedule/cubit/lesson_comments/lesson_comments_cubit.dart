import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/common/bloc/remote_preference_sync.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

part 'lesson_comments_cubit.freezed.dart';
part 'lesson_comments_cubit.g.dart';
part 'lesson_comments_state.dart';

class LessonCommentsCubit extends HydratedCubit<LessonCommentsState>
    with RemotePreferenceSync<LessonCommentsState> {
  LessonCommentsCubit({this.preferencesRepository})
    : super(const LessonCommentsState()) {
    unawaited(restoreFromRemote());
  }

  @override
  final PreferencesRepository? preferencesRepository;

  @override
  String get preferenceKey => 'lesson_comments';

  @override
  Map<String, dynamic> toPreferencePayload(LessonCommentsState state) =>
      state.toJson();

  @override
  LessonCommentsState? fromPreferencePayload(Map<String, dynamic> payload) {
    try {
      final restored = LessonCommentsState.fromJson(payload);
      if (restored.comments.isEmpty &&
          restored.scheduleComments.isEmpty &&
          (state.comments.isNotEmpty || state.scheduleComments.isNotEmpty)) {
        return null;
      }
      return restored;
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  void setLessonComment(LessonComment comment) {
    bool sameSlot(LessonComment other) =>
        other.subjectName == comment.subjectName &&
        other.lessonDate == comment.lessonDate &&
        other.lessonBells == comment.lessonBells;

    final existing = state.comments.firstWhereOrNull(sameSlot);
    if (comment.text.isEmpty && existing == null) return;

    final comments = [
      for (final c in state.comments)
        if (!sameSlot(c)) c,
      if (comment.text.isNotEmpty) comment,
    ];

    emit(state.copyWith(comments: comments));
  }

  void setScheduleComment(ScheduleComment comment) {
    final comments = [
      for (final c in state.scheduleComments)
        if (c.scheduleName != comment.scheduleName) c,
      comment,
    ];
    emit(state.copyWith(scheduleComments: comments));
  }

  void removeScheduleComment(String scheduleName) {
    final comments = [
      for (final c in state.scheduleComments)
        if (c.scheduleName != scheduleName) c,
    ];
    if (comments.length == state.scheduleComments.length) return;
    emit(state.copyWith(scheduleComments: comments));
  }

  @override
  LessonCommentsState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(LessonCommentsState state) => state.toJson();
}
