import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class AppHashTag extends StatelessWidget {
  const AppHashTag({
    required this.label,
    super.key,
    this.color,
    this.onTap,
  });

  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        '#$label',
        style: AppText.captionStrong.copyWith(color: color ?? colors.muted),
      ),
    );

    if (onTap == null) return content;
    return AppPressable(
      onTap: onTap,
      semanticsLabel: '#$label',
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: AppControlSize.touchTarget,
          minHeight: AppControlSize.touchTarget,
        ),
        child: Center(widthFactor: 1, heightFactor: 1, child: content),
      ),
    );
  }
}
