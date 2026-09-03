import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friends_repository/friends_repository.dart';

enum FriendsListStatus { initial, loading, loaded, failure }

enum FriendsFilter { all, onCampus }

enum FriendPresence { hidden, live, recent, off }

const kFriendLiveWindow = Duration(minutes: 5);
const kFriendCampusWindow = Duration(minutes: 30);

FriendPresence friendPresence(Friend friend, DateTime now) {
  if (friend.isGhost) return FriendPresence.hidden;
  final updatedAt = friend.locationUpdatedAt;
  if (!friend.hasLocation ||
      updatedAt == null ||
      friend.latitude!.abs() > 90 ||
      friend.longitude!.abs() > 180) {
    return FriendPresence.off;
  }
  final age = now.difference(updatedAt.toLocal());
  if (age.isNegative) return FriendPresence.off;
  if (age < kFriendLiveWindow) return FriendPresence.live;
  return FriendPresence.recent;
}

bool friendOnCampus(Friend friend, DateTime now) {
  final updatedAt = friend.locationUpdatedAt;
  return !friend.isGhost &&
      friend.hasLocation &&
      friend.latitude!.abs() <= 90 &&
      friend.longitude!.abs() <= 180 &&
      updatedAt != null &&
      !now.difference(updatedAt.toLocal()).isNegative &&
      now.difference(updatedAt.toLocal()) < kFriendCampusWindow;
}

class FriendsListState extends Equatable {
  const FriendsListState({
    this.status = FriendsListStatus.initial,
    this.friends = const [],
    this.filter = FriendsFilter.all,
  });

  final FriendsListStatus status;
  final List<Friend> friends;
  final FriendsFilter filter;

  int onCampusCount(DateTime now) =>
      friends.where((friend) => friendOnCampus(friend, now)).length;

  List<Friend> visible(DateTime now) => switch (filter) {
    FriendsFilter.all => friends,
    FriendsFilter.onCampus =>
      friends
          .where((friend) => friendOnCampus(friend, now))
          .toList(growable: false),
  };

  FriendsListState copyWith({
    FriendsListStatus? status,
    List<Friend>? friends,
    FriendsFilter? filter,
  }) {
    return FriendsListState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, friends, filter];
}

class FriendsListCubit extends Cubit<FriendsListState> {
  FriendsListCubit({required FriendsRepository friendsRepository})
    : _repository = friendsRepository,
      super(const FriendsListState());

  final FriendsRepository _repository;
  var _request = 0;

  Future<void> load() async {
    final request = ++_request;
    emit(state.copyWith(status: FriendsListStatus.loading));
    try {
      final friends = await _repository.getFriends();
      if (isClosed || request != _request) return;
      final sorted = [...friends]..sort(_byPresence);
      emit(state.copyWith(status: FriendsListStatus.loaded, friends: sorted));
    } on Object catch (error, stackTrace) {
      if (!isClosed && request == _request) {
        addError(error, stackTrace);
        emit(state.copyWith(status: FriendsListStatus.failure));
      }
    }
  }

  void setFilter(FriendsFilter filter) => emit(state.copyWith(filter: filter));

  Future<bool> removeFriend(String userId) async {
    if (isClosed) return false;
    try {
      await _repository.removeFriend(userId);
      if (isClosed) return false;
      emit(
        state.copyWith(
          friends: [
            for (final friend in state.friends)
              if (friend.userId != userId) friend,
          ],
        ),
      );
      return true;
    } on Object catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
      return false;
    }
  }

  static int _byPresence(Friend a, Friend b) {
    final now = DateTime.now();
    final campus =
        (friendOnCampus(b, now) ? 1 : 0) - (friendOnCampus(a, now) ? 1 : 0);
    if (campus != 0) return campus;
    return a.fullName.compareTo(b.fullName);
  }
}
