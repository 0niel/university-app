import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_exporter.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:university_app_server_api/client.dart';

import '../models/models.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';
part 'schedule_bloc.g.dart';

typedef UID = String;

class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required ScheduleRepository scheduleRepository,
  })  : _scheduleRepository = scheduleRepository,
        super(const ScheduleState.initial()) {
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
    on<AddScheduleComment>(_onAddScheduleComment);
    on<DeleteScheduleComment>(_onDeleteScheduleComment);
  }

  final ScheduleRepository _scheduleRepository;

  Future<void> _onAddScheduleComment(
    AddScheduleComment event,
    Emitter<ScheduleState> emit,
  ) async {
    final updatedComments = List<ScheduleComment>.from(state.scheduleComments)..add(event.comment);

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
    emit(state.copyWith(showCommentsIndicators: event.showCommentsIndicators));
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
    emit(state.copyWith(showEmptyLessons: event.showEmptyLessons));
  }

  Future<void> _onRemoveSavedSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    if (event.target == ScheduleTarget.group) {
      emit(
        state.copyWith(
          groupsSchedule: state.groupsSchedule
              .where(
                (element) => element.$1 != event.identifier,
              )
              .toList(),
        ),
      );
    } else if (event.target == ScheduleTarget.teacher) {
      emit(
        state.copyWith(
          teachersSchedule: state.teachersSchedule
              .where(
                (element) => element.$1 != event.identifier,
              )
              .toList(),
        ),
      );
    } else if (event.target == ScheduleTarget.classroom) {
      emit(
        state.copyWith(
          classroomsSchedule: state.classroomsSchedule
              .where(
                (element) => element.$1 != event.identifier,
              )
              .toList(),
        ),
      );
    }
  }

  Future<void> _onSetSelectedSchedule(
    SetSelectedSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(selectedSchedule: event.selectedSchedule));
    // Add on Resume event to refresh schedule data.
    add(const RefreshSelectedScheduleData());
  }

  FutureOr<void> _onScheduleSetDisplayMode(
    ScheduleSetDisplayMode event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(isMiniature: event.isMiniature));
  }

  FutureOr<void> _onScheduleResumed(
    RefreshSelectedScheduleData event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.selectedSchedule != null) {
      try {
        if (state.selectedSchedule is SelectedGroupSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedGroupSchedule;
          final response = await _scheduleRepository.getSchedule(
            group: selectedSchedule.group.uid ?? selectedSchedule.group.name,
          );
          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedGroupSchedule(
                group: selectedSchedule.group,
                schedule: response.data,
              ),
            ),
          );
        } else if (state.selectedSchedule is SelectedTeacherSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedTeacherSchedule;
          final response = await _scheduleRepository.getTeacherSchedule(
            teacher: selectedSchedule.teacher.uid ?? selectedSchedule.teacher.name,
          );
          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedTeacherSchedule(
                teacher: selectedSchedule.teacher,
                schedule: response.data,
              ),
            ),
          );
        } else if (state.selectedSchedule is SelectedClassroomSchedule) {
          final selectedSchedule = state.selectedSchedule as SelectedClassroomSchedule;
          final response = await _scheduleRepository.getClassroomSchedule(
            classroom: selectedSchedule.classroom.uid ?? selectedSchedule.classroom.name,
          );
          emit(
            state.copyWith(
              status: ScheduleStatus.loaded,
              selectedSchedule: SelectedClassroomSchedule(
                classroom: selectedSchedule.classroom,
                schedule: response.data,
              ),
            ),
          );
        }
      } catch (error, stackTrace) {
        emit(state.copyWith(status: ScheduleStatus.failure));
        addError(error, stackTrace);
      }
    }
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

  Future<void> exportScheduleToCalendar(SelectedSchedule selectedSchedule) async {
    await ScheduleExporter().exportScheduleToCalendar(selectedSchedule);
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) => ScheduleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleState state) => state.toJson();
}
