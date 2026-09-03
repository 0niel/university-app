import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class FindFriendsAddAction extends StatelessWidget {
  const FindFriendsAddAction({
    required this.sent,
    required this.onAdd,
    this.isFriend = false,
    this.subtle = false,
    this.loading = false,
    super.key,
  });

  final bool sent;
  final bool isFriend;
  final bool subtle;
  final bool loading;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (isFriend) {
      return AppTag(label: l10n.friendsInFriends);
    }
    if (sent) {
      return AppTag(label: l10n.friendsRequestSent);
    }
    return AppButton(
      label: l10n.friendsAddBare,
      variant: subtle ? AppButtonVariant.secondary : AppButtonVariant.primary,
      size: AppButtonSize.small,
      loading: loading,
      onPressed: loading ? null : onAdd,
    );
  }
}
