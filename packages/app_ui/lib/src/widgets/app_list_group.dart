import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
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
          Padding(
            padding: EdgeInsets.only(left: dividerIndent),
            child: SizedBox(height: 1, child: ColoredBox(color: colors.line)),
          ),
        );
      }
    }

    Widget group = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: BorderRadius.circular(radius),
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

    if (margin != null) {
      group = Padding(padding: margin!, child: group);
    }
    return group;
  }
}
