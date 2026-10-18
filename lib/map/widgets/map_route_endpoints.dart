import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_route_destinations.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRouteEndpoints extends StatelessWidget {
  const MapRouteEndpoints({
    required this.campus,
    required this.start,
    required this.destination,
    this.onPick,
    this.onSwap,
    this.onReset,
    super.key,
  });

  final CampusMapData campus;
  final IndoorNavigationNode? start;
  final IndoorNavigationNode? destination;
  final ValueChanged<MapRouteEndpoint>? onPick;
  final VoidCallback? onSwap;
  final VoidCallback? onReset;

  Widget _endpoint(BuildContext context, MapRouteEndpoint endpoint) {
    final l10n = context.l10n;
    final isStart = endpoint == MapRouteEndpoint.start;
    final node = isStart ? start : destination;
    final floor = campus.floorForId(node?.floorId ?? '');
    return AppListRow(
      key: ValueKey('map-route-${endpoint.name}'),
      title: node == null
          ? isStart
                ? l10n.mapRouteChooseStart
                : l10n.mapRouteChooseDestination
          : isStart
          ? l10n.mapRouteFromLabel(mapRouteNodeLabel(node, campus, l10n))
          : l10n.mapRouteToLabel(mapRouteNodeLabel(node, campus, l10n)),
      titleMaxLines: null,
      subtitle: node == null
          ? isStart
                ? l10n.mapRouteCurrentPointHint
                : l10n.mapRoutePlaceSearchHint
          : floor?.label.isNotEmpty == true
          ? floor!.label
          : floor == null
          ? null
          : l10n.mapFloorNumber(floor.floor.number),
      leading: AppIconTile(
        child: Icon(
          isStart ? Icons.trip_origin_rounded : Icons.flag_rounded,
          size: AppIconSize.sm,
        ),
      ),
      dense: true,
      showChevron: false,
      onTap: onPick == null ? null : () => onPick!(endpoint),
    );
  }

  @override
  Widget build(BuildContext context) => AppListGroup(
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _endpoint(context, MapRouteEndpoint.start),
                _endpoint(context, MapRouteEndpoint.destination),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  tooltip: context.l10n.mapRouteSwapPoints,
                  shape: AppIconButtonShape.circle,
                  size: AppIconButtonSize.compact,
                  onPressed: onSwap,
                  icon: const Icon(Icons.swap_vert_rounded),
                ),
                AppIconButton(
                  tooltip: context.l10n.mapRouteResetPoints,
                  shape: AppIconButtonShape.circle,
                  size: AppIconButtonSize.compact,
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
