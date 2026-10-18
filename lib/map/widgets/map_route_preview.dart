import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRoutePreview extends StatelessWidget {
  const MapRoutePreview({
    required this.route,
    required this.campus,
    required this.onApply,
    super.key,
  });

  final IndoorRoute route;
  final CampusMapData campus;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    if (route.legs.isEmpty) {
      return AppCard(
        tinted: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Вы уже здесь', style: AppText.bodyStrong),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Начало и назначение совпадают. '
              'Выберите другую точку, чтобы построить маршрут.',
              style: AppText.caption,
            ),
          ],
        ),
      );
    }
    final metrics = [
      if (route.distanceMeters case final distance?) '${distance.round()} м',
      if (route.durationSeconds case final duration?)
        duration == 0
            ? '<1 мин'
            : '≈ ${(duration / 60).ceil().clamp(1, 999)} мин',
      '${route.floorIds.length} эт.',
    ].join(' · ');
    final expanded =
        MediaQuery.sizeOf(context).height >= 560 &&
        MediaQuery.textScalerOf(context).scale(16) < 24;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCard(
          tinted: true,
          child: Row(
            children: [
              const Icon(Icons.route_rounded, size: AppIconSize.md),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Маршрут готов', style: AppText.bodyStrong),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(metrics, style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton.primary(
          label: 'Показать путь',
          expanded: true,
          onPressed: onApply,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Начало задано вручную. Шаги переключаете вы.',
          textAlign: TextAlign.center,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
        if (!route.hasCompleteDistance || !route.hasCompleteDuration) ...[
          const SizedBox(height: AppSpacing.md),
          const AppBanner(
            message:
                'Для части маршрута пока нет оценки расстояния или времени.',
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppListGroup(
          children: [
            AppDisclosure(
              title: 'По шагам',
              subtitle: 'Шаги: ${route.instructions.length}',
              initiallyExpanded: expanded,
              contentPadding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final instruction in route.instructions)
                    AppListRow(
                      title: mapRouteInstructionLabel(instruction, campus),
                      titleMaxLines: null,
                      subtitle: mapRouteInstructionContext(instruction, campus),
                      leading: AppIconTile(
                        child: Icon(
                          mapRouteInstructionIcon(instruction.maneuver),
                          size: AppIconSize.sm,
                        ),
                      ),
                      showChevron: false,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
