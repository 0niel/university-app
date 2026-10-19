import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_route_destinations.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRouteNodePicker extends StatefulWidget {
  const MapRouteNodePicker({
    required this.nodes,
    required this.campus,
    required this.endpoint,
    this.opposite,
    this.selected,
    this.restricted = false,
    super.key,
  });

  final List<IndoorNavigationNode> nodes;
  final CampusMapData campus;
  final MapRouteEndpoint endpoint;
  final IndoorNavigationNode? opposite;
  final IndoorNavigationNode? selected;
  final bool restricted;

  @override
  State<MapRouteNodePicker> createState() => _MapRouteNodePickerState();
}

class _MapRouteNodePickerState extends State<MapRouteNodePicker> {
  final _query = TextEditingController();
  late final List<IndoorNavigationNode> _nodes = [...widget.nodes]
    ..sort((a, b) {
      final firstFloor = widget.campus.floorForId(a.floorId);
      final secondFloor = widget.campus.floorForId(b.floorId);
      final floorOrder = (firstFloor?.floor.number ?? 0).compareTo(
        secondFloor?.floor.number ?? 0,
      );
      if (floorOrder != 0) return floorOrder;
      final floorLabelOrder = compareNatural(
        firstFloor?.label ?? a.floorId,
        secondFloor?.label ?? b.floorId,
      );
      if (floorLabelOrder != 0) return floorLabelOrder;
      final roomOrder = compareNatural(
        roomKey(mapRouteNodeLabel(a, widget.campus, context.l10n)),
        roomKey(mapRouteNodeLabel(b, widget.campus, context.l10n)),
      );
      return roomOrder == 0 ? a.id.compareTo(b.id) : roomOrder;
    });
  String? _floorId;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  String _floorLabel(String id) {
    final floor = widget.campus.floorForId(id);
    return floor?.label.isNotEmpty == true
        ? floor!.label
        : floor == null
        ? context.l10n.mapRouteUnknownFloor
        : context.l10n.mapFloorNumber(floor.floor.number);
  }

  bool _selected(IndoorNavigationNode node) {
    final selected = widget.selected;
    if (selected == null) return false;
    if (selected.id == node.id) return true;
    final place = widget.campus.placeForId(node.roomId ?? '');
    final selectedPlace = widget.campus.placeForId(selected.roomId ?? '');
    return place != null && place.id == selectedPlace?.id;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _query,
    builder: (context, _) => _content(context),
  );

  Widget _content(BuildContext context) {
    final l10n = context.l10n;
    final query = roomKey(_query.text);
    final floors = _nodes.map((node) => node.floorId).toSet();
    final nodes = _nodes.where((node) {
      if (_floorId != null && _floorId != node.floorId) return false;
      return query.isEmpty ||
          roomKey(mapRouteNodeLabel(node, widget.campus, l10n)).contains(query);
    }).toList();
    final opposite = widget.opposite;
    return LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final double availableHeight = math.max(
          0,
          media.size.height -
              media.viewInsets.bottom -
              media.viewPadding.top -
              80,
        );
        return SizedBox(
          height: math.min(constraints.maxHeight, availableHeight),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.endpoint == MapRouteEndpoint.start
                                ? l10n.mapRoutePickStart
                                : l10n.mapRoutePickDestination,
                            style: AppText.sectionSmall,
                          ),
                        ),
                        AppSheetCloseButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    if (opposite != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        widget.endpoint == MapRouteEndpoint.start
                            ? l10n.mapRouteToLabel(
                                mapRouteNodeLabel(
                                  opposite,
                                  widget.campus,
                                  l10n,
                                ),
                              )
                            : l10n.mapRouteFromLabel(
                                mapRouteNodeLabel(
                                  opposite,
                                  widget.campus,
                                  l10n,
                                ),
                              ),
                        style: AppText.caption.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppSearchField(
                      controller: _query,
                      hintText: l10n.mapRoutePlaceSearchHint,
                    ),
                    if (floors.length > 1) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          AppChip.filter(
                            label: l10n.mapRouteAllFloors,
                            selected: _floorId == null,
                            onTap: () => setState(() => _floorId = null),
                          ),
                          for (final floor in floors)
                            AppChip.filter(
                              label: _floorLabel(floor),
                              selected: _floorId == floor,
                              onTap: () => setState(() => _floorId = floor),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      widget.restricted
                          ? l10n.mapRouteRestrictedPointsHint
                          : opposite == null
                          ? l10n.mapRouteVerifiedPointsHint
                          : l10n.mapRouteReachablePointsHint,
                      style: AppText.caption.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ),
              ),
              if (nodes.isEmpty)
                SliverToBoxAdapter(
                  child: AppEmptyState.compact(
                    title: query.isEmpty && _floorId == null
                        ? l10n.mapRouteNoPoints
                        : l10n.searchNoResults,
                    subtitle: query.isNotEmpty || _floorId != null
                        ? l10n.mapRouteTryQueryOrFloor
                        : widget.restricted
                        ? l10n.mapRouteTryRequirementsOrPoint
                        : l10n.mapRouteTryPointOrPassages,
                  ),
                )
              else
                SliverList.builder(
                  itemCount: nodes.length,
                  itemBuilder: (context, index) {
                    final node = nodes[index];
                    final selected = _selected(node);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0 ||
                            nodes.elementAtOrNull(index - 1)?.floorId !=
                                node.floorId)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.md,
                              AppSpacing.md,
                              AppSpacing.xxs,
                            ),
                            child: Text(
                              _floorLabel(node.floorId),
                              style: AppText.captionStrong,
                            ),
                          ),
                        Semantics(
                          selected: selected,
                          child: AppListRow(
                            key: ValueKey('map-route-point-${node.id}'),
                            title: mapRouteNodeLabel(node, widget.campus, l10n),
                            titleMaxLines: null,
                            subtitle: selected
                                ? l10n.mapRoutePointSelected
                                : null,
                            leading: AppIconTile(
                              child: Icon(
                                selected
                                    ? Icons.check_rounded
                                    : Icons.place_outlined,
                                size: AppIconSize.sm,
                              ),
                            ),
                            showChevron: false,
                            onTap: () => Navigator.of(context).pop(node),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
