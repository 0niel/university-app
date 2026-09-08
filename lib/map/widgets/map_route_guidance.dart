import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRouteGuidance extends StatelessWidget {
  const MapRouteGuidance({
    required this.campus,
    required this.route,
    required this.stepIndex,
    required this.onClose,
    this.onNext,
    this.onPrevious,
    super.key,
  }) : assert(stepIndex >= 0, 'Step index must be nonnegative');

  final CampusMapData campus;
  final IndoorRoute route;
  final int stepIndex;
  final VoidCallback onClose;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  @override
  Widget build(BuildContext context) {
    assert(
      stepIndex < route.instructions.length,
      'Step index must belong to the route',
    );
    final instruction = route.instructions[stepIndex];
    final isLast = stepIndex == route.instructions.length - 1;
    final colors = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconTile(
                background: colors.tint,
                child: Icon(
                  mapRouteInstructionIcon(instruction.maneuver),
                  color: colors.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Semantics(
                  liveRegion: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLast
                            ? 'Конец маршрута'
                            : mapRouteInstructionLabel(instruction, campus),
                        style: AppText.bodyStrong,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        mapRouteInstructionContext(instruction, campus),
                        style: AppText.caption.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              AppIconButton(
                tooltip: 'Завершить маршрут',
                shape: AppIconButtonShape.circle,
                size: AppIconButtonSize.compact,
                tone: AppIconButtonTone.surface,
                onPressed: onClose,
                icon: const AppLineIconWidget(AppLineIcon.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Шаг ${stepIndex + 1} из '
                  '${route.instructions.length} · вручную',
                  style: AppText.caption.copyWith(color: colors.muted),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (stepIndex > 0) ...[
                AppIconButton(
                  tooltip: 'Предыдущий шаг',
                  shape: AppIconButtonShape.circle,
                  size: AppIconButtonSize.compact,
                  tone: AppIconButtonTone.surface,
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              AppIconButton(
                tooltip: isLast
                    ? 'Закончить просмотр маршрута'
                    : 'Следующий шаг',
                shape: AppIconButtonShape.circle,
                size: AppIconButtonSize.compact,
                tone: AppIconButtonTone.primary,
                onPressed: onNext,
                icon: Icon(
                  isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
