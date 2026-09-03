part of '../people_widgets.dart';

class NinjaPeopleBody extends StatelessWidget {
  const NinjaPeopleBody({
    required this.state,
    required this.onRetry,
    required this.onAdd,
    required this.onCreateGroup,
    required this.onJoinByCode,
    required this.onDiscoverGroups,
    required this.onManageGroup,
    required this.onAddToFriends,
    required this.onRespondFriendRequest,
    required this.onRespondGroupInvite,
    super.key,
  });

  final PeopleState state;
  final Future<bool> Function() onRetry;
  final Future<void> Function() onAdd;
  final Future<void> Function() onCreateGroup;
  final Future<void> Function() onJoinByCode;
  final Future<void> Function() onDiscoverGroups;
  final Future<void> Function() onManageGroup;
  final Future<void> Function(String userId) onAddToFriends;
  final Future<void> Function({
    required String friendshipId,
    required bool accept,
  })
  onRespondFriendRequest;
  final Future<void> Function(String inviteId, {required bool accept})
  onRespondGroupInvite;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _content());
  }

  Widget _content() {
    if (state.status == .loading && !state.hasCachedData) {
      return NinjaPeopleLoadingSkeleton(
        key: ValueKey('people-loading-${state.tab.name}'),
        tab: state.tab,
      );
    }
    if (state.status == .failure && !state.hasCachedData) {
      return PeopleColdError(
        key: const ValueKey('people-error'),
        onRetry: onRetry,
      );
    }
    if (state.tab == .friends &&
        state.friends.isEmpty &&
        state.requests.isEmpty &&
        state.failedSources.contains(PeopleSource.friends)) {
      return PeopleColdError(
        key: const ValueKey('people-friends-error'),
        onRetry: onRetry,
      );
    }
    if (state.tab == .group &&
        !state.studyGroup.hasGroup &&
        state.failedSources.contains(PeopleSource.studyGroup)) {
      return PeopleColdError(
        key: const ValueKey('people-group-error'),
        onRetry: onRetry,
        studyGroupOnly: true,
      );
    }
    return switch (state.tab) {
      .friends => NinjaFriendsTab(
        key: const ValueKey('people-friends'),
        friends: state.friends,
        requests: state.requests,
        pendingResponseIds: state.pendingResponseIds,
        onRespond: onRespondFriendRequest,
        onAdd: onAdd,
      ),
      .group => NinjaStudyGroupTab(
        key: const ValueKey('people-group'),
        study: state.studyGroup,
        pendingFriendIds: state.pendingFriendIds,
        pendingInviteIds: state.pendingInviteIds,
        onAddToFriends: onAddToFriends,
        onCreate: onCreateGroup,
        onJoinByCode: onJoinByCode,
        onDiscover: onDiscoverGroups,
        onManage: onManageGroup,
        onRespondInvite: onRespondGroupInvite,
      ),
    };
  }
}
