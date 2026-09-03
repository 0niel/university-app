import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:friends_repository/friends_repository.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsListRow extends StatelessWidget {
  const FriendsListRow({
    required this.friend,
    required this.now,
    this.onTap,
    super.key,
  });

  final Friend friend;
  final DateTime now;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final presence = friendPresence(friend, now);
    final status = switch (presence) {
      FriendPresence.hidden => l10n.friendsStatusHidden,
      FriendPresence.live => l10n.friendsStatusLive,
      FriendPresence.recent => l10n.friendsStatusRecent,
      FriendPresence.off => l10n.friendsStatusGeoOff,
    };
    return AppListRow(
      title: friend.fullName,
      onTap: onTap,
      strong: true,
      subtitle: [
        if (friend.group case final group? when group.isNotEmpty) group,
        status,
      ].join(' · '),
      leading: AppAvatar(
        name: friend.fullName,
        size: 44,
        online: presence == FriendPresence.live,
      ),
      showChevron: false,
    );
  }
}
