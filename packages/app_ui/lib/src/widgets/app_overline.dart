import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class AppOverline extends StatelessWidget {
  const AppOverline(
    this.label, {
    super.key,
    this.topPadding = AppSpacing.contentGap,
    this.bottomPadding = AppSpacing.gap,
    this.color,
  });

  final String label;
  final double topPadding;
  final double bottomPadding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: AppSpacing.xxs,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.overline.copyWith(color: color ?? context.colors.muted),
      ),
    );
  }
}
