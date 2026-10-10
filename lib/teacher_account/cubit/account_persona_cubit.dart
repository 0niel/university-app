import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'account_persona_cubit.freezed.dart';
part 'account_persona_state.dart';

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
          pendingEdit: state.pendingEdit ?? AccountPersonaEdit.roleOnly,
          entryRequested: entryRole == AccountRole.teacher,
        ),
      );
    }
  }

  final String userId;
  final String organizationId;
  final GamificationRepository _repository;
  final String? Function() _currentUserId;
  Future<bool>? _restore;
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

  Future<void> restore() async {
    await (_restore ??= _restorePersona());
  }

  Future<bool> _restorePersona() async {
    if (!_ownsSession) return false;
    final edit = _editRevision;
    emit(state.copyWith(operation: AccountPersonaOperation.restoring));
    try {
      await _repository.ensureAcademicProfile(organizationId);
      if (!_ownsSession) return false;
      final remote = await _repository.getAccountPersona(
        organizationId: organizationId,
        expectedUserId: userId,
      );
      if (!_ownsSession) return false;
      if (remote.revision < _serverRevision) {
        emit(
          state.copyWith(loaded: true, operation: AccountPersonaOperation.idle),
        );
        return true;
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
          pendingEdit: !useRemote && persona != remote
              ? state.pendingEdit
              : null,
          loaded: true,
          operation: AccountPersonaOperation.idle,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (!_ownsSession) return false;
      addError(error, stackTrace);
      _serverRevision = state.persona.revision;
      emit(
        state.copyWith(loaded: true, operation: AccountPersonaOperation.failed),
      );
      return false;
    }
    if (_ownsSession && state.pendingSync) unawaited(_persist());
    return true;
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
        pendingEdit: teacherEdited
            ? AccountPersonaEdit.teacherSelection
            : state.pendingEdit ?? AccountPersonaEdit.roleOnly,
        operation: state.syncError
            ? AccountPersonaOperation.idle
            : state.operation,
      ),
    );
    await restore();
    if (!_ownsSession) return false;
    final saved = await _persist();
    return _ownsSession && (saved || state.pendingSync);
  }

  Future<void> retry() async {
    while (_ownsSession) {
      final saving = _save;
      await saving;
      if (!_ownsSession) return;
      if (!identical(_save, saving)) continue;
      if (!state.loading) _restore = null;
      await restore();
      if (_ownsSession && state.pendingSync) await _persist();
      return;
    }
  }

  Future<bool> _persist() async {
    while (_ownsSession) {
      final restoring = _restore;
      final restored = await restoring;
      if (!_ownsSession) return false;
      if (!identical(_restore, restoring)) continue;
      if (restored != true) {
        emit(state.copyWith(operation: AccountPersonaOperation.failed));
        return false;
      }
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
    return false;
  }

  Future<bool> _drain() async {
    if (!_ownsSession) return false;
    emit(state.copyWith(operation: AccountPersonaOperation.saving));
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
            pendingEdit: unchanged ? null : state.pendingEdit,
          ),
        );
        conflictRetried = false;
      } on AccountPersonaConflictException catch (error, stackTrace) {
        if (!_ownsSession) return false;
        if (conflictRetried) {
          addError(error, stackTrace);
          emit(state.copyWith(operation: AccountPersonaOperation.failed));
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
        } on Exception catch (error, stackTrace) {
          if (_ownsSession) {
            addError(error, stackTrace);
            emit(state.copyWith(operation: AccountPersonaOperation.failed));
          }
          return false;
        }
      } on Exception catch (error, stackTrace) {
        if (error is PostgrestException &&
            (error.code == '22023' || error.code == '42501')) {
          if (!_ownsSession) return false;
          if (edit != _editRevision) continue;
          addError(error, stackTrace);
          emit(
            state.copyWith(
              persona: _confirmed,
              pendingEdit: null,
              operation: AccountPersonaOperation.failed,
            ),
          );
          return false;
        }
        if (_ownsSession) {
          addError(error, stackTrace);
          emit(state.copyWith(operation: AccountPersonaOperation.failed));
        }
        return false;
      }
    }
    if (!_ownsSession) return false;
    emit(state.copyWith(operation: AccountPersonaOperation.idle));
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
      final AccountPersonaEdit? pendingEdit;
      if (json.containsKey('pendingEdit')) {
        final value = json['pendingEdit'];
        pendingEdit = AccountPersonaEdit.values
            .where((edit) => edit.name == value)
            .firstOrNull;
        if (value != null && pendingEdit == null) return null;
      } else {
        pendingEdit = json['pendingSync'] == true
            ? json['teacherSelectionPending'] == true
                  ? AccountPersonaEdit.teacherSelection
                  : AccountPersonaEdit.roleOnly
            : null;
      }
      return AccountPersonaState(
        persona: AccountPersona.fromJson(value),
        pendingEdit: pendingEdit,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(AccountPersonaState state) => {
    'persona': state.persona.toJson(),
    'pendingEdit': state.pendingEdit?.name,
  };
}
