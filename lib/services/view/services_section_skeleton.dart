import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'service_tile_skeleton.dart';

class ServicesSectionSkeleton extends StatelessWidget {
  const ServicesSectionSkeleton({super.key, this.tileCount = 8});

  final int tileCount;

  @override
  Widget build(BuildContext context) {
    return NinjaSkeletonGroup(
      semanticsLabel: context.l10n.loadingContent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: NinjaMetrics.screenPadding,
              vertical: 8,
            ),
            child: NinjaSkeleton(width: 148, height: 19, radius: 9),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NinjaMetrics.screenPadding,
              16,
              NinjaMetrics.screenPadding,
              24,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                final minimumCellWidth = textScale >= 1.75
                    ? 108.0
                    : textScale >= 1.3
                    ? 88.0
                    : 74.0;
                final columns = (constraints.maxWidth / minimumCellWidth)
                    .floor()
                    .clamp(2, 5);
                return LayoutGrid(
                  columnSizes: List.filled(columns, 1.fr),
                  rowSizes: List.generate(
                    (tileCount / columns).ceil(),
                    (_) => auto,
                  ),
                  columnGap: 10,
                  rowGap: textScale >= 1.5 ? 24 : 18,
                  children: List.generate(
                    tileCount,
                    (_) => const _ServiceTileSkeleton(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
