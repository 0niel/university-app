import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSettingsToggleRow extends StatelessWidget {
  const AppSettingsToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.leading,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? subtitle;
  final Widget? leading;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFirst)
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: leading != null ? 56 : 16,
            color: colors.divider,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.body.copyWith(color: colors.active),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppText.captionSmall.copyWith(
                          color: colors.deactive,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: colors.primary,
                inactiveTrackColor: colors.surfaceLow,
                inactiveThumbColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
