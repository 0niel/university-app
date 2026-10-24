import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class MapCanvasControls extends StatefulWidget {
  const MapCanvasControls({
    this.onZoomIn,
    this.onZoomOut,
    this.onFit,
    this.onToggle3D,
    this.onRotate,
    this.is3D = false,
    this.showZoom = true,
    this.axis = Axis.vertical,
    this.joinParentBatch = false,
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
  final bool joinParentBatch;

  @override
  State<MapCanvasControls> createState() => _MapCanvasControlsState();
}

class _MapCanvasControlsState extends State<MapCanvasControls> {
  final GlobalKey _controlsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controls = Flex(
      key: _controlsKey,
      direction: widget.axis,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showZoom) ...[
          AppGlassSurface(
            role: AppGlassRole.control,
            key: const ValueKey('map-zoom-controls'),
            borderRadius: AppRadius.full,
            child: Flex(
              direction: widget.axis,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.plus),
                  tooltip: context.l10n.mapZoomIn,
                  shape: AppIconButtonShape.circle,
                  tone: AppIconButtonTone.plain,
                  onPressed: widget.onZoomIn,
                ),
                AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.minus),
                  tooltip: context.l10n.mapZoomOut,
                  shape: AppIconButtonShape.circle,
                  tone: AppIconButtonTone.plain,
                  onPressed: widget.onZoomOut,
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.axis == Axis.vertical ? AppSpacing.sm : 0,
            width: widget.axis == Axis.horizontal ? AppSpacing.sm : 0,
          ),
        ],
        AppIconButton(
          icon: const AppLineIconWidget(AppLineIcon.map),
          tooltip: context.l10n.mapFitFloorPlan,
          shape: AppIconButtonShape.circle,
          tone: AppIconButtonTone.glass,
          onPressed: widget.onFit,
        ),
        if (widget.onRotate != null) ...[
          SizedBox(
            height: widget.axis == Axis.vertical ? AppSpacing.sm : 0,
            width: widget.axis == Axis.horizontal ? AppSpacing.sm : 0,
          ),
          AppIconButton(
            icon: const AppLineIconWidget(AppLineIcon.refresh),
            tooltip: context.l10n.mapRotatePlan,
            shape: AppIconButtonShape.circle,
            tone: AppIconButtonTone.glass,
            onPressed: widget.onRotate,
          ),
        ],
        if (widget.onToggle3D != null) ...[
          SizedBox(
            height: widget.axis == Axis.vertical ? AppSpacing.sm : 0,
            width: widget.axis == Axis.horizontal ? AppSpacing.sm : 0,
          ),
          Semantics(
            toggled: widget.is3D,
            child: AppIconButton(
              icon: Text(
                widget.is3D ? context.l10n.map2DLabel : context.l10n.map3DLabel,
                style: AppText.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: widget.is3D
                      ? context.colors.accent
                      : context.colors.ink,
                ),
              ),
              tooltip: widget.is3D
                  ? context.l10n.mapTopDownView
                  : context.l10n.mapVolumeView,
              shape: AppIconButtonShape.circle,
              tone: AppIconButtonTone.glass,
              onPressed: widget.onToggle3D,
            ),
          ),
        ],
      ],
    );
    return widget.joinParentBatch
        ? controls
        : AppGlassBatch.controls(child: controls);
  }
}
