import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class AppMetaPill extends StatelessWidget {
  const AppMetaPill({
    required this.text,
    super.key,
    this.icon,
    this.iconColor,
    this.strong = false,
  });

  final String text;
  final Widget? icon;
  final Color? iconColor;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = this.icon;
    final foreground = strong ? colors.ink : colors.muted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gap,
        vertical: AppSpacing.xsm,
      ),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: iconColor ?? foreground,
                size: AppIconSize.xs,
              ),
              child: icon,
            ),
            const SizedBox(width: AppSpacing.xsm),
          ],
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (strong ? AppText.subtextStrong : AppText.subtext)
                  .copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
