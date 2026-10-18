import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/services/map_route_destinations.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_endpoints.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_node_picker.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_options.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_preview.dart';

export 'package:rtu_mirea_app/map/widgets/map_route_presentation.dart';

class MapRouteSheet extends StatefulWidget {
  const MapRouteSheet({
    required this.campus,
    required this.onApply,
    required this.onContribute,
    this.onClose,
    this.startRoomId,
    this.destinationRoomId,
    this.navigationGraph,
    super.key,
  });

  final CampusMapData campus;
  final String? startRoomId;
  final String? destinationRoomId;
  final IndoorNavigationGraph? navigationGraph;
  final ValueChanged<IndoorRoute> onApply;
  final VoidCallback onContribute;
  final VoidCallback? onClose;

  @override
  State<MapRouteSheet> createState() => _MapRouteSheetState();
}

enum _RouteDataIssue {
  movedPlace,
  unverifiedPassages,
  unmappedDestination,
  unmappedStart,
  invalidPassages,
}

class _MapRouteSheetState extends State<MapRouteSheet> {
  IndoorNavigationGraph? _graph;
  MapRouteDestinations? _destinations;
  late final IndoorRoutePlanner _planner;
  IndoorNavigationNode? _start;
  IndoorNavigationNode? _destination;
  IndoorRouteResult? _result;
  IndoorRouteOptions _options = const IndoorRouteOptions();
  _RouteDataIssue? _error;

  @override
  void initState() {
    super.initState();
    try {
      final graph =
          widget.navigationGraph ??
          IndoorNavigationGraph.fromJson(widget.campus.graph);
      _graph = graph;
      _planner = IndoorRoutePlanner(graph);
      final destinations = MapRouteDestinations(
        campus: widget.campus,
        planner: _planner,
      );
      _destinations = destinations;
      _options = IndoorRouteOptions(
        metric: graph.hasCompleteDuration
            ? IndoorRouteMetric.duration
            : IndoorRouteMetric.distance,
      );
      _start = destinations.nodeForRoom(widget.startRoomId);
      _destination = destinations.nodeForRoom(widget.destinationRoomId);
      if (_needsNavigationReview(widget.startRoomId) ||
          _needsNavigationReview(widget.destinationRoomId)) {
        _error = _RouteDataIssue.movedPlace;
      } else if (graph.nodes.isEmpty || graph.edges.isEmpty) {
        _error = _RouteDataIssue.unverifiedPassages;
      } else if (widget.destinationRoomId != null && _destination == null) {
        _error = _RouteDataIssue.unmappedDestination;
      } else if (widget.startRoomId != null && _start == null) {
        _error = _RouteDataIssue.unmappedStart;
      }
      _calculate();
    } on FormatException {
      _error = _RouteDataIssue.invalidPassages;
    }
  }

  bool _needsNavigationReview(String? roomId) =>
      widget.campus.placeForId(roomId ?? '')?.raw['navigation_needs_review'] ==
      true;

  void _calculate() {
    final destinations = _destinations;
    final start = _start;
    final destination = _destination;
    _result = destinations == null || start == null || destination == null
        ? null
        : _planner.findRouteBetween(
            startNodeIds: destinations.nodeIdsFor(start),
            destinationNodeIds: destinations.nodeIdsFor(destination),
            options: _options,
          );
  }

  Future<void> _pick(MapRouteEndpoint endpoint) async {
    final destinations = _destinations;
    if (destinations == null) return;
    final pickingStart = endpoint == MapRouteEndpoint.start;
    final opposite = pickingStart ? _destination : _start;
    final node = await showAppSheet<IndoorNavigationNode>(
      context,
      scrollable: false,
      showGrabber: false,
      child: MapRouteNodePicker(
        nodes: destinations.candidates(
          endpoint: endpoint,
          opposite: opposite,
          options: _options,
        ),
        campus: widget.campus,
        endpoint: endpoint,
        opposite: opposite,
        selected: pickingStart ? _start : _destination,
        restricted: _options.stepFree || _options.wheelchair,
      ),
    );
    if (node == null || !mounted) return;
    setState(() {
      if (pickingStart) {
        _start = node;
      } else {
        _destination = node;
      }
      _error = null;
      _calculate();
    });
  }

  void _changeOptions(IndoorRouteOptions options) {
    setState(() {
      _options = options;
      _calculate();
    });
  }

  void _swap() {
    setState(() {
      final previous = _start;
      _start = _destination;
      _destination = previous;
      _calculate();
    });
  }

  void _resetEndpoints() {
    setState(() {
      _start = null;
      _destination = null;
      _result = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorMessage = switch (_error) {
      _RouteDataIssue.movedPlace => l10n.mapRoutePlaceNeedsReview,
      _RouteDataIssue.unverifiedPassages => l10n.mapRouteUnverifiedPassages,
      _RouteDataIssue.unmappedDestination => l10n.mapRouteDestinationUnmapped,
      _RouteDataIssue.unmappedStart => l10n.mapRouteStartUnmapped,
      _RouteDataIssue.invalidPassages => l10n.mapRouteInvalidPassages,
      null => null,
    };
    final route = _result?.route;
    final ready = _destinations != null && (_graph?.edges.isNotEmpty ?? false);
    final restricted = _options.stepFree || _options.wheelchair;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.lessonDetailsRoute, style: AppText.sectionLarge),
            ),
            if (widget.onClose != null)
              AppSheetCloseButton(onTap: widget.onClose),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(widget.campus.campus.displayName, style: AppText.subtext),
        const SizedBox(height: AppSpacing.lg),
        if (errorMessage case final error?) ...[
          AppBanner(message: error),
          const SizedBox(height: AppSpacing.md),
        ],
        MapRouteEndpoints(
          campus: widget.campus,
          start: _start,
          destination: _destination,
          onPick: ready ? (endpoint) => unawaited(_pick(endpoint)) : null,
          onSwap: _start == null && _destination == null ? null : _swap,
          onReset: _start == null && _destination == null
              ? null
              : _resetEndpoints,
        ),
        const SizedBox(height: AppSpacing.md),
        if (ready) ...[
          MapRouteOptions(
            options: _options,
            canEstimateDuration: _graph!.hasCompleteDuration,
            onChanged: _changeOptions,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (route != null)
          MapRoutePreview(
            route: route,
            campus: widget.campus,
            onApply: () {
              Navigator.of(context).pop();
              widget.onApply(route);
            },
          )
        else if (_result != null) ...[
          AppBanner(
            message: restricted
                ? l10n.mapRouteRestrictedUnavailable
                : l10n.mapRouteUnavailable,
          ),
          if (restricted)
            AppButton.text(
              label: l10n.mapRouteResetRestrictions,
              onPressed: () => _changeOptions(
                IndoorRouteOptions(metric: _options.metric),
              ),
            ),
        ] else if (ready)
          Text(
            _start == null
                ? l10n.mapRouteChooseStartHint
                : l10n.mapRouteChooseDestinationHint,
            style: AppText.caption.copyWith(color: context.colors.muted),
          ),
        const SizedBox(height: AppSpacing.md),
        AppButton.text(
          label: l10n.mapRouteCorrectPassages,
          onPressed: () {
            Navigator.of(context).pop();
            widget.onContribute();
          },
        ),
      ],
    );
  }
}
