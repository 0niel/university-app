import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSheetActionRow extends StatelessWidget {
  const AppSheetActionRow({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.isFirst = false,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final bool isFirst;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = isDestructive ? colors.error : colors.active;
    return AppPressable(
      onTap: onTap,
      child: Column(
        children: [
          if (!isFirst)
            Divider(height: 0.5, thickness: 0.5, color: colors.divider),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 20, color: colors.deactive),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.bodyLarge.copyWith(color: textColor),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          subtitle!,
                          style: AppText.captionSmall.copyWith(
                            color: colors.deactiveDarker,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: colors.deactiveDarker,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
