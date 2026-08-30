import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_drag_data.dart';
import 'package:rtu_mirea_app/services/view/services_drag_feedback.dart';
import 'package:rtu_mirea_app/services/view/services_grid_tile.dart';

class ServicesDraggableTile extends StatelessWidget {
  const ServicesDraggableTile({
    required this.service,
    required this.groupKey,
    required this.draggable,
    required this.editMode,
    required this.isFavorite,
    required this.onTap,
    required this.onMovePrevious,
    required this.onMoveNext,
    required this.onMoveService,
    super.key,
  });

  final ServiceModel service;
  final String groupKey;
  final bool draggable;
  final bool editMode;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onMovePrevious;
  final VoidCallback? onMoveNext;
  final void Function(String id, String toKey, {String? beforeId})
  onMoveService;

  @override
  Widget build(BuildContext context) {
    final tile = ServicesGridTile(
      service: service,
      editMode: editMode,
      isFavorite: isFavorite,
      onTap: onTap,
    );
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    if (!draggable || id == null) return tile;

    return DragTarget<ServicesDragData>(
      onWillAcceptWithDetails: (details) => details.data.id != id,
      onAcceptWithDetails: (details) =>
          onMoveService(details.data.id, groupKey, beforeId: id),
      builder: (context, candidate, rejected) {
        final actions = <CustomSemanticsAction, VoidCallback>{};
        final movePrevious = onMovePrevious;
        final moveNext = onMoveNext;
        if (movePrevious != null) {
          actions[CustomSemanticsAction(
                label: context.l10n.servicesMoveEarlier,
              )] =
              movePrevious;
        }
        if (moveNext != null) {
          actions[CustomSemanticsAction(
                label: context.l10n.servicesMoveLater,
              )] =
              moveNext;
        }
        final draggableTile = LongPressDraggable(
          data: ServicesDragData(id),
          feedback: ServicesDragFeedback(service: service),
          childWhenDragging: Opacity(opacity: 0.25, child: tile),
          child: tile,
        );
        final child = candidate.isEmpty
            ? draggableTile
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  draggableTile,
                  PositionedDirectional(
                    start: -7,
                    top: 4,
                    bottom: 22,
                    child: SizedBox(
                      width: NinjaMetrics.lineWidth * 2,
                      child: ColoredBox(color: context.ninja.ink),
                    ),
                  ),
                ],
              );
        return Semantics(
          customSemanticsActions: actions,
          child: child,
        );
      },
    );
  }
}
