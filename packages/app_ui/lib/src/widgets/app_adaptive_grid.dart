import 'package:flutter/widgets.dart';

class AppAdaptiveGrid extends StatelessWidget {
  const AppAdaptiveGrid({
    required this.children,
    this.spacing = 10,
    this.runSpacing = 10,
    super.key,
  }) : assert(spacing >= 0, 'Grid spacing must be non-negative'),
       assert(runSpacing >= 0, 'Grid row spacing must be non-negative');

  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  static int columnsFor(BuildContext context, double width) {
    if (MediaQuery.textScalerOf(context).scale(1) >= 1.5 || width < 300) {
      return 1;
    }
    if (width >= 900) return 4;
    if (width >= 620) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = columnsFor(context, constraints.maxWidth);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var offset = 0; offset < children.length; offset += columns) ...[
            if (offset != 0) SizedBox(height: runSpacing),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column != 0) SizedBox(width: spacing),
                    Expanded(
                      child: offset + column < children.length
                          ? children.elementAtOrNull(offset + column)!
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    },
  );
}
