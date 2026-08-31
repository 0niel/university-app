import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/services/view/services_drag_data.dart';
import 'package:rtu_mirea_app/services/view/services_draggable_tile.dart';

class ServicesDropGroup extends StatelessWidget {
  const ServicesDropGroup({
    required this.groupKey,
    required this.services,
    required this.draggable,
    required this.editMode,
    required this.onFavoriteCheck,
    required this.onServiceTap,
    required this.onMoveService,
    super.key,
  });

  final String groupKey;
  final List<ServiceModel> services;
  final bool draggable;
  final bool editMode;
  final bool Function(ServiceModel) onFavoriteCheck;
  final ValueChanged<ServiceModel> onServiceTap;
  final void Function(String id, String toKey, {String? beforeId})
  onMoveService;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final minimumCellWidth = textScale >= 1.75
            ? 108.0
            : textScale >= 1.3
            ? 88.0
            : 74.0;
        final columns = (constraints.maxWidth / minimumCellWidth).floor().clamp(
          2,
          5,
        );
        final grid = LayoutGrid(
          autoPlacement: AutoPlacement.rowDense,
          columnSizes: List.filled(columns, 1.fr),
          rowSizes: List.generate(
            (services.length / columns).ceil(),
            (_) => auto,
          ),
          columnGap: 10,
          rowGap: textScale >= 1.5 ? 24 : 18,
          children: [
            for (var index = 0; index < services.length; index++)
              _serviceTile(index),
          ],
        );
        if (!draggable) return grid;
        final colors = context.ninja;
        final reduceMotion =
            MediaQuery.disableAnimationsOf(context) ||
            MediaQuery.accessibleNavigationOf(context);
        return DragTarget<ServicesDragData>(
          onWillAcceptWithDetails: (_) => true,
          onAcceptWithDetails: (details) =>
              onMoveService(details.data.id, groupKey),
          builder: (context, candidate, rejected) => AnimatedContainer(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: candidate.isEmpty ? Colors.transparent : colors.surfaceAlt,
              borderRadius: BorderRadius.circular(NinjaRadius.card),
            ),
            child: grid,
          ),
        );
      },
    );
  }

  Widget _serviceTile(int index) {
    final service = services.elementAtOrNull(index);
    if (service == null) return const SizedBox.shrink();
    final id = FavoriteServicesRepository.idOf(
      routePath: service.routePath,
      url: service.url,
    );
    final previous = index == 0 ? null : services.elementAtOrNull(index - 1);
    final afterNext = services.elementAtOrNull(index + 2);
    return ServicesDraggableTile(
      service: service,
      groupKey: groupKey,
      draggable: draggable,
      editMode: editMode,
      isFavorite: onFavoriteCheck(service),
      onTap: () => onServiceTap(service),
      onMovePrevious: id == null || previous == null
          ? null
          : () {
              final beforeId = FavoriteServicesRepository.idOf(
                routePath: previous.routePath,
                url: previous.url,
              );
              if (beforeId != null) {
                onMoveService(id, groupKey, beforeId: beforeId);
              }
            },
      onMoveNext: id == null || index == services.length - 1
          ? null
          : () {
              final beforeId = afterNext == null
                  ? null
                  : FavoriteServicesRepository.idOf(
                      routePath: afterNext.routePath,
                      url: afterNext.url,
                    );
              onMoveService(id, groupKey, beforeId: beforeId);
            },
      onMoveService: onMoveService,
    );
  }
}
