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

  Future<void> loadInitial() async {
    emit(state.copyWith(status: .loading));
    try {
      final roster = await _repository.getGroupMembers();
      final suggestions = await _repository.getPeopleYouMayKnow();
      emit(
        state.copyWith(
          status: .ready,
          roster: roster,
          suggestions: suggestions,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    emit(state.copyWith(query: query));
    if (trimmed.length < 2) {
      emit(state.copyWith(results: const [], searching: false));
      return;
    }
    emit(state.copyWith(searching: true));
    try {
      final results = await _repository.searchUsers(trimmed);
      if (isClosed || state.query != query) return;
      emit(state.copyWith(results: results, searching: false));
    } on Exception catch (error, stackTrace) {
      if (!isClosed && state.query == query) {
        emit(state.copyWith(results: const [], searching: false));
      }
      addError(error, stackTrace);
    }
  }

  Future<bool> sendRequest(String userId) async {
    emit(state.copyWith(sentTo: {...state.sentTo, userId}));
    try {
      await _repository.sendFriendRequest(userId);
      return true;
    } on Exception catch (error, stackTrace) {
      if (!isClosed) {
        emit(state.copyWith(sentTo: state.sentTo.difference({userId})));
      }
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> addWholeGroup() async {
    if (state.isAddingGroup) return false;
    emit(state.copyWith(isAddingGroup: true));
    var allSucceeded = true;
    for (final member in state.groupmates) {
      if (!state.isSent(member.userId, member.friendshipStatus)) {
        final sent = await sendRequest(member.userId);
        if (!sent) allSucceeded = false;
      }
    }
    if (!isClosed) emit(state.copyWith(isAddingGroup: false));
    return allSucceeded;
  }
}
