import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_panel_layout.dart';

part 'map_loading_mark.dart';
part 'map_panel_skeleton.dart';

class MapSkeleton extends StatelessWidget {
  const MapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final media = MediaQuery.of(context);
    final layout = MapPanelLayout.from(media);
    return Semantics(
      liveRegion: true,
      label: context.l10n.mapOpeningFloor,
      child: NinjaSkeletonGroup(
        child: Stack(
          fit: .expand,
          children: [
            ColoredBox(color: colors.canvas),
            const Center(child: _MapLoadingMark()),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const .fromLTRB(
                  NinjaMetrics.screenPadding,
                  8,
                  NinjaMetrics.screenPadding,
                  0,
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    if (Navigator.of(context).canPop()) ...[
                      const NinjaSkeleton.avatar(),
                      const SizedBox(width: 10),
                    ],
                    const Expanded(
                      child: NinjaSkeleton(
                        height: 52,
                        radius: NinjaRadius.pill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: NinjaMetrics.screenPadding,
              bottom: layout.collapsedPixels + 12,
              child: const Column(
                mainAxisSize: .min,
                children: [
                  NinjaSkeleton.avatar(),
                  SizedBox(height: 10),
                  NinjaSkeleton.avatar(),
                  SizedBox(height: 10),
                  NinjaSkeleton.avatar(),
                ],
              ),
            ),
            _MapPanelSkeleton(layout: layout),
          ],
        ),
      ),
    );
  }
}
