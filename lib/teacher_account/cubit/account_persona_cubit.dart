import 'dart:async';

import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPersonaState {
  const AccountPersonaState({
    this.persona = AccountPersona.empty,
    this.loaded = false,
    this.loading = false,
    this.saving = false,
    this.syncError = false,
    this.pendingSync = false,
    this.teacherSelectionPending = false,
    this.entryRequested = false,
  });

  final AccountPersona persona;
  final bool loaded;
  final bool loading;
  final bool saving;
  final bool syncError;
  final bool pendingSync;
  final bool teacherSelectionPending;
  final bool entryRequested;

  bool get isTeacher => persona.role == AccountRole.teacher;

  Teacher? get teacher {
    final id = persona.teacherId;
    final name = persona.teacherName;
    if (id == null || id.isEmpty || name == null || name.isEmpty) return null;
    return Teacher(uid: id, name: name);
  }

  AccountPersonaState copyWith({
    AccountPersona? persona,
    bool? loaded,
    bool? loading,
    bool? saving,
    bool? syncError,
    bool? pendingSync,
    bool? teacherSelectionPending,
    bool? entryRequested,
  }) => AccountPersonaState(
    persona: persona ?? this.persona,
    loaded: loaded ?? this.loaded,
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    syncError: syncError ?? this.syncError,
    pendingSync: pendingSync ?? this.pendingSync,
    teacherSelectionPending:
        teacherSelectionPending ?? this.teacherSelectionPending,
    entryRequested: entryRequested ?? this.entryRequested,
  );
}

class AccountPersonaCubit extends HydratedCubit<AccountPersonaState> {
  AccountPersonaCubit({
    required this.userId,
    required this.organizationId,
    required this._repository,
    required this._currentUserId,
    AccountRole? entryRole,
  }) : super(const AccountPersonaState()) {
    if (entryRole != null) {
      _editRevision++;
      emit(
        state.copyWith(
          persona: state.persona.copyWith(role: entryRole),
          pendingSync: true,
          entryRequested: entryRole == AccountRole.teacher,
        ),
      );
    }
  }

  final String userId;
  final String organizationId;
  final GamificationRepository _repository;
  final String? Function() _currentUserId;
  Future<void>? _restore;
  Future<bool>? _save;
  int _editRevision = 0;
  int _serverRevision = 0;
  AccountPersona _confirmed = AccountPersona.empty;

  @override
  String get id => '$organizationId:$userId';

  @override
  String get storagePrefix => 'AccountPersonaCubit';

  bool get _ownsSession =>
      !isClosed && userId.isNotEmpty && _currentUserId() == userId;

  Future<void> restore() => _restore ??= _restorePersona();

  Future<void> _restorePersona() async {
    if (!_ownsSession) return;
    final edit = _editRevision;
    emit(state.copyWith(loading: true, syncError: false));
    try {
      await _repository.ensureAcademicProfile(organizationId);
      if (!_ownsSession) return;
      final remote = await _repository.getAccountPersona(
        organizationId: organizationId,
        expectedUserId: userId,
      );
      if (!_ownsSession) return;
      if (remote.revision < _serverRevision) {
        emit(state.copyWith(loaded: true, loading: false));
        return;
      }
      _serverRevision = remote.revision;
      _confirmed = remote;
      final useRemote = edit == _editRevision && !state.pendingSync;
      final persona = useRemote
          ? remote
          : state.teacherSelectionPending
          ? state.persona.copyWith(revision: remote.revision)
          : remote.copyWith(role: state.persona.role);
      emit(
        state.copyWith(
          persona: persona,
          pendingSync: !useRemote && persona != remote,
          teacherSelectionPending:
              !useRemote && persona != remote && state.teacherSelectionPending,
          loaded: true,
          loading: false,
          syncError: false,
        ),
      );
    } on Exception {
      if (!_ownsSession) return;
      _serverRevision = state.persona.revision;
      emit(state.copyWith(loaded: true, loading: false, syncError: true));
    }
    if (_ownsSession && state.pendingSync) unawaited(_persist());
  }

  Future<bool> selectRole(AccountRole role) =>
      _select(state.persona.copyWith(role: role));

  Future<bool> selectTeacher(Teacher teacher) {
    final teacherId = teacher.uid?.trim();
    final name = teacher.name.trim();
    if (teacherId == null || teacherId.isEmpty || name.isEmpty) {
      return Future.value(false);
    }
    return _select(
      state.persona.copyWith(
        role: AccountRole.teacher,
        teacherId: teacherId,
        teacherName: name,
        teacherAvailable: true,
      ),
      teacherEdited: true,
    );
  }

  Future<bool> clearTeacher() => _select(
    state.persona.copyWith(
      teacherId: null,
      teacherName: null,
      teacherAvailable: false,
    ),
    teacherEdited: true,
  );

