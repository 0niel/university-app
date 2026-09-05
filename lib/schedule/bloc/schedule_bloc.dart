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
    on<_ScheduleUserChanged>(_onScheduleUserChanged);
    on<_RemoteScheduleRestored>((event, emit) async {
      if (_preferencesRepository?.currentUserId != event.userId ||
          _activeUserId != event.userId ||
          state.selectedSchedule != event.previous) {
        return;
      }
      _selectionOwnerId = event.userId;
      _lastPushedDescriptor = jsonEncode(_descriptorOf(event.selected));
      emit(state.copyWith(selectedSchedule: event.selected));
      _persistSelectionOwner();
      await _onSelectedScheduleRefreshRequested(
        const SelectedScheduleRefreshRequested(manual: true),
        emit,
      );
    });

    final preferences = _preferencesRepository;
    if (preferences != null) {
      _authSubscription = preferences.userIdChanges.listen(
        (userId) {
          if (!isClosed) add(_ScheduleUserChanged(userId));
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!isClosed) addError(error, stackTrace);
        },
      );
      add(_ScheduleUserChanged(preferences.currentUserId));
    }
  }

  static const _selectedSchedulePreferenceKey = 'selected_schedule';

  final ScheduleRepository _scheduleRepository;
  final PreferencesRepository? _preferencesRepository;

  final ScheduleWidgetUpdater _widgetUpdater;
  final ConnectivityClient _connectivityClient;
  final SyncPolicy Function() _syncPolicyBuilder;

  @override
  String get storagePrefix => 'ScheduleBloc';

  StreamSubscription<String?>? _authSubscription;
  String? _selectionOwnerId;
  String? _activeUserId;
  String? _lastPushedDescriptor;
  int _userGeneration = 0;
  Future<void> _pendingPush = Future<void>.value();

  void _onScheduleUserChanged(
    _ScheduleUserChanged event,
    Emitter<ScheduleState> emit,
  ) {
    if (_activeUserId == event.userId) return;
    _activeUserId = event.userId;
    _userGeneration += 1;
    _lastPushedDescriptor = null;
    final userId = event.userId;
    if (userId == null) return;
    final previousOwner = _selectionOwnerId;
    if (previousOwner != null && previousOwner != userId) {
      _selectionOwnerId = userId;
      emit(const ScheduleState());
      _persistSelectionOwner();
    }
    unawaited(restoreSelectedScheduleFromRemote());
  }

  Future<void> restoreSelectedScheduleFromRemote() async {
    final preferences = _preferencesRepository;
    if (preferences == null) return;
    final userId = preferences.currentUserId;
    if (userId == null || isClosed) return;
    final previous = state.selectedSchedule;
    final generation = _userGeneration;
    if (previous != null && _selectionOwnerId == userId) {
      _pushSelectedSchedule(state.selectedSchedule);
      return;
    }

    try {
      final entry = await preferences.get(_selectedSchedulePreferenceKey);
      final value = entry?.value;
      if (isClosed ||
          preferences.currentUserId != userId ||
          _activeUserId != userId ||
          generation != _userGeneration) {
        return;
      }

      if (value == null || state.selectedSchedule != previous) {
        _selectionOwnerId = userId;
        _persistSelectionOwner();
        _pushSelectedSchedule(state.selectedSchedule);
        return;
      }

      final name = value['name'];
      final uid = value['uid'];
      if (name is! String ||
          name.trim().isEmpty ||
          (uid != null && uid is! String)) {
        return;
      }
      final selected = switch (value['type']) {
        'group' => SelectedGroupSchedule(
          group: Group(name: name, uid: uid as String?),
          schedule: const [],
        ),
        'teacher' => SelectedTeacherSchedule(
          teacher: Teacher(name: name, uid: uid as String?),
          schedule: const [],
        ),
        'classroom' => SelectedClassroomSchedule(
          classroom: Classroom(name: name, uid: uid as String?),
          schedule: const [],
        ),
        _ => null,
      };
      if (selected != null) {
        add(_RemoteScheduleRestored(userId, selected, previous));
      }
    } on PreferencesFailure catch (_) {}
  }

  void _persistSelectionOwner() {
    unawaited(
      HydratedBloc.storage.write(storageToken, toJson(state)).catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        if (!isClosed) addError(error, stackTrace);
      }),
    );
  }

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
    _pushSelectedSchedule(change.nextState.selectedSchedule);
  }

  void _pushSelectedSchedule(SelectedSchedule? selected) {
    final preferences = _preferencesRepository;
    final userId = preferences?.currentUserId;
    if (preferences == null ||
        userId == null ||
        userId != _selectionOwnerId ||
        userId != _activeUserId) {
      return;
    }

    final descriptor = _descriptorOf(selected);
    if (descriptor == null) return;
    final encoded = jsonEncode(descriptor);
    final generation = _userGeneration;
    _pendingPush = _pendingPush.then((_) async {
      if (isClosed ||
          generation != _userGeneration ||
          preferences.currentUserId != userId ||
          encoded == _lastPushedDescriptor) {
        return;
      }
      try {
        await preferences.set(_selectedSchedulePreferenceKey, descriptor);
        if (generation == _userGeneration &&
            preferences.currentUserId == userId) {
          _lastPushedDescriptor = encoded;
        }
      } on Object catch (error, stackTrace) {
        if (!isClosed) addError(error, stackTrace);
      }
    });
  }

  Future<void> _onScheduleRequested(
    ScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final group = event.group;
    final id = group.uid ?? group.name;
    final makeActive = _shouldActivate(event.makeActive);
    if (makeActive) {
      _selectRequestedSchedule(
        SelectedGroupSchedule(
          group: group,
          schedule:
              state.groupsSchedule
                  .where((entry) => entry.$1 == id)
                  .firstOrNull
                  ?.$3 ??
              const [],
        ),
        emit,
      );
    }
    await _runLoad(emit, () async {
      final parts = (await _scheduleRepository.getSchedule(group: id)).data;
      return state.copyWith(
        groupsSchedule: [
          for (final e in state.groupsSchedule)
            if (e.$1 != id) e,
          (id, group, parts),
        ],
        scheduleSyncedAt: _touchSync(id),
        selectedSchedule: makeActive
            ? SelectedGroupSchedule(group: group, schedule: parts)
            : state.selectedSchedule,
      );
    }, claimSelection: makeActive);
  }

  Future<void> _onTeacherScheduleRequested(
    TeacherScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final teacher = event.teacher;
    final id = teacher.uid ?? teacher.name;
    final makeActive = _shouldActivate(event.makeActive);
    if (makeActive) {
      _selectRequestedSchedule(
        SelectedTeacherSchedule(
          teacher: teacher,
          schedule:
              state.teachersSchedule
                  .where((entry) => entry.$1 == id)
                  .firstOrNull
                  ?.$3 ??
              const [],
        ),
        emit,
      );
    }
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
        selectedSchedule: makeActive
            ? SelectedTeacherSchedule(teacher: teacher, schedule: parts)
            : state.selectedSchedule,
      );
    }, claimSelection: makeActive);
  }

  Future<void> _onClassroomScheduleRequested(
    ClassroomScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    final classroom = event.classroom;
    final id = classroom.uid ?? classroom.name;
    final makeActive = _shouldActivate(event.makeActive);
    if (makeActive) {
      _selectRequestedSchedule(
        SelectedClassroomSchedule(
          classroom: classroom,
          schedule:
              state.classroomsSchedule
                  .where((entry) => entry.$1 == id)
                  .firstOrNull
                  ?.$3 ??
              const [],
        ),
        emit,
      );
    }
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
        selectedSchedule: makeActive
            ? SelectedClassroomSchedule(
                classroom: classroom,
                schedule: parts,
              )
            : state.selectedSchedule,
      );
    }, claimSelection: makeActive);
  }

  bool _shouldActivate(bool makeActive) =>
      makeActive || state.selectedSchedule == null;

  void _selectRequestedSchedule(
    SelectedSchedule selected,
    Emitter<ScheduleState> emit,
  ) {
    final ownerChanged = _claimSelectionForCurrentUser();
    emit(
      _cacheRefreshedSchedule(selected).copyWith(
        selectedSchedule: selected,
        status: .loading,
      ),
    );
    if (ownerChanged) _persistSelectionOwner();
  }

  Map<UID, DateTime> _touchSync(UID id) => {
    ...state.scheduleSyncedAt,
    id: DateTime.now(),
  };

  Future<void> _runLoad(
    Emitter<ScheduleState> emit,
    Future<ScheduleState> Function() load, {
    bool claimSelection = false,
  }) async {
    final generation = _userGeneration;
    final selected = state.selectedSchedule;
    emit(state.copyWith(status: .loading));
    try {
      final next = (await load()).copyWith(
        status: .loaded,
        lastSyncedAt: DateTime.now(),
        isOffline: false,
      );
      if (generation != _userGeneration ||
          emit.isDone ||
          (claimSelection && state.selectedSchedule != selected)) {
        return;
      }
      final ownerChanged =
          (claimSelection || next.selectedSchedule != state.selectedSchedule) &&
          _claimSelectionForCurrentUser();
      emit(next);
      if (ownerChanged) _persistSelectionOwner();
      if (next.selectedSchedule case final selected?) {
        await _widgetUpdater.updateWidgetsFromSelectedSchedule(selected);
      }
    } on Exception catch (error, stackTrace) {
      if (generation != _userGeneration ||
          emit.isDone ||
          (claimSelection && state.selectedSchedule != selected)) {
        return;
      }
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  bool _claimSelectionForCurrentUser() {
    final userId = _preferencesRepository?.currentUserId;
    if (userId == null ||
        userId != _activeUserId ||
        userId == _selectionOwnerId) {
      return false;
    }
    _selectionOwnerId = userId;
    return true;
  }

  void _onScheduleSelected(
    ScheduleSelected event,
    Emitter<ScheduleState> emit,
  ) {
    final ownerChanged = _claimSelectionForCurrentUser();
    emit(state.copyWith(selectedSchedule: event.selectedSchedule));
    if (ownerChanged) _persistSelectionOwner();
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
    final generation = _userGeneration;
    final selected = state.selectedSchedule;
    if (selected == null) {
      emit(state.copyWith(status: .loaded));
      return;
    }

    final refreshAllowed = event.manual || await _autoRefreshAllowed();
    if (generation != _userGeneration ||
        state.selectedSchedule != selected ||
        emit.isDone) {
      return;
    }
    if (!refreshAllowed) {
      emit(state.copyWith(status: .loaded));
      await _updateWidgets(selected);
      return;
    }

    try {
      final refreshed = await _refetchSelected(selected);
      if (generation != _userGeneration ||
          state.selectedSchedule != selected ||
          emit.isDone) {
        return;
      }
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
      if (generation != _userGeneration ||
          state.selectedSchedule != selected ||
          emit.isDone) {
        return;
      }
      emit(
        _cacheRefreshedSchedule(refreshed).copyWith(
          status: .loaded,
          selectedSchedule: refreshed,
          lastSyncedAt: DateTime.now(),
          scheduleSyncedAt: _touchSync(_idOf(refreshed)),
          isOffline: false,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (generation != _userGeneration ||
          state.selectedSchedule != selected ||
          emit.isDone) {
        return;
      }
      _emitRefreshFailure(emit);
      addError(error, stackTrace);
    }
  }

  ScheduleState _cacheRefreshedSchedule(SelectedSchedule selected) {
    final id = _idOf(selected);
    return switch (selected) {
      SelectedGroupSchedule(:final group, :final schedule) => state.copyWith(
        groupsSchedule: [
          for (final entry in state.groupsSchedule)
            if (entry.$1 == id) (id, group, schedule) else entry,
          if (!state.groupsSchedule.any((entry) => entry.$1 == id))
            (id, group, schedule),
        ],
      ),
      SelectedTeacherSchedule(:final teacher, :final schedule) =>
        state.copyWith(
          teachersSchedule: [
            for (final entry in state.teachersSchedule)
              if (entry.$1 == id) (id, teacher, schedule) else entry,
            if (!state.teachersSchedule.any((entry) => entry.$1 == id))
              (id, teacher, schedule),
          ],
        ),
      SelectedClassroomSchedule(:final classroom, :final schedule) =>
        state.copyWith(
          classroomsSchedule: [
            for (final entry in state.classroomsSchedule)
              if (entry.$1 == id) (id, classroom, schedule) else entry,
            if (!state.classroomsSchedule.any((entry) => entry.$1 == id))
              (id, classroom, schedule),
          ],
        ),
      SelectedCustomSchedule() => state,
    };
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
  ScheduleState fromJson(Map<String, dynamic> json) {
    _selectionOwnerId = json['selectionOwnerId'] as String?;
    return ScheduleState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ScheduleState state) => {
    ...state.toJson(),
    'selectionOwnerId': _selectionOwnerId,
  };

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}
