import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppSegmentedBarPart {
  const AppSegmentedBarPart({required this.flex, required this.color});

  final int flex;
  final Color color;
}

class AppSegmentedBar extends StatelessWidget {
  const AppSegmentedBar({
    required this.segments,
    super.key,
    this.height = 6,
    this.gap = 3,
    this.rest,
    this.restFlex = 0,
  });

  final List<AppSegmentedBarPart> segments;
  final double height;
  final double gap;
  final Color? rest;
  final int restFlex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final parts = <Widget>[];
    final all = [
      ...segments,
      if (restFlex > 0)
        AppSegmentedBarPart(flex: restFlex, color: rest ?? colors.surface2),
    ];

    for (var i = 0; i < all.length; i++) {
      if (i != 0) parts.add(SizedBox(width: gap));
      parts.add(
        Expanded(
          flex: all[i].flex,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: all[i].color,
              borderRadius: BorderRadius.circular(height / 2),
            ),
            child: SizedBox(height: height),
          ),
        ),
      );
    }

    return Row(children: parts);
  }
}
