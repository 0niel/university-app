import 'package:app_ui/src/widgets/app_adaptive_grid.dart';
import 'package:flutter/widgets.dart';

class AppSliverAdaptiveGrid extends StatelessWidget {
  const AppSliverAdaptiveGrid({
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = 10,
    this.runSpacing = 10,
    super.key,
  }) : assert(itemCount >= 0, 'Grid item count must be non-negative'),
       assert(spacing >= 0, 'Grid spacing must be non-negative'),
       assert(runSpacing >= 0, 'Grid row spacing must be non-negative');

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final columns = AppAdaptiveGrid.columnsFor(
        context,
        constraints.crossAxisExtent,
      );
      final rows = (itemCount / columns).ceil();
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, row) {
            final offset = row * columns;
            Widget itemAt(int index) => IndexedSemantics(
              index: index,
              child: itemBuilder(context, index),
            );
            final child = columns == 1
                ? itemAt(offset)
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var column = 0; column < columns; column++) ...[
                          if (column != 0) SizedBox(width: spacing),
                          Expanded(
                            child: offset + column < itemCount
                                ? itemAt(offset + column)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ],
                    ),
                  );
            return Padding(
              padding: EdgeInsets.only(top: row == 0 ? 0 : runSpacing),
              child: child,
            );
          },
          childCount: rows,
          addSemanticIndexes: false,
        ),
      );
    },
  );
}
