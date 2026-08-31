part of 'find_friends_cubit.dart';

@freezed
abstract class FindFriendsState with _$FindFriendsState {
  const factory FindFriendsState({
    @Default(FindFriendsStatus.initial) FindFriendsStatus status,
    @Default(GroupRoster.empty) GroupRoster roster,
    @Default(<SuggestedFriend>[]) List<SuggestedFriend> suggestions,
    @Default(<UserSearchResult>[]) List<UserSearchResult> results,
    @Default('') String query,
    @Default(false) bool searching,
    @Default(<String>{}) Set<String> sentTo,
    @Default(false) bool isAddingGroup,
  }) = _FindFriendsState;

  const FindFriendsState._();

  bool get hasQuery => query.trim().length >= 2;

  List<GroupMember> get groupmates =>
      roster.members.where((m) => !m.isMe && !m.isFriend).toList();

  List<SuggestedFriend> get visibleSuggestions {
    final groupIds = roster.members.map((m) => m.userId).toSet();
    return suggestions.where((s) => !groupIds.contains(s.userId)).toList();
  }

  bool isSent(String userId, [String? status]) =>
      sentTo.contains(userId) || status == 'pending';
}
