import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/cubit/find_friends_cubit.dart';
import 'package:rtu_mirea_app/friends/view/find_friends_add_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friend_card.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_discovery_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_group_action.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_invite_card.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_results_skeleton.dart';
import 'package:rtu_mirea_app/friends/view/ninja_find_friends_section_header.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FindFriendsDiscovery extends StatelessWidget {
  const FindFriendsDiscovery({
    required this.state,
    required this.onShowQr,
    required this.onScan,
    required this.onSendRequest,
    required this.onAddWholeGroup,
    required this.onInvite,
    required this.onRetry,
    super.key,
  });

  final FindFriendsState state;
  final VoidCallback onShowQr;
  final VoidCallback onScan;
  final ValueChanged<String> onSendRequest;
  final VoidCallback onAddWholeGroup;
  final VoidCallback onInvite;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loading = state.status == FindFriendsStatus.loading;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: NinjaFindFriendsDiscoveryAction(
                  icon: AppLineIcon.qr,
                  title: l10n.friendsMyQr,
                  subtitle: l10n.friendsMyQrSub,
                  accented: !loading,
                  onTap: onShowQr,
                ),
              ),
              Expanded(
                child: NinjaFindFriendsDiscoveryAction(
                  icon: AppLineIcon.camera,
                  title: l10n.friendsScan,
                  subtitle: l10n.friendsScanSub,
                  onTap: onScan,
                ),
              ),
            ],
          ),
        ).animateSectionEntrance(),
        NinjaStateSwitcher(child: _people(l10n)),
        const SizedBox(height: 26),
        NinjaFindFriendsInviteCard(
          onTap: onInvite,
        ).animateSectionEntrance(index: 1),
      ],
    );
  }

  Widget _people(AppLocalizations l10n) {
    final groupmates = state.groupmates;
    final suggestions = state.visibleSuggestions;
    if (state.status == FindFriendsStatus.loading) {
      return const Padding(
        key: ValueKey('loading'),
        padding: .only(top: 26),
        child: NinjaFindFriendsResultsSkeleton(),
      );
    }
    if (state.status == FindFriendsStatus.failure) {
      return Padding(
        key: const ValueKey('failure'),
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          26,
          NinjaMetrics.screenPadding,
          0,
        ),
        child: NinjaErrorCard(
          title: l10n.loadingError,
          message: l10n.tryAgain,
          actionLabel: l10n.retry,
          onAction: onRetry,
        ),
      );
    }
    if (groupmates.isEmpty && suggestions.isEmpty) {
      if (state.status == FindFriendsStatus.initial) {
        return const SizedBox.shrink(key: ValueKey('idle'));
      }
      return Padding(
        key: const ValueKey('empty'),
        padding: const .fromLTRB(
          NinjaMetrics.screenPadding,
          26,
          NinjaMetrics.screenPadding,
          0,
        ),
        child: NinjaEmptyState(
          icon: const AppLineIconWidget(AppLineIcon.people),
          title: l10n.friendsEmptyTitle,
          message: l10n.friendsEmptySub,
        ).animateEmptyState(),
      );
    }
    return Column(
      key: const ValueKey('people'),
      crossAxisAlignment: .start,
      children: [
        if (groupmates.isNotEmpty) ...[
          NinjaFindFriendsSectionHeader(
            title: state.roster.group != null
                ? l10n.friendsFromGroupNamed(state.roster.group ?? '')
                : l10n.friendsFromGroup,
            subtitle: l10n.friendsNotYetFriends,
          ),
          for (final (index, member) in groupmates.take(6).indexed)
            NinjaFindFriendCard(
              name: member.fullName,
              subtitle: [
                if (member.handle != null) '@${member.handle}',
                l10n.friendsYourGroup,
              ].join(' · '),
              trailing: FindFriendsAddAction(
                sent: state.isSent(member.userId, member.friendshipStatus),
                onAdd: () => onSendRequest(member.userId),
              ),
            ).animateListItem(index: index),
          NinjaFindFriendsGroupAction(
            count: state.roster.members.length,
            loading: state.isAddingGroup,
            onTap: onAddWholeGroup,
          ),
        ],
        if (suggestions.isNotEmpty) ...[
          NinjaFindFriendsSectionHeader(title: l10n.friendsMayKnow),
          for (final (index, suggestion) in suggestions.indexed)
            NinjaFindFriendCard(
              name: suggestion.fullName,
              subtitle: suggestion.mutualCount > 0
                  ? l10n.friendsMutual(suggestion.mutualCount)
                  : (suggestion.group ?? ''),
              trailing: FindFriendsAddAction(
                sent: state.sentTo.contains(suggestion.userId),
                subtle: true,
                onAdd: () => onSendRequest(suggestion.userId),
              ),
            ).animateListItem(index: index),
        ],
      ],
    );
  }
}
