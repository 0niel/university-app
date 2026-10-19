import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/theme/app_surface_style.dart';
import 'package:app_ui/src/widgets/app_divider.dart';
import 'package:flutter/widgets.dart';

class AppListGroup extends StatelessWidget {
  const AppListGroup({
    required this.children,
    super.key,
    this.radius = AppRadius.card,
    this.color,
    this.margin,
    this.dividerIndent = 0,
    this.showDividers = true,
  });

  final List<Widget> children;
  final double radius;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double dividerIndent;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = children
        .where((child) => child is! SizedBox || child.child != null)
        .toList();
    final rows = <Widget>[];

    for (var i = 0; i < visible.length; i++) {
      rows.add(visible[i]);
      if (showDividers && i != visible.length - 1) {
        rows.add(
          AppDivider(
            indent: dividerIndent,
            color: colors.line.withValues(
              alpha: colors.line.a * (colors.isDark ? .62 : .75),
            ),
          ),
        );
      }
    }

    Widget group = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(radius),
        gradient: color == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.alphaBlend(
                    colors.white.withValues(alpha: colors.isDark ? .025 : .22),
                    colors.surface,
                  ),
                  colors.surface,
                ],
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        ),
      ),
    );

    group = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: AppSurfaceStyle.outline(context),
      ),
      child: group,
    );
    if (margin != null) {
      group = Padding(padding: margin!, child: group);
    }
    return group;
  }
}
