import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaFindFriendsSectionHeader extends StatelessWidget {
  const NinjaFindFriendsSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitleText = subtitle;
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        26,
        AppSpacing.screen,
        12,
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 3,
        children: [
          Text(
            title,
            style: AppText.headline.copyWith(color: colors.ink),
          ),
          if (subtitleText != null)
            Text(
              subtitleText,
              style: AppText.caption.copyWith(color: colors.muted),
            ),
        ],
      ),
    );
  }
}
