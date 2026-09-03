import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'study_group_state.dart';
part 'study_group_cubit.freezed.dart';
part 'study_group_status.dart';

class StudyGroupCubit extends Cubit<StudyGroupState> {
  StudyGroupCubit({required this._repository}) : super(const StudyGroupState());

  final StudyGroupsRepository _repository;
  int _loadRevision = 0;

  Future<void> load() async {
    await _load();
  }

  Future<bool> _load() async {
    if (isClosed) return false;
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final data = await _repository.getMyGroup();
      if (isClosed || revision != _loadRevision) return false;
      emit(state.copyWith(status: .populated, data: data));
      return true;
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return false;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> respondJoinRequest({
    required String inviteId,
    required bool accept,
  }) async {
    if (isClosed || state.pendingRequestIds.contains(inviteId)) return false;
    emit(
      state.copyWith(
        pendingRequestIds: {...state.pendingRequestIds, inviteId},
      ),
    );
    final ok = await _run(
      () => _repository.respondJoinRequest(inviteId: inviteId, accept: accept),
    );
    if (isClosed) return false;
    emit(
      state.copyWith(
        pendingRequestIds: {...state.pendingRequestIds}..remove(inviteId),
      ),
    );
    return ok;
  }

  Future<bool> leave() => _runVoid(_repository.leaveGroup);

  Future<bool> deleteGroup() => _runVoid(_repository.deleteGroup);

  Future<bool> removeMember(String userId) async {
    if (isClosed || state.pendingMemberIds.contains(userId)) return false;
    emit(
      state.copyWith(pendingMemberIds: {...state.pendingMemberIds, userId}),
    );
    final ok = await _runVoid(() => _repository.removeMember(userId));
    if (isClosed) return false;
    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds}..remove(userId),
      ),
    );
    return ok;
  }

  Future<bool> inviteByUserId(String userId) =>
      _runVoid(() => _repository.inviteByUserId(userId));

  Future<bool> transferOwnership(String userId) async {
    if (isClosed || state.pendingMemberIds.contains(userId)) return false;
    emit(
      state.copyWith(pendingMemberIds: {...state.pendingMemberIds, userId}),
    );
    final ok = await _run(() => _repository.transferOwnership(userId));
    if (isClosed) return false;
    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds}..remove(userId),
      ),
    );
    return ok;
  }

  Future<bool> _run(Future<MyStudyGroup> Function() action) async {
    if (isClosed) return false;
    _loadRevision++;
    try {
      final data = await action();
      if (isClosed) return false;
      emit(state.copyWith(status: .populated, data: data));
      return true;
    } on Object catch (error, stackTrace) {
      if (isClosed) return false;
      if (state.status == StudyGroupStatus.loading) {
        emit(state.copyWith(status: .failure));
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> _runVoid(Future<void> Function() action) async {
    if (isClosed) return false;
    _loadRevision++;
    try {
      await action();
      if (isClosed) return false;
      return await _load();
    } on Object catch (error, stackTrace) {
      if (isClosed) return false;
      if (state.status == StudyGroupStatus.loading) {
        emit(state.copyWith(status: .failure));
      }
      addError(error, stackTrace);
      return false;
    }
  }
}
