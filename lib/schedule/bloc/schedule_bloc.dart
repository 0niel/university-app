import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:university_app_server_api/client.dart';

import '../models/models.dart';

part 'schedule_bloc.g.dart';
part 'schedule_event.dart';
part 'schedule_state.dart';

typedef UID = String;

class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required ScheduleRepository scheduleRepository,
  })  : _scheduleRepository = scheduleRepository,
        super(const ScheduleState.initial()) {
    on<ScheduleRequested>(_onScheduleRequested, transformer: sequential());
    on<TeacherScheduleRequested>(_onTeacherScheduleRequested,
        transformer: sequential());
    on<ClassroomScheduleRequested>(_onClassroomScheduleRequested,
        transformer: sequential());
    on<ScheduleResumed>(_onScheduleResumed, transformer: droppable());
    on<ScheduleRefreshRequested>(_onScheduleRefreshRequested,
        transformer: sequential());
  }

  final ScheduleRepository _scheduleRepository;

  Future<void> _onScheduleRefreshRequested(
    ScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final UID identifier = event.identifier;
    final ScheduleTarget target = event.target;

    emit(state.copyWith(status: ScheduleStatus.loading));

    try {
      final selected = state.selectedSchedule;

      if (selected == null) {
        emit(state.copyWith(status: ScheduleStatus.failure));
        return;
      }

      if (selected is SelectedGroupSchedule) {
        final response = await _scheduleRepository.getSchedule(
          group: selected.group.uid ?? selected.group.name,
        );

        emit(
          state.copyWith(
            status: ScheduleStatus.loaded,
            selectedSchedule: SelectedGroupSchedule(
              group: selected.group,
              schedule: response.data,
            ),
          ),
        );
      } else if (selected is SelectedTeacherSchedule) {
        final response = await _scheduleRepository.getTeacherSchedule(
          teacher: selected.teacher.uid ?? selected.teacher.name,
        );

        emit(
          state.copyWith(
            status: ScheduleStatus.loaded,
            selectedSchedule: SelectedTeacherSchedule(
              teacher: selected.teacher,
              schedule: response.data,
            ),
          ),
        );
      } else if (selected is SelectedClassroomSchedule) {
        final response = await _scheduleRepository.getClassroomSchedule(
          classroom: selected.classroom.uid ?? selected.classroom.name,
        );

        emit(
          state.copyWith(
            status: ScheduleStatus.loaded,
            selectedSchedule: SelectedClassroomSchedule(
              classroom: selected.classroom,
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

  FutureOr<void> _onScheduleResumed(
    ScheduleResumed event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state.selectedSchedule != null) {
      try {
        if (state.selectedSchedule is SelectedGroupSchedule) {
          final selectedSchedule =
              state.selectedSchedule as SelectedGroupSchedule;
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
          final selectedSchedule =
              state.selectedSchedule as SelectedTeacherSchedule;
          final response = await _scheduleRepository.getTeacherSchedule(
            teacher:
                selectedSchedule.teacher.uid ?? selectedSchedule.teacher.name,
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
          final selectedSchedule =
              state.selectedSchedule as SelectedClassroomSchedule;
          final response = await _scheduleRepository.getClassroomSchedule(
            classroom: selectedSchedule.classroom.uid ??
                selectedSchedule.classroom.name,
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

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedGroupSchedule(
            group: event.group,
            schedule: response.data,
          ),
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

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedTeacherSchedule(
            teacher: event.teacher,
            schedule: response.data,
          ),
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

      emit(
        state.copyWith(
          status: ScheduleStatus.loaded,
          selectedSchedule: SelectedClassroomSchedule(
            classroom: event.classroom,
            schedule: response.data,
          ),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ScheduleStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  ScheduleState? fromJson(Map<String, dynamic> json) =>
      ScheduleState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(ScheduleState state) => state.toJson();
}
