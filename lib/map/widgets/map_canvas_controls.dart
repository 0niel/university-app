import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_action_button.dart';

class MapCanvasControls extends StatelessWidget {
  const MapCanvasControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
    super.key,
  });

  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onFit;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final compact = MediaQuery.heightOf(context) < 520;
    final zoomControls = [
      MapActionButton(tooltip: l10n.mapZoomIn, icon: .plus, onTap: onZoomIn),
      MapActionButton(tooltip: l10n.mapZoomOut, icon: .minus, onTap: onZoomOut),
    ];
    final zoomGroup = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: .circular(NinjaRadius.pill),
      ),
      child: Padding(
        padding: const .all(4),
        child: compact
            ? Row(
                mainAxisSize: .min,
                children: [
                  for (final control in zoomControls) control,
                ],
              )
            : Column(
                mainAxisSize: .min,
                children: [
                  for (final control in zoomControls) control,
                ],
              ),
      ),
    );
    final fit = _MapFitButton(
      label: l10n.mapWholeFloor,
      semanticsLabel: l10n.mapFitFloorPlan,
      onTap: onFit,
    );
    return compact
        ? Row(
            mainAxisSize: .min,
            children: [zoomGroup, const SizedBox(width: 10), fit],
          )
        : Column(
            mainAxisSize: .min,
            children: [zoomGroup, const SizedBox(height: 10), fit],
          );
  }
}

class _MapFitButton extends StatelessWidget {
  const _MapFitButton({
    required this.label,
    required this.semanticsLabel,
    required this.onTap,
  });

  final String label;
  final String semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    return AnimatedOpacity(
      opacity: onTap == null ? .45 : 1,
      duration: NinjaMotion.of(context, NinjaMotion.fast),
      child: Tooltip(
        message: semanticsLabel,
        child: AppPressable(
          onTap: onTap,
          haptics: true,
          semanticsLabel: semanticsLabel,
          semanticsButton: true,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: NinjaMetrics.minTouchTarget,
            ),
            padding: const .symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: .circular(NinjaRadius.pill),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                AppLineIconWidget(.map, size: 19, color: colors.ink),
                const SizedBox(width: 8),
                Text(
                  label,
                  maxLines: 1,
                  style: NinjaText.button.copyWith(color: colors.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
