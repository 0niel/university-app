import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

class MapRouteOptions extends StatelessWidget {
  const MapRouteOptions({
    required this.options,
    required this.canEstimateDuration,
    required this.onChanged,
    super.key,
  });

  final IndoorRouteOptions options;
  final bool canEstimateDuration;
  final ValueChanged<IndoorRouteOptions> onChanged;

  void _access({bool stepFree = false, bool wheelchair = false}) => onChanged(
    IndoorRouteOptions(
      stepFree: stepFree,
      wheelchair: wheelchair,
      metric: options.metric,
      closedEdgeIds: options.closedEdgeIds,
      closedNodeIds: options.closedNodeIds,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accessLabel = options.wheelchair
        ? l10n.mapRouteWheelchair
        : options.stepFree
        ? l10n.mapRouteStepFree
        : l10n.mapRouteWalking;
    return AppListGroup(
      key: const ValueKey('map-route-options'),
      children: [
        AppDisclosure(
          title: l10n.mapRouteOptions,
          subtitle: accessLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  AppChip.filter(
                    label: l10n.mapRouteWalking,
                    selected: !options.stepFree && !options.wheelchair,
                    onTap: _access,
                  ),
                  AppChip.filter(
                    label: l10n.mapRouteStepFree,
                    selected: options.stepFree && !options.wheelchair,
                    onTap: () => _access(
                      stepFree: !(options.stepFree && !options.wheelchair),
                    ),
                  ),
                  AppChip.filter(
                    label: l10n.mapRouteWheelchair,
                    selected: options.wheelchair,
                    onTap: () => _access(
                      stepFree: !options.wheelchair,
                      wheelchair: !options.wheelchair,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                options.wheelchair
                    ? l10n.mapRouteWheelchairHint
                    : options.stepFree
                    ? l10n.mapRouteStepFreeHint
                    : l10n.mapRouteWalkingHint,
                style: AppText.caption.copyWith(color: context.colors.muted),
              ),
              if (canEstimateDuration) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final metric in IndoorRouteMetric.values)
                      AppChip.filter(
                        label: metric == IndoorRouteMetric.duration
                            ? l10n.mapRouteFaster
                            : l10n.mapRouteShorter,
                        selected: options.metric == metric,
                        onTap: () => onChanged(
                          IndoorRouteOptions(
                            stepFree: options.stepFree,
                            wheelchair: options.wheelchair,
                            metric: metric,
                            closedEdgeIds: options.closedEdgeIds,
                            closedNodeIds: options.closedNodeIds,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
