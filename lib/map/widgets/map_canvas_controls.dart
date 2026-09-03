import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapCanvasControls extends StatelessWidget {
  const MapCanvasControls({
    this.onZoomIn,
    this.onZoomOut,
    this.onFit,
    super.key,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFit;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.plus),
        tooltip: context.l10n.mapZoomIn,
        shape: AppIconButtonShape.circle,
        tone: AppIconButtonTone.surface,
        onPressed: onZoomIn,
      ),
      const SizedBox(height: 6),
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.minus),
        tooltip: context.l10n.mapZoomOut,
        shape: AppIconButtonShape.circle,
        tone: AppIconButtonTone.surface,
        onPressed: onZoomOut,
      ),
      const SizedBox(height: 6),
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
