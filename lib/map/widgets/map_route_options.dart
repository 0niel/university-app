import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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
    final accessLabel = options.wheelchair
        ? 'На коляске'
        : options.stepFree
        ? 'Без лестниц'
        : 'Пешком';
    return AppListGroup(
      key: const ValueKey('map-route-options'),
      children: [
        AppDisclosure(
          title: 'Параметры маршрута',
          subtitle: accessLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  AppChip.filter(
                    label: 'Пешком',
                    selected: !options.stepFree && !options.wheelchair,
                    onTap: _access,
                  ),
                  AppChip.filter(
                    label: 'Без лестниц',
                    selected: options.stepFree && !options.wheelchair,
                    onTap: () => _access(
                      stepFree: !(options.stepFree && !options.wheelchair),
                    ),
                  ),
                  AppChip.filter(
                    label: 'На коляске',
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
                    ? 'Только проходы с подтверждённой '
                          'доступностью для коляски.'
                    : options.stepFree
                    ? 'Лестницы и эскалаторы исключены.'
                    : 'Можно использовать лестницы, лифты и другие проходы.',
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
                            ? 'Быстрее'
                            : 'Короче',
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
