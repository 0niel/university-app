import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:friends_repository/friends_repository.dart';

part 'find_friends_state.dart';
part 'find_friends_status.dart';
part 'find_friends_cubit.freezed.dart';

class FindFriendsCubit extends Cubit<FindFriendsState> {
  FindFriendsCubit({required FriendsRepository friendsRepository})
    : _repository = friendsRepository,
      super(const FindFriendsState());

  final FriendsRepository _repository;
  var _searchRevision = 0;

  Future<void> loadInitial() async {
    if (isClosed || state.status == FindFriendsStatus.loading) return;
    emit(state.copyWith(status: .loading));
    try {
      final roster = await _repository.getGroupMembers();
      if (isClosed) return;
      final suggestions = await _repository.getPeopleYouMayKnow();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: .ready,
          roster: roster,
          suggestions: suggestions,
        ),
      );
    } on Exception catch (error, stackTrace) {
      if (isClosed) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> search(String query) async {
    if (isClosed) return;
    final revision = ++_searchRevision;
    final trimmed = query.trim();
    emit(state.copyWith(query: query, searchFailed: false));
    if (trimmed.length < 2) {
      emit(state.copyWith(results: const [], searching: false));
      return;
    }
    emit(state.copyWith(searching: true));
    try {
      final results = await _repository.searchUsers(trimmed);
      if (isClosed || revision != _searchRevision) return;
      emit(state.copyWith(results: results, searching: false));
    } on Exception catch (error, stackTrace) {
      if (!isClosed && revision == _searchRevision) {
        emit(
          state.copyWith(
            results: const [],
            searching: false,
            searchFailed: true,
          ),
        );
      }
      if (!isClosed) addError(error, stackTrace);
    }
  }

  Future<bool> sendRequest(String userId) async {
    if (isClosed || userId.isEmpty || state.sendingTo.contains(userId)) {
      return false;
    }
    if (state.sentTo.contains(userId)) return true;
    emit(state.copyWith(sendingTo: {...state.sendingTo, userId}));
    try {
      await _repository.sendFriendRequest(userId);
      if (isClosed) return false;
      emit(
        state.copyWith(
          sentTo: {...state.sentTo, userId},
          sendingTo: state.sendingTo.difference({userId}),
        ),
      );
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(sendingTo: state.sendingTo.difference({userId})));
        addError(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> addWholeGroup() async {
    if (isClosed || state.isAddingGroup) return false;
    emit(state.copyWith(isAddingGroup: true));
    var allSucceeded = true;
    for (final member in state.groupmates) {
      if (isClosed) return false;
      if (!state.isSent(member.userId, member.friendshipStatus)) {
        final sent = await sendRequest(member.userId);
        if (!sent) allSucceeded = false;
      }
    }
    if (!isClosed) emit(state.copyWith(isAddingGroup: false));
    return allSucceeded;
  }
}
