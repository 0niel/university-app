import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_circle_button.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_map_status_pill.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FriendsMapTopBar extends StatelessWidget {
  const FriendsMapTopBar({
    required this.isGhost,
    required this.friendsOnMap,
    required this.requestCount,
    required this.loading,
    required this.onBack,
    required this.onRequests,
    required this.onAddFriend,
    super.key,
  });

  final bool isGhost;
  final int friendsOnMap;
  final int requestCount;
  final bool loading;
  final VoidCallback onBack;
  final VoidCallback onRequests;
  final VoidCallback onAddFriend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const .fromLTRB(16, 8, 16, 0),
        child: Row(
          spacing: 8,
          children: [
            FriendsCircleButton(
              icon: .chevronL,
              label: l10n.back,
              onTap: onBack,
            ),
            Expanded(
              child: FriendsMapStatusPill(
                isGhost: isGhost,
                friendsOnMap: friendsOnMap,
                loading: loading,
              ),
            ),
            Stack(
              clipBehavior: .none,
              children: [
                FriendsCircleButton(
                  icon: .bell,
                  label: l10n.friendsRequests,
                  onTap: onRequests,
                ),
                if (requestCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: NinjaCountBadge(requestCount),
                  ),
              ],
            ),
            FriendsCircleButton(
              icon: .plus,
              label: l10n.friendsAddFriend,
              onTap: onAddFriend,
            ),
          ],
        ),
      ),
    );
  }
}
