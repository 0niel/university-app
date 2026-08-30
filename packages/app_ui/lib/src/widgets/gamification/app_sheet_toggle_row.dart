import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppSheetToggleRow extends StatelessWidget {
  const AppSheetToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.isFirst = false,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        if (!isFirst)
          Divider(height: 0.5, thickness: 0.5, color: colors.divider),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.bodyLarge.copyWith(color: colors.active),
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
