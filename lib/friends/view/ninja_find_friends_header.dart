import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/friends/widgets/friends_circle_button.dart';

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
    final colors = context.ninja;
    final compact = MediaQuery.textScalerOf(context).scale(1) >= 1.6;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        12,
        NinjaMetrics.screenPadding,
        6,
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: .ellipsis,
              style: (compact ? NinjaText.title : NinjaText.display).copyWith(
                color: colors.ink,
              ),
            ),
          ),
          FriendsCircleButton(
            icon: .close,
            label: closeLabel,
            onTap: onClose,
          ),
        ],
      ),
    );
  }
}
