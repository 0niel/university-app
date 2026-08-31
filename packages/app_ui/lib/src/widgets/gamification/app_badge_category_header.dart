import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBadgeCategoryHeader extends StatelessWidget {
  const AppBadgeCategoryHeader({
    required this.title,
    required this.done,
    required this.total,
    super.key,
  });

  final String title;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppText.heading.copyWith(
              color: colors.active,
              letterSpacing: -0.2,
            ),
          ),
        ),
        Text(
          '$done/$total',
          style: AppText.caption.copyWith(
            color: colors.deactiveDarker,
            fontWeight: FontWeight.w600,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
