import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_pill_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaFindFriendsGroupAction extends StatelessWidget {
  const NinjaFindFriendsGroupAction({
    required this.count,
    required this.onTap,
    this.loading = false,
    super.key,
  });

  final int count;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
      child: FriendsPillButton(
        label: context.l10n.friendsAddWholeGroup(count),
        tone: .neutral,
        expanded: true,
        loading: loading,
        onTap: onTap,
      ),
    );
  }
}
