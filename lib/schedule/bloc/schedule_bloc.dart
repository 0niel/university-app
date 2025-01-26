import 'dart:async';
import 'dart:convert';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:university_app_server_api/client.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';
part 'schedule_bloc.g.dart';
part 'schedule_bloc.freezed.dart';

typedef UID = String;

class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required ScheduleRepository scheduleRepository,
  })  : _scheduleRepository = scheduleRepository,
        super(const ScheduleState()) {
    on<ScheduleRequested>(_onScheduleRequested, transformer: sequential());
    on<TeacherScheduleRequested>(_onTeacherScheduleRequested, transformer: sequential());
    on<ClassroomScheduleRequested>(_onClassroomScheduleRequested, transformer: sequential());
    on<RefreshSelectedScheduleData>(_onScheduleResumed, transformer: droppable());
    on<ScheduleSetDisplayMode>(_onScheduleSetDisplayMode);
    on<SetSelectedSchedule>(_onSetSelectedSchedule);
    on<DeleteSchedule>(_onRemoveSavedSchedule);
    on<ScheduleSetEmptyLessonsDisplaying>(_onSetEmptyLessonsDisplaying);
    on<SetLessonComment>(_onSetLessonComment);
    on<SetShowCommentsIndicator>(_onSetShowCommentsIndicator);
    on<ToggleListMode>(_onScheduleToggleListMode);
    on<SetScheduleComment>(_onSetScheduleComment);
    on<RemoveScheduleComment>(_onRemoveScheduleComment);
    on<DeleteScheduleComment>(_onDeleteScheduleComment);
    on<ImportScheduleFromJson>(_onImportScheduleFromJson);

    // Comparison events
    on<AddScheduleToComparison>(_onAddScheduleToComparison, transformer: sequential());
    on<RemoveScheduleFromComparison>(_onRemoveScheduleFromComparison, transformer: sequential());
    on<ToggleComparisonMode>(_onToggleComparisonMode, transformer: sequential());

    on<HideScheduleDiffDialog>(_onHideScheduleDiffDialog);
  }

  @override
  bool shouldPersistOnEvent(ScheduleEvent? event) {
    return event is! AddScheduleToComparison &&
        event is! RemoveScheduleFromComparison &&
        event is! ToggleComparisonMode;
  }

  final ScheduleRepository _scheduleRepository;
  static const _maxComparisonSchedules = 3;

  Future<void> _onImportScheduleFromJson(
    ImportScheduleFromJson event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(event.jsonString);
      final importedSchedule = SelectedSchedule.fromJson(jsonData);

      emit(
        state.copyWith(
          selectedSchedule: importedSchedule,
          status: ScheduleStatus.loaded,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onSetScheduleComment(
    SetScheduleComment event,
    Emitter<ScheduleState> emit,
  ) async {
    final updatedComments = List<ScheduleComment>.from(state.scheduleComments)
      ..removeWhere((comment) => comment.scheduleName == event.comment.scheduleName)
      ..add(event.comment);

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onRemoveScheduleComment(
    RemoveScheduleComment event,
    Emitter<ScheduleState> emit,
  ) async {
    final updatedComments = List<ScheduleComment>.from(state.scheduleComments)
      ..removeWhere((comment) => comment.scheduleName == event.scheduleName);

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onDeleteScheduleComment(
    DeleteScheduleComment event,
    Emitter<ScheduleState> emit,
  ) async {
    final updatedComments =
        state.scheduleComments.where((comment) => comment.scheduleName != event.scheduleName).toList();

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onSetShowCommentsIndicator(
    SetShowCommentsIndicator event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.showCommentsIndicators != event.showCommentsIndicators) {
      emit(state.copyWith(showCommentsIndicators: event.showCommentsIndicators));
    }
  }

  Future<void> _onSetLessonComment(
    SetLessonComment event,
    Emitter<ScheduleState> emit,
  ) async {
    final comment = state.comments.firstWhereOrNull(
      (comment) => event.comment.lessonDate == comment.lessonDate && event.comment.lessonBells == comment.lessonBells,
    );

    if (event.comment.text.isEmpty && comment == null) {
      return;
    }

    List<LessonComment> updatedComments = state.comments
        .where(
          (element) =>
              element.lessonDate != event.comment.lessonDate || element.lessonBells != event.comment.lessonBells,
        )
        .toList();

    if (event.comment.text.isNotEmpty) {
      updatedComments.add(event.comment);
    }

    emit(
      state.copyWith(
        comments: updatedComments,
      ),
    );
  }

  Future<void> _onSetEmptyLessonsDisplaying(
    ScheduleSetEmptyLessonsDisplaying event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.showEmptyLessons != event.showEmptyLessons) {
      emit(state.copyWith(showEmptyLessons: event.showEmptyLessons));
    }
  }

  Future<void> _onRemoveSavedSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    if (event.target == ScheduleTarget.group) {
      final updatedGroups = state.groupsSchedule.where((element) => element.$1 != event.identifier).toList();
      emit(state.copyWith(groupsSchedule: updatedGroups));
    } else if (event.target == ScheduleTarget.teacher) {
      final updatedTeachers = state.teachersSchedule.where((element) => element.$1 != event.identifier).toList();
      emit(state.copyWith(teachersSchedule: updatedTeachers));
    } else if (event.target == ScheduleTarget.classroom) {
      final updatedClassrooms = state.classroomsSchedule.where((element) => element.$1 != event.identifier).toList();
      emit(state.copyWith(classroomsSchedule: updatedClassrooms));
    }
  }

  Future<void> _onSetSelectedSchedule(
    SetSelectedSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(selectedSchedule: event.selectedSchedule));
    // Trigger data refresh
    add(const RefreshSelectedScheduleData());
  }

  FutureOr<void> _onScheduleSetDisplayMode(
    ScheduleSetDisplayMode event,
    Emitter<ScheduleState> emit,
  ) {
    if (state.isMiniature != event.isMiniature) {
      emit(state.copyWith(isMiniature: event.isMiniature));
    }
  }

  FutureOr<void> _onScheduleResumed(
    RefreshSelectedScheduleData event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.selectedSchedule != null) {
      try {
        // Сохраняем предыдущее расписание для сравнения
        final oldScheduleParts = state.selectedSchedule?.schedule ?? [];

        ScheduleDiff? diff;

        if (state.selectedSchedule is SelectedGroupSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedGroupSchedule;
          final response = await _scheduleRepository.getSchedule(
            group: selectedSchedule.group.uid ?? selectedSchedule.group.name,
          );

          final newScheduleParts = response.data;

          // Сравниваем старое и новое
          diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedGroupSchedule(
                group: selectedSchedule.group,
                schedule: newScheduleParts,
              ),
              latestDiff: diff,
              showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        } else if (state.selectedSchedule is SelectedTeacherSchedule) {
          // Аналогично для преподавателя
          final selectedSchedule = state.selectedSchedule as SelectedTeacherSchedule;
          final response = await _scheduleRepository.getTeacherSchedule(
            teacher: selectedSchedule.teacher.uid ?? selectedSchedule.teacher.name,
          );

          final newScheduleParts = response.data;
          diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedTeacherSchedule(
                teacher: selectedSchedule.teacher,
                schedule: newScheduleParts,
              ),
              latestDiff: diff,
              showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        } else if (state.selectedSchedule is SelectedClassroomSchedule) {
          // Аналогично для аудитории
          final selectedSchedule = state.selectedSchedule as SelectedClassroomSchedule;
          final response = await _scheduleRepository.getClassroomSchedule(
            classroom: selectedSchedule.classroom.uid ?? selectedSchedule.classroom.name,
          );

          final newScheduleParts = response.data;
          diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedClassroomSchedule(
                classroom: selectedSchedule.classroom,
                schedule: newScheduleParts,
              ),
              latestDiff: diff,
              showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        }
      } catch (error, stackTrace) {
        emit(state.copyWith(status: ScheduleStatus.failure));
        addError(error, stackTrace);
      }
    }
  }

  ScheduleDiff? _calculateScheduleDiff(
    List<SchedulePart> oldParts,
    List<SchedulePart> newParts,
  ) {
    final changes = <ScheduleChange>[];
    final oldLessons = oldParts.whereType<LessonSchedulePart>().toList();
    final newLessons = newParts.whereType<LessonSchedulePart>().toList();

    // Helper to compare classroom sets
    bool sameClassrooms(LessonSchedulePart a, LessonSchedulePart b) {
      final setA = a.classrooms.map((c) => c.name).toSet();
      final setB = b.classrooms.map((c) => c.name).toSet();
      return setA.length == setB.length && setA.containsAll(setB);
    }

    // Quickly get a potential match if subject matches
    LessonSchedulePart? findSameSubject(LessonSchedulePart lesson, List<LessonSchedulePart> list) {
      return list.firstWhereOrNull((l) => l.subject == lesson.subject);
    }

    // Check old lessons for removal or modification
    for (final oldLesson in oldLessons) {
      final candidate = findSameSubject(oldLesson, newLessons);
      if (candidate == null) {
        // Entire old lesson removed
        changes.add(
          ScheduleChange(
            type: ChangeType.removed,
            title: 'Удалена пара',
            description: oldLesson.subject,
            dates: oldLesson.dates,
            lessonBells: oldLesson.lessonBells,
          ),
        );
        continue;
      }

      // Check if lesson bells or classrooms changed
      if (!sameClassrooms(oldLesson, candidate) || oldLesson.lessonBells != candidate.lessonBells) {
        // Mark overlapping days as modified
        final commonDays = oldLesson.dates.where(candidate.dates.contains).toList();
        if (commonDays.isNotEmpty) {
          changes.add(
            ScheduleChange(
              type: ChangeType.modified,
              title: 'Изменена пара',
              description: oldLesson.subject,
              dates: commonDays,
              lessonBells: candidate.lessonBells,
            ),
          );
        }
      }

      // Check removed days
      final removedDays = oldLesson.dates.where((d) => !candidate.dates.contains(d)).toList();
      if (removedDays.isNotEmpty) {
        changes.add(
          ScheduleChange(
            type: ChangeType.removed,
            title: 'Удалена пара',
            description: oldLesson.subject,
            dates: removedDays,
            lessonBells: oldLesson.lessonBells,
          ),
        );
      }
    }

    // Check new lessons for additions or modifications
    for (final newLesson in newLessons) {
      final candidate = findSameSubject(newLesson, oldLessons);
      if (candidate == null) {
        // Entire new lesson added
        changes.add(
          ScheduleChange(
            type: ChangeType.added,
            title: 'Добавлена пара',
            description: newLesson.subject,
            dates: newLesson.dates,
            lessonBells: newLesson.lessonBells,
          ),
        );
        continue;
      }

      // Check added days
      final addedDays = newLesson.dates.where((d) => !candidate.dates.contains(d)).toList();
      if (addedDays.isNotEmpty) {
        changes.add(
          ScheduleChange(
            type: ChangeType.added,
            title: 'Добавлена пара',
            description: newLesson.subject,
            dates: addedDays,
            lessonBells: newLesson.lessonBells,
          ),
        );
      }
    }

    if (changes.isEmpty) return null;

    return ScheduleDiff(changes: changes.toSet());
  }

  FutureOr<void> _onHideScheduleDiffDialog(
    HideScheduleDiffDialog event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(showScheduleDiffDialog: false));
  }

  Future<void> _onScheduleRequested(
    ScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));

    try {
      final response = await _scheduleRepository.getSchedule(
        group: event.group.uid ?? event.group.name,
      );

      final updatedGroupsSchedule =
          state.groupsSchedule.where((element) => element.$1 != (event.group.uid ?? event.group.name)).toList();

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedGroupSchedule(
            group: event.group,
            schedule: response.data,
          ),
          groupsSchedule: [
            ...updatedGroupsSchedule,
            (
              event.group.uid ?? event.group.name,
              event.group,
              response.data,
            ),
          ],
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onTeacherScheduleRequested(
    TeacherScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final response = await _scheduleRepository.getTeacherSchedule(
        teacher: event.teacher.uid ?? event.teacher.name,
      );

      final updatedTeachersSchedule =
          state.teachersSchedule.where((element) => element.$1 != (event.teacher.uid ?? event.teacher.name)).toList();

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedTeacherSchedule(
            teacher: event.teacher,
            schedule: response.data,
          ),
          teachersSchedule: [
            ...updatedTeachersSchedule,
            (
              event.teacher.uid ?? event.teacher.name,
              event.teacher,
              response.data,
            ),
          ],
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onClassroomScheduleRequested(
    ClassroomScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final response = await _scheduleRepository.getClassroomSchedule(
        classroom: event.classroom.uid ?? event.classroom.name,
      );

      final updatedClassroomsSchedule = state.classroomsSchedule
          .where((element) => element.$1 != (event.classroom.uid ?? event.classroom.name))
          .toList();

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedClassroomSchedule(
            classroom: event.classroom,
            schedule: response.data,
          ),
          classroomsSchedule: [
            ...updatedClassroomsSchedule,
            (
              event.classroom.uid ?? event.classroom.name,
              event.classroom,
              response.data,
            ),
          ],
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onScheduleToggleListMode(
    ToggleListMode event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(isListModeEnabled: !state.isListModeEnabled));
  }

  Future<void> _onAddScheduleToComparison(
    AddScheduleToComparison event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.comparisonSchedules.length >= _maxComparisonSchedules) return;

    final updatedComparison = Set<SelectedSchedule>.from(state.comparisonSchedules);
    final wasAdded = updatedComparison.add(event.schedule);

    if (wasAdded) {
      emit(state.copyWith(comparisonSchedules: updatedComparison));
    }
  }

  Future<void> _onRemoveScheduleFromComparison(
    RemoveScheduleFromComparison event,
    Emitter<ScheduleState> emit,
  ) async {
    final updatedComparison = Set<SelectedSchedule>.from(state.comparisonSchedules);
    final wasRemoved = updatedComparison.remove(event.schedule);

    if (wasRemoved) {
      emit(state.copyWith(comparisonSchedules: updatedComparison));
    }
  }

  FutureOr<void> _onToggleComparisonMode(
    ToggleComparisonMode event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(
      isComparisonModeEnabled: !state.isComparisonModeEnabled,
    ));
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) => ScheduleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleState state) => state.toJson();
}
