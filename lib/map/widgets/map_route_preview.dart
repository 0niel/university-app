import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
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
    final l10n = context.l10n;
    if (route.legs.isEmpty) {
      return AppCard(
        tinted: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.mapRouteAlreadyHere, style: AppText.bodyStrong),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.mapRouteSamePointHint,
              style: AppText.caption,
            ),
          ],
        ),
      );
    }
    final metrics = [
      if (route.durationSeconds case final duration?)
        duration == 0
            ? '<${l10n.minutesShort(1)}'
            : '≈ ${l10n.minutesShort((duration / 60).ceil().clamp(1, 999))}',
      l10n.mapFloorsCount(route.floorIds.length),
    ].join(' · ');
    final expanded =
        MediaQuery.heightOf(context) >= 560 &&
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
                    Text(l10n.mapRouteReady, style: AppText.bodyStrong),
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
          label: l10n.mapRouteShowPath,
          expanded: true,
          onPressed: onApply,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.mapRouteManualStepsHint,
          textAlign: TextAlign.center,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
        if (!route.hasCompleteDuration) ...[
          const SizedBox(height: AppSpacing.md),
          AppBanner(message: l10n.mapRouteIncompleteDuration),
        ],
        const SizedBox(height: AppSpacing.md),
        AppListGroup(
          children: [
            AppDisclosure(
              title: l10n.mapRouteSteps,
              subtitle: l10n.mapRouteStepsCount(route.instructions.length),
              initiallyExpanded: expanded,
              contentPadding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final instruction in route.instructions)
                    AppListRow(
                      title: mapRouteInstructionLabel(
                        instruction,
                        campus,
                        l10n,
                      ),
                      titleMaxLines: null,
                      subtitle: mapRouteInstructionContext(
                        instruction,
                        campus,
                        l10n,
                      ),
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
