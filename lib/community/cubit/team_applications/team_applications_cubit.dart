import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/cubit/team_applications/team_applications_status.dart';

part 'team_applications_cubit.freezed.dart';
part 'team_applications_state.dart';

class TeamApplicationsCubit extends Cubit<TeamApplicationsState> {
  TeamApplicationsCubit(this._repository, this._teamId)
    : super(const TeamApplicationsState());

  final CampusRepository _repository;
  final String _teamId;
  var _loadRevision = 0;

  Future<bool> load() async {
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final applications = await _repository.getTeamApplications(_teamId);
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .ready, applications: applications));
      return true;
    } on Exception catch (error, stackTrace) {
      if (!_isCurrent(revision)) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> act(String id, TeamApplicationAction action) async {
    if (state.pendingIds.contains(id)) return false;
    final application = state.applications.firstWhereOrNull(
      (candidate) => candidate.id == id,
    );
    if (application == null) return false;
    final fallbackStatus = _stableStatus;
    _loadRevision++;
    _setPending(id, pending: true, action: action);
    try {
      await _repository.actOnTeamApplication(id: id, action: action);
      if (isClosed) return false;
      emit(
        state.copyWith(
          status: .ready,
          applications: state.applications
              .where((candidate) => candidate.id != id)
              .toList(growable: false),
          pendingIds: {...state.pendingIds}..remove(id),
          pendingRejectIds: {...state.pendingRejectIds}..remove(id),
        ),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        final pendingIds = {...state.pendingIds}..remove(id);
        final pendingRejectIds = {...state.pendingRejectIds}..remove(id);
        emit(
          state.copyWith(
            status: fallbackStatus,
            pendingIds: pendingIds,
            pendingRejectIds: pendingRejectIds,
          ),
        );
        addError(error, stackTrace);
      }
      return false;
    }
  }

  bool _isCurrent(int revision) => !isClosed && revision == _loadRevision;

  TeamApplicationsStatus get _stableStatus => state.status == .loading
      ? state.applications.isEmpty
            ? .initial
            : .ready
      : state.status;

  void _setPending(
    String id, {
    required bool pending,
    required TeamApplicationAction action,
  }) {
    final ids = {...state.pendingIds};
    final rejectIds = {...state.pendingRejectIds};
    if (pending) {
      ids.add(id);
      if (action == .reject) rejectIds.add(id);
    } else {
      ids.remove(id);
      rejectIds.remove(id);
    }
    emit(state.copyWith(pendingIds: ids, pendingRejectIds: rejectIds));
  }
}
