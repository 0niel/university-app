import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_timeline.dart';

class MapRouteGuidance extends StatefulWidget {
  const MapRouteGuidance({
    required this.campus,
    required this.route,
    required this.stepIndex,
    required this.onClose,
    this.onNext,
    this.onPrevious,
    this.onStepSelected,
    super.key,
  }) : assert(stepIndex >= 0, 'Step index must be nonnegative');

  final CampusMapData campus;
  final IndoorRoute route;
  final int stepIndex;
  final VoidCallback onClose;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final ValueChanged<int>? onStepSelected;

  @override
  State<MapRouteGuidance> createState() => _MapRouteGuidanceState();
}

class _MapRouteGuidanceState extends State<MapRouteGuidance> {
  int? _previewStep;

  @override
  void didUpdateWidget(MapRouteGuidance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.route, widget.route) ||
        !identical(oldWidget.campus, widget.campus) ||
        oldWidget.stepIndex != widget.stepIndex ||
        widget.onStepSelected == null) {
      _previewStep = null;
    }
  }

  void _cancelPreview() {
    if (_previewStep != null) setState(() => _previewStep = null);
  }

  void _select(int index) {
    _cancelPreview();
    widget.onStepSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    assert(
      widget.stepIndex < widget.route.instructions.length,
      'Step index must belong to the route',
    );
    final stepIndex = _previewStep ?? widget.stepIndex;
    final route = widget.route;
    final campus = widget.campus;
    if (stepIndex < 0) return const SizedBox.shrink();
    final instruction = route.instructions.elementAtOrNull(stepIndex);
    if (instruction == null) return const SizedBox.shrink();
    final isLast = stepIndex == route.instructions.length - 1;
    final colors = context.colors;
    final compact = MediaQuery.heightOf(context) < 600;
    final fullLabel = isLast
        ? l10n.mapRouteEnd
        : mapRouteInstructionLabel(instruction, campus, l10n);
    final instructionContext = mapRouteInstructionContext(
      instruction,
      campus,
      l10n,
    );
    final compactLabel = mapRouteInstructionCompactLabel(
      instruction.maneuver,
      l10n,
    );
    return AppCard(
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!compact) ...[
                AppIconTile(
                  background: colors.tint,
                  child: Icon(
                    mapRouteInstructionIcon(instruction.maneuver),
                    color: colors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  excludeSemantics: compact,
                  label: compact
                      ? l10n.mapRouteStepAnnouncement(
                          stepIndex + 1,
                          route.instructions.length,
                          fullLabel,
                          instructionContext,
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              compact ? compactLabel : fullLabel,
                              style: compact
                                  ? AppText.captionStrong
                                  : AppText.bodyStrong,
                              maxLines: compact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (compact) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${stepIndex + 1}/${route.instructions.length}',
                              style: AppText.captionSmall.copyWith(
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$instructionContext'
                        '${compact ? ' · ${campus.campus.displayName}' : ''}',
                        style:
                            (compact ? AppText.captionSmall : AppText.caption)
                                .copyWith(color: colors.muted),
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              AppIconButton(
                tooltip: l10n.mapRouteFinish,
                shape: AppIconButtonShape.circle,
                size: AppIconButtonSize.compact,
                tone: AppIconButtonTone.surface,
                onPressed: widget.onClose,
                icon: const AppLineIconWidget(AppLineIcon.close),
              ),
            ],
          ),
          if (!compact)
            Text(
              l10n.mapRouteManualStepProgress(
                stepIndex + 1,
                route.instructions.length,
              ),
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          const SizedBox(height: AppSpacing.xs),
          MapRouteTimeline(
            campus: campus,
            route: route,
            stepIndex: stepIndex,
            onPreview: (index) => setState(() => _previewStep = index),
            onCancelPreview: _cancelPreview,
            onSelected: widget.onStepSelected == null ? null : _select,
            onPrevious: _previewStep == null && widget.stepIndex > 0
                ? widget.onPrevious
                : null,
            onNext: _previewStep == null ? widget.onNext : null,
          ),
        ],
      ),
    );
  }
}
