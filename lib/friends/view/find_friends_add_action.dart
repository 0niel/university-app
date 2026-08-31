import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_tone.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FindFriendsAddAction extends StatelessWidget {
  const FindFriendsAddAction({
    required this.sent,
    required this.onAdd,
    this.isFriend = false,
    this.subtle = false,
    super.key,
  });

  final bool sent;
  final bool isFriend;
  final bool subtle;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (isFriend) {
      return NinjaBadge(l10n.friendsInFriends, tone: .ink);
    }
    if (sent) {
      return NinjaChip(label: l10n.friendsRequestSent, enabled: false);
    }
    return FriendsPillButton(
      label: l10n.friendsAddBare,
      tone: subtle ? FriendsTone.neutral : FriendsTone.accent,
      onTap: onAdd,
    );
  }
}
