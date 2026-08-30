import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'find_friend_card_skeleton.dart';

class NinjaFindFriendsResultsSkeleton extends StatelessWidget {
  const NinjaFindFriendsResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        children: [
          for (var index = 0; index < 4; index++)
            const _FindFriendCardSkeleton(),
        ],
      ),
    );
  }
}
