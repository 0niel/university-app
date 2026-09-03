import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_press_state.dart';
import 'package:flutter/material.dart';

class AppActionBarButton extends StatelessWidget {
  const AppActionBarButton({
    required this.icon,
    required this.label,
    super.key,
    this.onTap,
    this.background,
    this.foreground,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = background ?? colors.surface;
    final ink = foreground ?? colors.ink;

    return AppPressState(
      onTap: onTap,
      semanticsLabel: label,
      semanticsButton: true,
      builder: (context, {required pressed}) => AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: AppControlSize.iconButton),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.badgeInset,
        ),
        decoration: BoxDecoration(
          color: pressed ? colors.canvas : fill,
          borderRadius: BorderRadius.circular(AppRadius.tile),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme.merge(
              data: IconThemeData(color: ink, size: AppIconSize.action),
              child: icon,
            ),
            const SizedBox(width: AppSpacing.compactGap),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.subtextStrong.copyWith(color: ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
