import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapCanvasControls extends StatelessWidget {
  const MapCanvasControls({
    this.onZoomIn,
    this.onZoomOut,
    this.onFit,
    this.onToggle3D,
    this.onRotate,
    this.is3D = false,
    this.showZoom = true,
    this.axis = Axis.vertical,
    super.key,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFit;
  final VoidCallback? onToggle3D;
  final VoidCallback? onRotate;
  final bool is3D;
  final bool showZoom;
  final Axis axis;

  @override
  Widget build(BuildContext context) => Flex(
    direction: axis,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (showZoom) ...[
        AppGlassSurface(
          role: AppGlassRole.control,
          key: const ValueKey('map-zoom-controls'),
          borderRadius: AppRadius.full,
          child: Flex(
            direction: axis,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                icon: const AppLineIconWidget(AppLineIcon.plus),
                tooltip: context.l10n.mapZoomIn,
                shape: AppIconButtonShape.circle,
                tone: AppIconButtonTone.plain,
                onPressed: onZoomIn,
              ),
              AppIconButton(
                icon: const AppLineIconWidget(AppLineIcon.minus),
                tooltip: context.l10n.mapZoomOut,
                shape: AppIconButtonShape.circle,
                tone: AppIconButtonTone.plain,
                onPressed: onZoomOut,
              ),
            ],
          ),
        ),
        SizedBox(
          height: axis == Axis.vertical ? AppSpacing.sm : 0,
          width: axis == Axis.horizontal ? AppSpacing.sm : 0,
        ),
      ],
      AppIconButton(
        icon: const AppLineIconWidget(AppLineIcon.map),
        tooltip: context.l10n.mapFitFloorPlan,
        shape: AppIconButtonShape.circle,
        tone: AppIconButtonTone.glass,
        onPressed: onFit,
      ),
      if (onRotate != null) ...[
        SizedBox(
          height: axis == Axis.vertical ? AppSpacing.sm : 0,
          width: axis == Axis.horizontal ? AppSpacing.sm : 0,
        ),
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.refresh),
          tooltip: context.l10n.mapRotatePlan,
          shape: AppIconButtonShape.circle,
          tone: AppIconButtonTone.glass,
          onPressed: onRotate,
        ),
      ],
      if (onToggle3D != null) ...[
        SizedBox(
          height: axis == Axis.vertical ? AppSpacing.sm : 0,
          width: axis == Axis.horizontal ? AppSpacing.sm : 0,
        ),
        Semantics(
          toggled: is3D,
          child: AppIconButton(
            icon: Text(
              is3D ? context.l10n.map2DLabel : context.l10n.map3DLabel,
              style: AppText.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: is3D ? context.colors.accent : context.colors.ink,
              ),
            ),
            tooltip: is3D
                ? context.l10n.mapTopDownView
                : context.l10n.mapVolumeView,
            shape: AppIconButtonShape.circle,
            tone: AppIconButtonTone.glass,
            onPressed: onToggle3D,
          ),
        ),
      ],
    ],
  );
}
