import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppMetaPill extends StatelessWidget {
  const AppMetaPill({
    required this.text,
    super.key,
    this.icon,
    this.iconColor,
    this.strong = false,
  });

  final String text;

  final Widget? icon;

  final Color? iconColor;

  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final icon = this.icon;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const SizedBox(width: 5)],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.caption.copyWith(
                fontSize: 12.5,
                color: strong ? colors.active : colors.deactive,
                fontWeight: strong ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
