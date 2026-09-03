import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/team_finder/team_finder_status.dart';
import 'package:rtu_mirea_app/community/models/models.dart';

part 'team_finder_cubit.freezed.dart';
part 'team_finder_state.dart';

class TeamFinderCubit extends Cubit<TeamFinderState> {
  TeamFinderCubit(this._repository) : super(const TeamFinderState());

  final CampusRepository _repository;
  var _loadRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final teams = await _repository.getTeams();
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .ready, teams: teams));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  void filterChanged(String filterKey) {
    if (filterKey == state.filterKey) return;
    emit(state.copyWith(filterKey: filterKey));
  }

  Future<bool> create(TeamDraft draft) async {
    if (state.isCreating || draft.title.trim().isEmpty) return false;
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(state.copyWith(isCreating: true));
    try {
      await _repository.createTeam(
        title: draft.title.trim(),
        description: draft.description.trim(),
        neededRoles: _normalized(draft.neededRoles),
        capacity: draft.capacity.clamp(2, 20),
        kind: draft.kind.trim(),
        deadlineAt: draft.deadlineAt,
        boost: draft.boost,
      );
      if (isClosed) return false;
      emit(state.copyWith(isCreating: false));
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(status: fallbackStatus, isCreating: false));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> apply(TeamApplicationDraft draft) async {
    final teamId = draft.teamId;
    if (teamId.isEmpty || state.pendingApplyIds.contains(teamId)) return false;
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(
      state.copyWith(
        pendingApplyIds: _pending(state.pendingApplyIds, teamId, add: true),
      ),
    );
    try {
      await _repository.applyToTeam(
        teamId: teamId,
        role: draft.role.trim(),
        message: draft.message.trim(),
        attachProfile: draft.attachProfile,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingApplyIds: _pending(
            state.pendingApplyIds,
            teamId,
            add: false,
          ),
        ),
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingApplyIds: _pending(
              state.pendingApplyIds,
              teamId,
              add: false,
            ),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> withdraw(Team team) async {
    final applicationId = team.myApplicationId;
    if (applicationId == null || state.pendingApplyIds.contains(team.id)) {
      return false;
    }
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(
      state.copyWith(
        pendingApplyIds: _pending(state.pendingApplyIds, team.id, add: true),
      ),
    );
    try {
      await _repository.actOnTeamApplication(
        id: applicationId,
        action: .withdraw,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingApplyIds: _pending(
            state.pendingApplyIds,
            team.id,
            add: false,
          ),
        ),
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingApplyIds: _pending(
              state.pendingApplyIds,
              team.id,
              add: false,
            ),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> leave(String teamId) async {
    if (state.pendingLeaveIds.contains(teamId)) return false;
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(
      state.copyWith(
        pendingLeaveIds: _pending(state.pendingLeaveIds, teamId, add: true),
      ),
    );
    try {
      await _repository.leaveTeam(teamId);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingLeaveIds: _pending(
            state.pendingLeaveIds,
            teamId,
            add: false,
          ),
        ),
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingLeaveIds: _pending(
              state.pendingLeaveIds,
              teamId,
              add: false,
            ),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> update(Team team, TeamDraft draft) {
    if (draft.title.trim().isEmpty) return Future.value(false);
    return _updateTeam(
      team.id,
      () => _repository.updateTeam(
        id: team.id,
        title: draft.title.trim(),
        description: draft.description.trim(),
        neededRoles: _normalized(draft.neededRoles),
        capacity: draft.capacity.clamp(2, 20),
        kind: draft.kind.trim(),
        deadlineAt: draft.deadlineAt,
      ),
    );
  }

  Future<bool> closeTeam(Team team) => _setStatus(team, 'closed');

  Future<bool> reopenTeam(Team team) => _setStatus(team, 'open');

  Future<bool> _setStatus(Team team, String status) => _updateTeam(
    team.id,
    () => _repository.updateTeam(
      id: team.id,
      title: team.title,
      eventName: team.eventName,
      description: team.description,
      neededRoles: team.neededRoles,
      capacity: team.capacity,
      kind: team.kind,
      deadlineAt: team.deadlineAt,
      status: status,
    ),
  );

  Future<bool> _updateTeam(
    String teamId,
    Future<void> Function() action,
  ) async {
    if (state.pendingUpdateIds.contains(teamId)) return false;
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(
      state.copyWith(
        pendingUpdateIds: _pending(state.pendingUpdateIds, teamId, add: true),
      ),
    );
    try {
      await action();
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingUpdateIds: _pending(
            state.pendingUpdateIds,
            teamId,
            add: false,
          ),
        ),
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingUpdateIds: _pending(
              state.pendingUpdateIds,
              teamId,
              add: false,
            ),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> delete(String teamId) async {
    if (state.pendingDeleteIds.contains(teamId)) return false;
    final fallbackStatus = _stableStatus;
    _invalidateLoads();
    emit(
      state.copyWith(
        pendingDeleteIds: _pending(state.pendingDeleteIds, teamId, add: true),
      ),
    );
    try {
      await _repository.deleteTeam(teamId);
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingDeleteIds: _pending(
            state.pendingDeleteIds,
            teamId,
            add: false,
          ),
        ),
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingDeleteIds: _pending(
              state.pendingDeleteIds,
              teamId,
              add: false,
            ),
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;

  TeamFinderStatus get _stableStatus => state.status == .loading
      ? state.teams.isEmpty
            ? .initial
            : .ready
      : state.status;

  void _invalidateLoads() => _loadRevision++;

  List<String> _normalized(List<String> values) => {
    for (final value in values)
      if (value.trim().isNotEmpty) value.trim(),
  }.toList(growable: false);

  Set<String> _pending(Set<String> values, String id, {required bool add}) {
    final result = {...values};
    if (add) {
      result.add(id);
    } else {
      result.remove(id);
    }
    return result;
  }
}
