import 'dart:async';
import 'dart:convert';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/schedule/bloc/calculate_schedule_diff.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_widget_updater.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:university_app_server_api/client.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';
part 'schedule_bloc.g.dart';
part 'schedule_bloc.freezed.dart';

typedef UID = String;

class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({required ScheduleRepository scheduleRepository})
    : _scheduleRepository = scheduleRepository,
      _widgetUpdater = ScheduleWidgetUpdater(HomeScreenWidgetService()),
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

    // Desktop mode events
    on<ToggleSplitView>(_onToggleSplitView);
    on<SetAnalyticsVisibility>(_onSetAnalyticsVisibility);

    // Custom schedule events
    on<CreateCustomSchedule>(_onCreateCustomSchedule, transformer: sequential());
    on<DeleteCustomSchedule>(_onDeleteCustomSchedule, transformer: sequential());
    on<UpdateCustomSchedule>(_onUpdateCustomSchedule, transformer: sequential());
    on<AddLessonToCustomSchedule>(_onAddLessonToCustomSchedule, transformer: sequential());
    on<RemoveLessonFromCustomSchedule>(_onRemoveLessonFromCustomSchedule, transformer: sequential());
    on<SelectCustomSchedule>(_onSelectCustomSchedule, transformer: sequential());
    on<ToggleCustomScheduleMode>(_onToggleCustomScheduleMode, transformer: sequential());
  }

  @override
  bool shouldPersistOnEvent(ScheduleEvent? event) {
    return event is! AddScheduleToComparison &&
        event is! RemoveScheduleFromComparison &&
        event is! ToggleComparisonMode &&
        event is! ToggleSplitView &&
        event is! SetAnalyticsVisibility &&
        event is! HideScheduleDiffDialog;
  }

  final ScheduleRepository _scheduleRepository;
  final ScheduleWidgetUpdater _widgetUpdater;
  static const _maxComparisonSchedules = 3;

  // Handle desktop-specific events
  Future<void> _onToggleSplitView(ToggleSplitView event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isSplitViewEnabled: !state.isSplitViewEnabled));
  }

  Future<void> _onSetAnalyticsVisibility(SetAnalyticsVisibility event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(showAnalytics: event.showAnalytics));
  }

  Future<void> _onImportScheduleFromJson(ImportScheduleFromJson event, Emitter<ScheduleState> emit) async {
    try {
      final Map<String, dynamic> jsonData = jsonDecode(event.jsonString);
      final importedSchedule = SelectedSchedule.fromJson(jsonData);

      emit(state.copyWith(selectedSchedule: importedSchedule, status: ScheduleStatus.loaded));

      // Update widgets if the imported schedule is for a group
      if (importedSchedule is SelectedGroupSchedule) {
        await _updateWidgets(importedSchedule.schedule, importedSchedule.group.name);
      }
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onSetScheduleComment(SetScheduleComment event, Emitter<ScheduleState> emit) async {
    final updatedComments =
        List<ScheduleComment>.from(state.scheduleComments)
          ..removeWhere((comment) => comment.scheduleName == event.comment.scheduleName)
          ..add(event.comment);

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onRemoveScheduleComment(RemoveScheduleComment event, Emitter<ScheduleState> emit) async {
    final updatedComments = List<ScheduleComment>.from(state.scheduleComments)
      ..removeWhere((comment) => comment.scheduleName == event.scheduleName);

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onDeleteScheduleComment(DeleteScheduleComment event, Emitter<ScheduleState> emit) async {
    final updatedComments =
        state.scheduleComments.where((comment) => comment.scheduleName != event.scheduleName).toList();

    emit(state.copyWith(scheduleComments: updatedComments));
  }

  Future<void> _onSetShowCommentsIndicator(SetShowCommentsIndicator event, Emitter<ScheduleState> emit) async {
    if (state.showCommentsIndicators != event.showCommentsIndicators) {
      emit(state.copyWith(showCommentsIndicators: event.showCommentsIndicators));
    }
  }

  Future<void> _onSetLessonComment(SetLessonComment event, Emitter<ScheduleState> emit) async {
    final comment = state.comments.firstWhereOrNull(
      (comment) => event.comment.lessonDate == comment.lessonDate && event.comment.lessonBells == comment.lessonBells,
    );

    if (event.comment.text.isEmpty && comment == null) {
      return;
    }

    List<LessonComment> updatedComments =
        state.comments
            .where(
              (element) =>
                  element.lessonDate != event.comment.lessonDate || element.lessonBells != event.comment.lessonBells,
            )
            .toList();

    if (event.comment.text.isNotEmpty) {
      updatedComments.add(event.comment);
    }

    emit(state.copyWith(comments: updatedComments));
  }

  Future<void> _onSetEmptyLessonsDisplaying(
    ScheduleSetEmptyLessonsDisplaying event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.showEmptyLessons != event.showEmptyLessons) {
      emit(state.copyWith(showEmptyLessons: event.showEmptyLessons));
    }
  }

  Future<void> _onRemoveSavedSchedule(DeleteSchedule event, Emitter<ScheduleState> emit) async {
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

  Future<void> _onSetSelectedSchedule(SetSelectedSchedule event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(selectedSchedule: event.selectedSchedule));
    add(const RefreshSelectedScheduleData());
  }

  FutureOr<void> _onScheduleSetDisplayMode(ScheduleSetDisplayMode event, Emitter<ScheduleState> emit) {
    if (state.isMiniature != event.isMiniature) {
      emit(state.copyWith(isMiniature: event.isMiniature));
    }
  }

  FutureOr<void> _onScheduleResumed(RefreshSelectedScheduleData event, Emitter<ScheduleState> emit) async {
    if (state.selectedSchedule != null) {
      try {
        final oldScheduleParts = state.selectedSchedule?.schedule ?? [];

        ScheduleDiff? diff;

        if (state.selectedSchedule is SelectedGroupSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedGroupSchedule;
          final response = await _scheduleRepository.getSchedule(
            group: selectedSchedule.group.uid ?? selectedSchedule.group.name,
          );

          final newScheduleParts = response.data;

          // Update home screen widgets
          final updatedSchedule = SelectedGroupSchedule(group: selectedSchedule.group, schedule: newScheduleParts);
          await _widgetUpdater.updateWidgetsFromSelectedSchedule(updatedSchedule);

          // diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: updatedSchedule,
              // latestDiff: diff,
              // showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        } else if (state.selectedSchedule is SelectedTeacherSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedTeacherSchedule;
          final response = await _scheduleRepository.getTeacherSchedule(
            teacher: selectedSchedule.teacher.uid ?? selectedSchedule.teacher.name,
          );

          final newScheduleParts = response.data;
          // diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          // Update home screen widgets for teacher schedule
          final updatedSchedule = SelectedTeacherSchedule(
            teacher: selectedSchedule.teacher,
            schedule: newScheduleParts,
          );
          await _widgetUpdater.updateWidgetsFromSelectedSchedule(updatedSchedule);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: updatedSchedule,
              // latestDiff: diff,
              // showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        } else if (state.selectedSchedule is SelectedClassroomSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedClassroomSchedule;
          final response = await _scheduleRepository.getClassroomSchedule(
            classroom: selectedSchedule.classroom.uid ?? selectedSchedule.classroom.name,
          );

          final newScheduleParts = response.data;
          // diff = _calculateScheduleDiff(oldScheduleParts, newScheduleParts);

          // Update home screen widgets for classroom schedule
          final updatedSchedule = SelectedClassroomSchedule(
            classroom: selectedSchedule.classroom,
            schedule: newScheduleParts,
          );
          await _widgetUpdater.updateWidgetsFromSelectedSchedule(updatedSchedule);

          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: updatedSchedule,
              // latestDiff: diff,
              // showScheduleDiffDialog: diff != null && diff.changes.isNotEmpty,
            ),
          );
        } else if (state.selectedSchedule is SelectedCustomSchedule) {
          // Custom schedules can just be reused as is
          await _widgetUpdater.updateWidgetsFromSelectedSchedule(state.selectedSchedule!);
        }
      } catch (error, stackTrace) {
        emit(state.copyWith(status: ScheduleStatus.failure));
        addError(error, stackTrace);
      }
    }
  }

  Future<void> _updateWidgets(List<SchedulePart> scheduleParts, String scheduleName) async {
    // Skip widget update on web platform
    if (kIsWeb) return;

    // Try to create a SelectedSchedule if possible from the current state
    if (state.selectedSchedule != null) {
      await _widgetUpdater.updateWidgetsFromSelectedSchedule(state.selectedSchedule!);
    } else {
      // Fallback to the legacy method if no selected schedule is available
      await _widgetUpdater.updateWidgets(scheduleParts, scheduleName);
    }
  }

  ScheduleDiff? _calculateScheduleDiff(List<SchedulePart> oldParts, List<SchedulePart> newParts) {
    return calculateScheduleDiff(oldParts, newParts);
  }

  FutureOr<void> _onHideScheduleDiffDialog(HideScheduleDiffDialog event, Emitter<ScheduleState> emit) {
    emit(state.copyWith(showScheduleDiffDialog: false));
  }

  Future<void> _onScheduleRequested(ScheduleRequested event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(status: ScheduleStatus.loading));

    try {
      final response = await _scheduleRepository.getSchedule(group: event.group.uid ?? event.group.name);

      final updatedGroupsSchedule =
          state.groupsSchedule.where((element) => element.$1 != (event.group.uid ?? event.group.name)).toList();

      final selectedSchedule = SelectedGroupSchedule(group: event.group, schedule: response.data);

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: selectedSchedule,
          groupsSchedule: [...updatedGroupsSchedule, (event.group.uid ?? event.group.name, event.group, response.data)],
        ),
      );

      // Update home screen widgets
      await _widgetUpdater.updateWidgetsFromSelectedSchedule(selectedSchedule);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onTeacherScheduleRequested(TeacherScheduleRequested event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final response = await _scheduleRepository.getTeacherSchedule(teacher: event.teacher.uid ?? event.teacher.name);

      final updatedTeachersSchedule =
          state.teachersSchedule.where((element) => element.$1 != (event.teacher.uid ?? event.teacher.name)).toList();

      final selectedSchedule = SelectedTeacherSchedule(teacher: event.teacher, schedule: response.data);

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: selectedSchedule,
          teachersSchedule: [
            ...updatedTeachersSchedule,
            (event.teacher.uid ?? event.teacher.name, event.teacher, response.data),
          ],
        ),
      );

      // Update home screen widgets for teacher schedule
      await _widgetUpdater.updateWidgetsFromSelectedSchedule(selectedSchedule);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onClassroomScheduleRequested(ClassroomScheduleRequested event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final response = await _scheduleRepository.getClassroomSchedule(
        classroom: event.classroom.uid ?? event.classroom.name,
      );

      final updatedClassroomsSchedule =
          state.classroomsSchedule
              .where((element) => element.$1 != (event.classroom.uid ?? event.classroom.name))
              .toList();

      final selectedSchedule = SelectedClassroomSchedule(classroom: event.classroom, schedule: response.data);

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: selectedSchedule,
          classroomsSchedule: [
            ...updatedClassroomsSchedule,
            (event.classroom.uid ?? event.classroom.name, event.classroom, response.data),
          ],
        ),
      );

      // Update home screen widgets for classroom schedule
      await _widgetUpdater.updateWidgetsFromSelectedSchedule(selectedSchedule);
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onScheduleToggleListMode(ToggleListMode event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isListModeEnabled: !state.isListModeEnabled));
  }

  Future<void> _onAddScheduleToComparison(AddScheduleToComparison event, Emitter<ScheduleState> emit) async {
    if (state.comparisonSchedules.length >= _maxComparisonSchedules) return;

    // Check if the schedule is already in comparison to avoid unnecessary state updates
    if (state.comparisonSchedules.contains(event.schedule)) return;

    // Using a new set to avoid mutating the original
    final updatedComparison = Set<SelectedSchedule>.from(state.comparisonSchedules)..add(event.schedule);

    // Only emit if there's an actual change
    if (updatedComparison.length > state.comparisonSchedules.length) {
      emit(state.copyWith(comparisonSchedules: updatedComparison));
    }
  }

  Future<void> _onRemoveScheduleFromComparison(RemoveScheduleFromComparison event, Emitter<ScheduleState> emit) async {
    // Check if the schedule is actually in the comparison set before proceeding
    if (!state.comparisonSchedules.contains(event.schedule)) return;

    // Using a new set to avoid mutating the original
    final updatedComparison = Set<SelectedSchedule>.from(state.comparisonSchedules)..remove(event.schedule);

    // Only emit if there's an actual change
    if (updatedComparison.length < state.comparisonSchedules.length) {
      emit(state.copyWith(comparisonSchedules: updatedComparison));
    }
  }

  FutureOr<void> _onToggleComparisonMode(ToggleComparisonMode event, Emitter<ScheduleState> emit) {
    // Only emit if we're actually changing state
    if (state.isComparisonModeEnabled != !state.isComparisonModeEnabled) {
      emit(state.copyWith(isComparisonModeEnabled: !state.isComparisonModeEnabled));
    }
  }

  // Custom schedule handlers
  Future<void> _onCreateCustomSchedule(CreateCustomSchedule event, Emitter<ScheduleState> emit) async {
    final customSchedule = CustomSchedule.create(event.name, description: event.description);
    final updatedSchedules = [...state.customSchedules, customSchedule];

    emit(state.copyWith(customSchedules: updatedSchedules));
  }

  Future<void> _onDeleteCustomSchedule(DeleteCustomSchedule event, Emitter<ScheduleState> emit) async {
    final updatedSchedules = state.customSchedules.where((schedule) => schedule.id != event.scheduleId).toList();

    emit(state.copyWith(customSchedules: updatedSchedules));
  }

  Future<void> _onUpdateCustomSchedule(UpdateCustomSchedule event, Emitter<ScheduleState> emit) async {
    final updatedSchedules =
        state.customSchedules.map((schedule) {
          return schedule.id == event.schedule.id ? event.schedule : schedule;
        }).toList();

    emit(state.copyWith(customSchedules: updatedSchedules));
  }

  Future<void> _onAddLessonToCustomSchedule(AddLessonToCustomSchedule event, Emitter<ScheduleState> emit) async {
    final customScheduleIndex = state.customSchedules.indexWhere((schedule) => schedule.id == event.scheduleId);

    if (customScheduleIndex == -1) return;

    final customSchedule = state.customSchedules[customScheduleIndex];

    // Check if the lesson is already in the custom schedule
    final lessonExists = customSchedule.lessons.any(
      (lesson) =>
          lesson.subject == event.lesson.subject &&
          lesson.lessonBells.number == event.lesson.lessonBells.number &&
          const DeepCollectionEquality().equals(
            lesson.dates.map((e) => e.toIso8601String()).toList(),
            event.lesson.dates.map((e) => e.toIso8601String()).toList(),
          ),
    );

    if (lessonExists) return;

    final updatedLessons = [...customSchedule.lessons, event.lesson];
    final updatedSchedule = customSchedule.copyWith(lessons: updatedLessons, updatedAt: DateTime.now());

    final updatedSchedules = [...state.customSchedules];
    updatedSchedules[customScheduleIndex] = updatedSchedule;

    emit(state.copyWith(customSchedules: updatedSchedules));
  }

  Future<void> _onRemoveLessonFromCustomSchedule(
    RemoveLessonFromCustomSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    final customScheduleIndex = state.customSchedules.indexWhere((schedule) => schedule.id == event.scheduleId);

    if (customScheduleIndex == -1) return;

    final customSchedule = state.customSchedules[customScheduleIndex];

    // Find the lesson to remove
    final lessonIndex = customSchedule.lessons.indexWhere(
      (lesson) =>
          lesson.subject == event.lesson.subject &&
          lesson.lessonBells.number == event.lesson.lessonBells.number &&
          const DeepCollectionEquality().equals(
            lesson.dates.map((e) => e.toIso8601String()).toList(),
            event.lesson.dates.map((e) => e.toIso8601String()).toList(),
          ),
    );

    if (lessonIndex == -1) return;

    final updatedLessons = [...customSchedule.lessons];
    updatedLessons.removeAt(lessonIndex);

    final updatedSchedule = customSchedule.copyWith(lessons: updatedLessons, updatedAt: DateTime.now());

    final updatedSchedules = [...state.customSchedules];
    updatedSchedules[customScheduleIndex] = updatedSchedule;

    emit(state.copyWith(customSchedules: updatedSchedules));
  }

  Future<void> _onSelectCustomSchedule(SelectCustomSchedule event, Emitter<ScheduleState> emit) async {
    final customSchedule = state.customSchedules.firstWhereOrNull((schedule) => schedule.id == event.scheduleId);

    if (customSchedule == null) return;

    // Convert CustomSchedule lessons to SchedulePart list
    final scheduleParts = customSchedule.lessons.map<SchedulePart>((e) => e).toList();

    // Create a special Selected Schedule for custom schedules
    final selectedSchedule = SelectedCustomSchedule(
      id: customSchedule.id,
      name: customSchedule.name,
      description: customSchedule.description,
      schedule: scheduleParts,
    );

    emit(state.copyWith(selectedSchedule: selectedSchedule, status: ScheduleStatus.loaded));

    // Update widgets for custom schedule
    await _widgetUpdater.updateWidgetsFromSelectedSchedule(selectedSchedule);
  }

  Future<void> _onToggleCustomScheduleMode(ToggleCustomScheduleMode event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isCustomScheduleModeEnabled: !state.isCustomScheduleModeEnabled));
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) => ScheduleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleState state) => state.toJson();
}
