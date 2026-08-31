import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/people/cubit/people_state.dart';
import 'package:rtu_mirea_app/people/cubit/people_status.dart';
import 'package:study_groups_repository/study_groups_repository.dart';

export 'people_state.dart';
export 'people_status.dart';

class PeopleCubit extends Cubit<PeopleState> {
  factory PeopleCubit({
    required FriendsRepository friendsRepository,
    required StudyGroupsRepository studyGroupsRepository,
    required String currentUserId,
  }) => PeopleCubit._(
    friendsRepository,
    studyGroupsRepository,
    currentUserId,
  );

  PeopleCubit._(
    this._friendsRepository,
    this._studyGroupsRepository,
    this._currentUserId,
  ) : super(const PeopleState());

  final FriendsRepository _friendsRepository;
  final StudyGroupsRepository _studyGroupsRepository;
  final String _currentUserId;
  int _revision = 0;

  Future<bool> load() async {
    if (state.isMutating) return false;
    final revision = ++_revision;
    emit(state.copyWith(status: .loading, failedSources: const {}));
    final results = await (
      _capture(_friendsRepository.getFriends),
      _capture(_friendsRepository.getFriendRequests),
      _capture(_studyGroupsRepository.getMyGroup),
    ).wait;
    if (revision != _revision || isClosed) return false;
    final failures = <PeopleSource>{
      if (results.$1.error != null) .friends,
      if (results.$2.error != null) .requests,
      if (results.$3.error != null) .studyGroup,
    };
    emit(
      state.copyWith(
        status: failures.length == PeopleSource.values.length
            ? .failure
            : .ready,
        friends: results.$1.value ?? state.friends,
        requests: results.$2.value ?? state.requests,
        studyGroup: results.$3.value ?? state.studyGroup,
        failedSources: failures,
      ),
    );
    _report(results.$1);
    _report(results.$2);
    _report(results.$3);
    return failures.isEmpty;
  }

  void tabChanged(PeopleTab tab) => emit(state.copyWith(tab: tab));

  Future<bool> sendFriendRequest(String userId) async {
    if (userId == _currentUserId || state.pendingFriendIds.contains(userId)) {
      return false;
    }
    _revision++;
    emit(
      state.copyWith(
        status: _stableStatus,
        pendingFriendIds: {...state.pendingFriendIds, userId},
      ),
    );
    try {
      await _friendsRepository.sendFriendRequest(userId);
      if (isClosed) return false;
      emit(
        state.copyWith(
          studyGroup: state.studyGroup.copyWith(
            members: [
              for (final member in state.studyGroup.members)
                if (member.userId == userId)
                  member.copyWith(friendshipStatus: 'pending')
                else
                  member,
            ],
          ),
          pendingFriendIds: {...state.pendingFriendIds}..remove(userId),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            pendingFriendIds: {...state.pendingFriendIds}..remove(userId),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> respondFriendRequest({
    required String friendshipId,
    required bool accept,
  }) async {
    if (state.pendingResponseIds.contains(friendshipId)) return false;
    final index = state.requests.indexWhere(
      (request) => request.friendshipId == friendshipId,
    );
    final request = state.requests.elementAtOrNull(index);
    if (request == null) return false;
    _revision++;
    final accepted = Friend(
      friendshipId: request.friendshipId,
      userId: request.userId,
      fullName: request.fullName,
      handle: request.handle,
      group: request.group,
    );
    emit(
      state.copyWith(
        status: _stableStatus,
        friends: accept ? [accepted, ...state.friends] : state.friends,
        requests: [...state.requests]..removeAt(index),
        pendingResponseIds: {...state.pendingResponseIds, friendshipId},
      ),
    );
    try {
      await _friendsRepository.respondFriendRequest(
        friendshipId: friendshipId,
        accept: accept,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          pendingResponseIds: {...state.pendingResponseIds}
            ..remove(friendshipId),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        final requests = [...state.requests]
          ..insert(index.clamp(0, state.requests.length), request);
        emit(
          state.copyWith(
            friends: accept
                ? state.friends
                      .where((friend) => friend.friendshipId != friendshipId)
                      .toList()
                : state.friends,
            requests: requests,
            pendingResponseIds: {...state.pendingResponseIds}
              ..remove(friendshipId),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> respondGroupInvite({
    required String inviteId,
    required bool accept,
  }) async {
    if (state.pendingInviteIds.contains(inviteId)) return false;
    _revision++;
    emit(
      state.copyWith(
        status: _stableStatus,
        pendingInviteIds: {...state.pendingInviteIds, inviteId},
      ),
    );
    try {
      final studyGroup = await _studyGroupsRepository.respondInvite(
        inviteId: inviteId,
        accept: accept,
      );
      if (isClosed) return false;
      emit(
        state.copyWith(
          studyGroup: studyGroup,
          pendingInviteIds: {...state.pendingInviteIds}..remove(inviteId),
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) {
        emit(
          state.copyWith(
            pendingInviteIds: {...state.pendingInviteIds}..remove(inviteId),
          ),
        );
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> joinGroupByCode(String code) async {
    if (state.isJoiningGroup || code.trim().isEmpty) return false;
    _revision++;
    emit(state.copyWith(status: _stableStatus, isJoiningGroup: true));
    try {
      final studyGroup = await _studyGroupsRepository.joinByCode(code.trim());
      if (isClosed) return false;
      emit(state.copyWith(studyGroup: studyGroup, isJoiningGroup: false));
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) emit(state.copyWith(isJoiningGroup: false));
      addError(error, stackTrace);
      return false;
    }
  }

  PeopleStatus get _stableStatus =>
      state.status == .loading ? .ready : state.status;

  Future<_LoadResult<T>> _capture<T>(Future<T> Function() operation) async {
    try {
      return _LoadResult(value: await operation());
    } on Object catch (error, stackTrace) {
      return _LoadResult(error: error, stackTrace: stackTrace);
    }
  }

  void _report(_LoadResult<Object> result) {
    final error = result.error;
    final stackTrace = result.stackTrace;
    if (error != null && stackTrace != null) addError(error, stackTrace);
  }
}

class _LoadResult<T> {
  const _LoadResult({this.value, this.error, this.stackTrace});

  final T? value;
  final Object? error;
  final StackTrace? stackTrace;
}