  Future<bool> configure({
    required AccountRole role,
    Teacher? teacher,
    bool clearTeacher = false,
  }) {
    var persona = state.persona.copyWith(role: role);
    if (clearTeacher) {
      persona = persona.copyWith(
        teacherId: null,
        teacherName: null,
        teacherAvailable: false,
      );
    } else if (teacher != null) {
      final id = teacher.uid?.trim();
      final name = teacher.name.trim();
      if (id == null || id.isEmpty || name.isEmpty) return Future.value(false);
      persona = persona.copyWith(
        teacherId: id,
        teacherName: name,
        teacherAvailable: true,
      );
    }
    return _select(persona, teacherEdited: clearTeacher || teacher != null);
  }

  Future<bool> _select(
    AccountPersona persona, {
    bool teacherEdited = false,
  }) async {
    if (!_ownsSession) return false;
    _editRevision++;
    emit(
      state.copyWith(
        persona: persona,
        loaded: true,
        pendingSync: true,
        teacherSelectionPending: state.teacherSelectionPending || teacherEdited,
        syncError: false,
      ),
    );
    await restore();
    if (!_ownsSession) return false;
    final saved = await _persist();
    return _ownsSession && (saved || state.pendingSync);
  }

  Future<void> retry() async {
    if (!_ownsSession) return;
    await _save;
    if (!_ownsSession) return;
    if (!state.loading) _restore = null;
    await restore();
    if (_ownsSession && state.pendingSync) await _persist();
  }

  Future<bool> _persist() {
    if (_save case final saving?) return saving;
    final saving = _drain();
    _save = saving;
    unawaited(
      saving.whenComplete(() {
        if (identical(_save, saving)) _save = null;
      }),
    );
    return saving;
  }

  Future<bool> _drain() async {
    if (!_ownsSession) return false;
    emit(state.copyWith(saving: true));
    var conflictRetried = false;
    while (_ownsSession && state.pendingSync) {
      final edit = _editRevision;
      final desired = state.persona;
      try {
        final saved = await _repository.setAccountPersona(
          organizationId: organizationId,
          expectedUserId: userId,
          role: desired.role,
          teacherId: desired.teacherId,
          expectedRevision: _serverRevision,
        );
        if (!_ownsSession) return false;
        _serverRevision = saved.revision;
        _confirmed = saved;
        final unchanged = edit == _editRevision;
        emit(
          state.copyWith(
            persona: unchanged
                ? saved
                : state.persona.copyWith(revision: saved.revision),
            pendingSync: !unchanged,
            teacherSelectionPending:
                !unchanged && state.teacherSelectionPending,
            syncError: false,
          ),
        );
        conflictRetried = false;
      } on AccountPersonaConflictException {
        if (!_ownsSession) return false;
        if (conflictRetried) {
          emit(state.copyWith(saving: false, syncError: true));
          return false;
        }
        conflictRetried = true;
        try {
          final remote = await _repository.getAccountPersona(
            organizationId: organizationId,
            expectedUserId: userId,
          );
          if (!_ownsSession) return false;
          _serverRevision = remote.revision;
          _confirmed = remote;
          if (!state.teacherSelectionPending) {
            emit(
              state.copyWith(
                persona: remote.copyWith(role: state.persona.role),
              ),
            );
          }
        } on Exception {
          if (_ownsSession) {
            emit(state.copyWith(saving: false, syncError: true));
          }
          return false;
        }
      } on Exception catch (error) {
        if (error is PostgrestException &&
            (error.code == '22023' || error.code == '42501')) {
          if (!_ownsSession) return false;
          if (edit != _editRevision) continue;
          emit(
            state.copyWith(
              persona: _confirmed,
              pendingSync: false,
              teacherSelectionPending: false,
              saving: false,
              syncError: true,
            ),
          );
          return false;
        }
        if (_ownsSession) {
          emit(state.copyWith(saving: false, syncError: true));
        }
        return false;
      }
    }
    if (!_ownsSession) return false;
    emit(state.copyWith(saving: false));
    return true;
  }

  @override
  AccountPersonaState? fromJson(Map<String, dynamic> json) {
    try {
      final value = json['persona'];
      if (value is! Map<String, dynamic>) return null;
      if (value['role'] != null && value['role'] is! String ||
          value['teacherId'] != null && value['teacherId'] is! String ||
          value['teacherName'] != null && value['teacherName'] is! String ||
          value['teacherAvailable'] != null &&
              value['teacherAvailable'] is! bool ||
          value['revision'] != null && value['revision'] is! num) {
        return null;
      }
      return AccountPersonaState(
        persona: AccountPersona.fromJson(value),
        pendingSync: json['pendingSync'] == true,
        teacherSelectionPending: json['teacherSelectionPending'] == true,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(AccountPersonaState state) => {
    'persona': state.persona.toJson(),
    'pendingSync': state.pendingSync,
    'teacherSelectionPending': state.teacherSelectionPending,
  };
}
