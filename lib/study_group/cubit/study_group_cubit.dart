import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

part 'study_group_state.dart';
part 'study_group_cubit.freezed.dart';
part 'study_group_status.dart';

class StudyGroupCubit extends Cubit<StudyGroupState> {
  StudyGroupCubit({required this._repository}) : super(const StudyGroupState());

  final StudyGroupsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final data = await _repository.getMyGroup();
      emit(state.copyWith(status: .populated, data: data));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<bool> respondJoinRequest({
    required String inviteId,
    required bool accept,
  }) async {
    if (state.pendingRequestIds.contains(inviteId)) return false;
    emit(
      state.copyWith(
        pendingRequestIds: {...state.pendingRequestIds, inviteId},
      ),
    );
    final ok = await _run(
      () => _repository.respondJoinRequest(inviteId: inviteId, accept: accept),
    );
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
    if (state.pendingMemberIds.contains(userId)) return false;
    emit(
      state.copyWith(pendingMemberIds: {...state.pendingMemberIds, userId}),
    );
    final ok = await _runVoid(() => _repository.removeMember(userId));
    emit(
      state.copyWith(
        pendingMemberIds: {...state.pendingMemberIds}..remove(userId),
      ),
    );
    return ok;
  }

  Future<bool> inviteByUserId(String userId) =>
      _runVoid(() => _repository.inviteByUserId(userId));

  Future<bool> _run(Future<MyStudyGroup> Function() action) async {
    try {
      final data = await action();
      emit(state.copyWith(status: .populated, data: data));
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> _runVoid(Future<void> Function() action) async {
    try {
      await action();
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }
}
