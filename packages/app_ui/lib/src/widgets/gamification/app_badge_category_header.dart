import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

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
            style: AppText.sectionSmall.copyWith(color: colors.ink),
          ),
        ),
        const SizedBox(width: AppSpacing.gap),
        Text(
          '$done/$total',
          style: AppText.tabular(AppText.subtextStrong).copyWith(
            color: colors.muted,
          ),
        ),
      ],
    );
  }
}
