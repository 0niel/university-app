import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class NinjaDisplayHeader extends StatelessWidget {
  const NinjaDisplayHeader({
    required this.title,
    super.key,
    this.summary,
    this.overline,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      AppSpacing.sectionGap,
      AppSpacing.screen,
      AppSpacing.zero,
    ),
  });

  final String title;
  final String? summary;
  final String? overline;
  final Widget? trailing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final summary = this.summary;
    final overline = this.overline;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (overline != null) ...[
                  Text(
                    overline.toUpperCase(),
                    style: AppText.overline.copyWith(color: colors.muted),
                  ),
                  const SizedBox(height: AppSpacing.xsm),
                ],
                Text(
                  title,
                  style: AppText.display.copyWith(color: colors.ink),
                ),
                if (summary != null) ...[
                  const SizedBox(height: AppSpacing.xsm),
                  Text(
                    summary,
                    style: AppText.sans(13, FontWeight.w500)
                        .copyWith(color: colors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
