import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapCanvasControls extends StatelessWidget {
  const MapCanvasControls({
    this.onZoomIn,
    this.onZoomOut,
    this.onFit,
    this.axis = Axis.vertical,
    super.key,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFit;
  final Axis axis;

  @override
  Widget build(BuildContext context) => Flex(
    direction: axis,
    mainAxisSize: MainAxisSize.min,
    children: [
      AppCard(
        padding: EdgeInsets.zero,
        radius: AppRadius.full,
        child: Flex(
          direction: axis,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.plus),
              tooltip: context.l10n.mapZoomIn,
              shape: AppIconButtonShape.circle,
              tone: AppIconButtonTone.surface,
              onPressed: onZoomIn,
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.minus),
              tooltip: context.l10n.mapZoomOut,
              shape: AppIconButtonShape.circle,
              tone: AppIconButtonTone.surface,
              onPressed: onZoomOut,
            ),
          ],
        ),
      ),
      SizedBox(
        height: axis == Axis.vertical ? AppSpacing.sm : 0,
        width: axis == Axis.horizontal ? AppSpacing.sm : 0,
      ),
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.map),
        tooltip: context.l10n.mapFitFloorPlan,
        shape: AppIconButtonShape.circle,
        tone: AppIconButtonTone.surface,
        onPressed: onFit,
      ),
    ],
  );
}
