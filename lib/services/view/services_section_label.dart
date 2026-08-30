import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ServicesSectionLabel extends StatelessWidget {
  const ServicesSectionLabel({required this.title, super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final trailing = this.trailing;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: NinjaMetrics.screenPadding,
        vertical: 8,
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: NinjaText.title.copyWith(color: colors.ink),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing,
          ],
        ],
      ),
    );
  }
}
