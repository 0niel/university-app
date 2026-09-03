import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class AppIconTile extends StatelessWidget {
  const AppIconTile({
    super.key,
    this.icon,
    this.child,
    this.size = AppControlSize.iconTile,
    this.radius = AppRadius.iconTile,
    this.background,
    this.foreground,
    this.iconSize,
    this.strokeWidth = 2,
  }) : assert(
          icon != null || child != null,
          'AppIconTile needs an icon or a child',
        );

  final AppLineIcon? icon;
  final Widget? child;
  final double size;
  final double radius;
  final Color? background;
  final Color? foreground;
  final double? iconSize;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = foreground ?? colors.ink;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? colors.surface2,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child ??
          AppLineIconWidget(
            icon!,
            size: iconSize ?? size / 2,
            color: fg,
            strokeWidth: strokeWidth,
          ),
    );
  }
}
