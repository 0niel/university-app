import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaScheduleSectionHeader extends StatelessWidget {
  const NinjaScheduleSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: NinjaText.headline.copyWith(color: colors.ink),
              ),
              if (subtitle case final subtitleText?) ...[
                const SizedBox(height: 3),
                Text(
                  subtitleText,
                  style: NinjaText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel case final actionText?)
          NinjaButton.text(
            label: actionText,
            size: NinjaButtonSize.small,
            onPressed: onAction,
          ),
      ],
    );
  }
}
