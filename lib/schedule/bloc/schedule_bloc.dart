import 'dart:async';
import 'dart:convert';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_client/connectivity_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:rtu_mirea_app/data/datasources/home_screen_widget_service.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_widget_updater.dart';
import 'package:schedule_repository/schedule_repository.dart';

part 'schedule_event.dart';
part 'schedule_status.dart';
part 'schedule_state.dart';
part 'schedule_bloc.g.dart';
part 'schedule_bloc.freezed.dart';

typedef UID = String;

class ScheduleBloc extends HydratedBloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc({
    required this._scheduleRepository,
    this._preferencesRepository,
    ScheduleWidgetUpdater? widgetUpdater,
    ConnectivityClient? connectivityClient,
    SyncPolicy Function()? syncPolicy,
    this._authRetryDelay = const Duration(milliseconds: 500),
  }) : _widgetUpdater =
           widgetUpdater ??
           const ScheduleWidgetUpdater(HomeScreenWidgetService()),
       _connectivityClient = connectivityClient ?? ConnectivityClient(),
       _syncPolicyBuilder = syncPolicy ?? (() => SyncPolicy.always),
       super(const ScheduleState()) {
    on<ScheduleRequested>(_onScheduleRequested, transformer: sequential());
    on<TeacherScheduleRequested>(
      _onTeacherScheduleRequested,
      transformer: sequential(),
    );
    on<ClassroomScheduleRequested>(
      _onClassroomScheduleRequested,
      transformer: sequential(),
    );
    on<SelectedScheduleRefreshRequested>(
      _onSelectedScheduleRefreshRequested,
      transformer: droppable(),
    );
    on<ScheduleSelected>(_onScheduleSelected);
    on<ScheduleDeleteRequested>(_onScheduleDeleteRequested);
    on<ScheduleReordered>(_onScheduleReordered);

    unawaited(restoreSelectedScheduleFromRemote());
  }

  static const _selectedSchedulePreferenceKey = 'selected_schedule';

  final ScheduleRepository _scheduleRepository;
  final PreferencesRepository? _preferencesRepository;

  final Duration _authRetryDelay;
  final ScheduleWidgetUpdater _widgetUpdater;
  final ConnectivityClient _connectivityClient;
  final SyncPolicy Function() _syncPolicyBuilder;

  Future<void> restoreSelectedScheduleFromRemote() async {
    final preferences = _preferencesRepository;
    if (preferences == null) return;
    var attempts = 0;
    while (!preferences.hasAuthenticatedUser) {
      attempts += 1;
      if (isClosed || attempts > 20) return;
      await Future<void>.delayed(_authRetryDelay);
    }
    if (state.selectedSchedule != null) return;

    try {
      final entry = await preferences.get(_selectedSchedulePreferenceKey);
      final value = entry?.value;
      if (value == null || isClosed || state.selectedSchedule != null) return;

      final name = value['name'] as String?;
      if (name == null || name.isEmpty) return;
      final uid = value['uid'] as String?;

      switch (value['type']) {
        case 'group':
          add(
            ScheduleRequested(
              group: Group(name: name, uid: uid),
            ),
          );
        case 'teacher':
          add(
            TeacherScheduleRequested(
              teacher: Teacher(name: name, uid: uid),
            ),
          );
        case 'classroom':
          add(
            ClassroomScheduleRequested(
              classroom: Classroom(name: name, uid: uid),
            ),
          );
      }
    } on PreferencesFailure catch (_) {}
  }

  String? _lastPushedDescriptor;

  UID _idOf(SelectedSchedule selected) => switch (selected) {
    SelectedGroupSchedule(:final group) => group.uid ?? group.name,
    SelectedTeacherSchedule(:final teacher) => teacher.uid ?? teacher.name,
    SelectedClassroomSchedule(:final classroom) =>
      classroom.uid ?? classroom.name,
    SelectedCustomSchedule() => selected.name,
  };

  Map<String, dynamic>? _descriptorOf(SelectedSchedule? selected) {
    return switch (selected) {
      SelectedGroupSchedule(:final group) => {
        'type': 'group',
        'name': group.name,
        'uid': group.uid,
      },
      SelectedTeacherSchedule(:final teacher) => {
        'type': 'teacher',
        'name': teacher.name,
        'uid': teacher.uid,
      },
      SelectedClassroomSchedule(:final classroom) => {
        'type': 'classroom',
        'name': classroom.name,
        'uid': classroom.uid,
      },
      SelectedCustomSchedule() || null => null,
    };
  }

  @override
  void onChange(Change<ScheduleState> change) {
    super.onChange(change);

    final preferences = _preferencesRepository;
    if (preferences == null || !preferences.hasAuthenticatedUser) return;

    final descriptor = _descriptorOf(change.nextState.selectedSchedule);
    if (descriptor == null) return;
    final encoded = jsonEncode(descriptor);
    if (encoded == _lastPushedDescriptor) return;
    _lastPushedDescriptor = encoded;

    unawaited(
      preferences.set(_selectedSchedulePreferenceKey, descriptor).catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        addError(error, stackTrace);
      }),
    );
  }

  Future<void> _onScheduleRequested(
    ScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final group = event.group;
    final id = group.uid ?? group.name;
    await _runLoad(emit, () async {
      final parts = (await _scheduleRepository.getSchedule(group: id)).data;
      return state.copyWith(
        groupsSchedule: [
          for (final e in state.groupsSchedule)
            if (e.$1 != id) e,
          (id, group, parts),
        ],
        scheduleSyncedAt: _touchSync(id),
        selectedSchedule: _shouldActivate(event.makeActive)
            ? SelectedGroupSchedule(group: group, schedule: parts)
            : state.selectedSchedule,
      );
    });
  }

  Future<void> _onTeacherScheduleRequested(
    TeacherScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final teacher = event.teacher;
    final id = teacher.uid ?? teacher.name;
    await _runLoad(emit, () async {
      final parts = (await _scheduleRepository.getTeacherSchedule(
        teacher: id,
      )).data;
      return state.copyWith(
        teachersSchedule: [
          for (final e in state.teachersSchedule)
            if (e.$1 != id) e,
          (id, teacher, parts),
        ],
        scheduleSyncedAt: _touchSync(id),
        selectedSchedule: _shouldActivate(event.makeActive)
            ? SelectedTeacherSchedule(teacher: teacher, schedule: parts)
            : state.selectedSchedule,
      );
    });
  }

  Future<void> _onClassroomScheduleRequested(
    ClassroomScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final classroom = event.classroom;
    final id = classroom.uid ?? classroom.name;
    await _runLoad(emit, () async {
      final parts = (await _scheduleRepository.getClassroomSchedule(
        classroom: id,
      )).data;
      return state.copyWith(
        classroomsSchedule: [
          for (final e in state.classroomsSchedule)
            if (e.$1 != id) e,
          (id, classroom, parts),
        ],
        scheduleSyncedAt: _touchSync(id),
        selectedSchedule: _shouldActivate(event.makeActive)
            ? SelectedClassroomSchedule(
                classroom: classroom,
                schedule: parts,
              )
            : state.selectedSchedule,
      );
    });
  }

  bool _shouldActivate(bool makeActive) =>
      makeActive || state.selectedSchedule == null;

  Map<UID, DateTime> _touchSync(UID id) => {
    ...state.scheduleSyncedAt,
    id: DateTime.now(),
  };

  Future<void> _runLoad(
    Emitter<ScheduleState> emit,
    Future<ScheduleState> Function() load,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final next = (await load()).copyWith(
        status: .loaded,
        lastSyncedAt: DateTime.now(),
        isOffline: false,
      );
      emit(next);
      if (next.selectedSchedule case final selected?) {
        await _widgetUpdater.updateWidgetsFromSelectedSchedule(selected);
      }
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void _onScheduleSelected(
    ScheduleSelected event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(selectedSchedule: event.selectedSchedule));
    add(const SelectedScheduleRefreshRequested(manual: true));
  }

  void _onScheduleDeleteRequested(
    ScheduleDeleteRequested event,
    Emitter<ScheduleState> emit,
  ) {
    final syncedAt = {
      for (final entry in state.scheduleSyncedAt.entries)
        if (entry.key != event.identifier) entry.key: entry.value,
    };
    switch (event.target) {
      case .group:
        emit(
          state.copyWith(
            groupsSchedule: [
              for (final e in state.groupsSchedule)
                if (e.$1 != event.identifier) e,
            ],
            scheduleSyncedAt: syncedAt,
          ),
        );
      case .teacher:
        emit(
          state.copyWith(
            teachersSchedule: [
              for (final e in state.teachersSchedule)
                if (e.$1 != event.identifier) e,
            ],
            scheduleSyncedAt: syncedAt,
          ),
        );
      case .classroom:
        emit(
          state.copyWith(
            classroomsSchedule: [
              for (final e in state.classroomsSchedule)
                if (e.$1 != event.identifier) e,
            ],
            scheduleSyncedAt: syncedAt,
          ),
        );
    }
  }

  void _onScheduleReordered(
    ScheduleReordered event,
    Emitter<ScheduleState> emit,
  ) {
    int rank(UID id) {
      final index = event.orderedIds.indexOf(id);
      return index == -1 ? event.orderedIds.length : index;
    }

    switch (event.target) {
      case .group:
        final sorted = [...state.groupsSchedule]
          ..sort((a, b) => rank(a.$1).compareTo(rank(b.$1)));
        emit(state.copyWith(groupsSchedule: sorted));
      case .teacher:
        final sorted = [...state.teachersSchedule]
          ..sort((a, b) => rank(a.$1).compareTo(rank(b.$1)));
        emit(state.copyWith(teachersSchedule: sorted));
      case .classroom:
        final sorted = [...state.classroomsSchedule]
          ..sort((a, b) => rank(a.$1).compareTo(rank(b.$1)));
        emit(state.copyWith(classroomsSchedule: sorted));
    }
  }

  Future<void> _onSelectedScheduleRefreshRequested(
    SelectedScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final selected = state.selectedSchedule;
    if (selected == null) {
      emit(state.copyWith(status: .loaded));
      return;
    }

    if (!event.manual && !await _autoRefreshAllowed()) {
      emit(state.copyWith(status: .loaded));
      await _updateWidgets(selected);
      return;
    }

    try {
      final refreshed = await _refetchSelected(selected);
      if (refreshed == null) {
        await _updateWidgets(selected);
        return;
      }

      if (_shouldKeepCachedSchedule(refreshed.schedule, selected)) {
        emit(
          state.copyWith(
            status: .loaded,
            lastSyncedAt: DateTime.now(),
            scheduleSyncedAt: _touchSync(_idOf(selected)),
            isOffline: false,
          ),
        );
        return;
      }

      await _widgetUpdater.updateWidgetsFromSelectedSchedule(refreshed);
      emit(
        state.copyWith(
          status: .loaded,
          selectedSchedule: refreshed,
          lastSyncedAt: DateTime.now(),
          scheduleSyncedAt: _touchSync(_idOf(refreshed)),
          isOffline: false,
        ),
      );
    } on Exception catch (error, stackTrace) {
      _emitRefreshFailure(emit);
      addError(error, stackTrace);
    }
  }

  Future<bool> _autoRefreshAllowed() async {
    switch (_syncPolicyBuilder()) {
      case .always:
        return true;
      case .manualOnly:
        return false;
      case .wifiOnly:
        try {
          return await _connectivityClient.hasWifiOrEthernet();
        } on ConnectivityCheckFailure catch (error, stackTrace) {
          addError(error, stackTrace);
          return true;
        }
    }
  }

  Future<SelectedSchedule?> _refetchSelected(SelectedSchedule selected) async {
    switch (selected) {
      case SelectedGroupSchedule():
        final response = await _scheduleRepository.getSchedule(
          group: selected.group.uid ?? selected.group.name,
        );
        return SelectedGroupSchedule(
          group: selected.group,
          schedule: response.data,
        );
      case SelectedTeacherSchedule():
        final response = await _scheduleRepository.getTeacherSchedule(
          teacher: selected.teacher.uid ?? selected.teacher.name,
        );
        return SelectedTeacherSchedule(
          teacher: selected.teacher,
          schedule: response.data,
        );
      case SelectedClassroomSchedule():
        final response = await _scheduleRepository.getClassroomSchedule(
          classroom: selected.classroom.uid ?? selected.classroom.name,
        );
        return SelectedClassroomSchedule(
          classroom: selected.classroom,
          schedule: response.data,
        );
      case SelectedCustomSchedule():
        return null;
    }
  }

  bool _shouldKeepCachedSchedule(
    List<SchedulePart> newScheduleParts,
    SelectedSchedule selectedSchedule,
  ) {
    return newScheduleParts.isEmpty && selectedSchedule.schedule.isNotEmpty;
  }

  void _emitRefreshFailure(Emitter<ScheduleState> emit) {
    final hasCachedSchedule =
        state.selectedSchedule?.schedule.isNotEmpty ?? false;
    emit(
      state.copyWith(
        status: hasCachedSchedule ? .loaded : .failure,
        isOffline: hasCachedSchedule,
      ),
    );
  }

  Future<void> _updateWidgets(SelectedSchedule selectedSchedule) async {
    if (kIsWeb) return;
    await _widgetUpdater.updateWidgetsFromSelectedSchedule(selectedSchedule);
  }

  @override
  ScheduleState fromJson(Map<String, dynamic> json) => .fromJson(json);

  @override
  Map<String, dynamic> toJson(ScheduleState state) => state.toJson();
}
