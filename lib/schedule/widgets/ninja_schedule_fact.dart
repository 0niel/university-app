import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaScheduleFact extends StatelessWidget {
  const NinjaScheduleFact({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.foreground,
    this.muted,
  });

  final String label;
  final String value;
  final AppLineIcon icon;
  final Color? foreground;
  final Color? muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final ink = foreground ?? colors.ink;
    final secondary = muted ?? colors.muted;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 116, minHeight: 64),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLineIconWidget(icon, size: 18, color: secondary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: NinjaText.body.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: NinjaText.helper.copyWith(color: secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
