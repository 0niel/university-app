import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

class MapPanelHeader extends StatelessWidget {
  const MapPanelHeader({
    required this.controller,
    required this.collapsedExtent,
    required this.expandedExtent,
    required this.campus,
    required this.floor,
    required this.onTap,
    super.key,
  });

  final DraggableScrollableController controller;
  final double collapsedExtent;
  final double expandedExtent;
  final CampusModel campus;
  final FloorModel floor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final floorLabel = l10n.mapFloorNumber(floor.number);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final current = controller.isAttached
            ? controller.size
            : collapsedExtent;
        final range = math.max(expandedExtent - collapsedExtent, .01);
        final progress = ((current - collapsedExtent) / range).clamp(0.0, 1.0);
        return Semantics(
          button: true,
          expanded: progress > .5,
          label: '${campus.displayName}, $floorLabel',
          hint: l10n.mapChangeBuildingHint,
          child: AppPressable(
            onTap: onTap,
            child: Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                8,
                NinjaMetrics.screenPadding,
                0,
              ),
              child: Column(
                children: [
                  Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.line,
                      borderRadius: .circular(NinjaRadius.pill),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const .all(14),
                    decoration: BoxDecoration(
                      color: colors.accentSoft,
                      borderRadius: .circular(NinjaRadius.card),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: NinjaMetrics.minTouchTarget,
                          height: NinjaMetrics.minTouchTarget,
                          alignment: .center,
                          decoration: BoxDecoration(
                            color: colors.onAccentSoft.withValues(alpha: .12),
                            shape: .circle,
                          ),
                          child: AppLineIconWidget(
                            .school,
                            size: 21,
                            color: colors.onAccentSoft,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                campus.displayName,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: NinjaText.headline.copyWith(
                                  color: colors.onAccentSoft,
                                ),
                              ),
                              const SizedBox(height: 3),
                              NinjaStateSwitcher(
                                alignment: Alignment.centerLeft,
                                duration: NinjaMotion.fast,
                                child: Text(
                                  floorLabel,
                                  key: ValueKey(floor.id),
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: NinjaText.subtext.copyWith(
                                    color: colors.onAccentSoftMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Transform.rotate(
                          angle: progress * math.pi,
                          child: AppLineIconWidget(
                            .chevronU,
                            size: 19,
                            color: colors.onAccentSoftMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
