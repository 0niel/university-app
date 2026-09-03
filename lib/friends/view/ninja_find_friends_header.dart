import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaFindFriendsHeader extends StatelessWidget {
  const NinjaFindFriendsHeader({
    required this.title,
    required this.closeLabel,
    required this.onClose,
    super.key,
  });

  final String title;
  final String closeLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AppScreenHeader(
      title: title,
      actions: [
        AppHeaderAction(
          icon: AppLineIcon.close,
          semanticsLabel: closeLabel,
          onTap: onClose,
        ),
      ],
    );
  }
}
