import 'dart:async';
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/navigation/floor_georeference.dart';
import 'package:rtu_mirea_app/map/widgets/map_cartographic_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_svg_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class GeographicFloorPlan {
  const GeographicFloorPlan({
    required this.svg,
    required this.size,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    this.rooms = const [],
    this.places = const [],
    this.syntheticRoomIds = const {},
    this.georeference,
  });

  final String svg;
  final Size size;
  final LatLng topLeft;
  final LatLng topRight;
  final LatLng bottomLeft;
  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final Set<String> syntheticRoomIds;
  final MapGeoreferenceData? georeference;

  String get alignmentNote => switch (georeference?.status) {
    'community' => 'Привязка сообщества',
    'needs_review' => 'Привязка ожидает проверки',
    _ => 'Привязка приблизительная',
  };

  LatLngBounds get geographicBounds {
    final reference = FloorGeoreference([
      FloorGeoAnchor(
        x: 0,
        y: 0,
        latitude: topLeft.latitude,
        longitude: topLeft.longitude,
      ),
      FloorGeoAnchor(
        x: size.width,
        y: 0,
        latitude: topRight.latitude,
        longitude: topRight.longitude,
      ),
      FloorGeoAnchor(
        x: 0,
        y: size.height,
        latitude: bottomLeft.latitude,
        longitude: bottomLeft.longitude,
      ),
    ]);
    final visibleRooms = rooms.where((room) {
      final center = room.path.getBounds().center;
      return georeference?.isReliableAt(center.dx, center.dy) ?? true;
    }).toList();
    final bounds = visibleRooms.isEmpty
        ? Offset.zero & size
        : visibleRooms
              .map((room) => room.path.getBounds())
              .reduce(
                (bounds, next) => bounds.expandToInclude(next),
              );
    return LatLngBounds.fromPoints([
      for (final point in [
        bounds.topLeft,
        bounds.topRight,
        bounds.bottomLeft,
        bounds.bottomRight,
      ])
        (() {
          final location = reference.pixelToGeographic(point.dx, point.dy);
          return LatLng(location.latitude, location.longitude);
        })(),
    ]);
  }
}

class GeographicMapPlace {
  const GeographicMapPlace({
    required this.label,
    required this.position,
    required this.onTap,
  });

  final String label;
  final LatLng position;
  final VoidCallback onTap;
}

class MapGeographicView extends StatefulWidget {
  const MapGeographicView({
    required this.campusName,
    required this.center,
    this.floorPlan,
    this.places = const [],
    this.route = const [],
    super.key,
  });

  final String campusName;
  final LatLng center;
  final GeographicFloorPlan? floorPlan;
  final List<GeographicMapPlace> places;
  final List<List<LatLng>> route;

  @override
  State<MapGeographicView> createState() => _MapGeographicViewState();
}

class _MapGeographicViewState extends State<MapGeographicView> {
  final _controller = MapController();
  late final NetworkTileProvider _tiles = AppMapTiles.createTileProvider();
  double _opacity = .85;

  @override
  void dispose() {
    _controller.dispose();
    unawaited(_tiles.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.canvas,
    body: Column(
      children: [
        AppInnerHeader(
          title: '${widget.campusName} · на карте',
          titleStyle: AppText.title,
          onBack: () => Navigator.pop(context),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _controller,
                        options: MapOptions(
                          initialCenter: widget.center,
                          initialZoom: widget.floorPlan == null ? 16 : 18,
                          initialCameraFit: widget.floorPlan == null
                              ? null
                              : CameraFit.bounds(
                                  bounds: widget.floorPlan!.geographicBounds,
                                  padding: const EdgeInsets.all(36),
                                  maxZoom: 19,
                                ),
                          maxZoom: 22,
                        ),
                        children: [
                          AppMapTiles.tileLayer(context, tileProvider: _tiles),
                          if (widget.floorPlan case final plan?)
                            _VectorFloorLayer(plan: plan, opacity: _opacity),
                          PolylineLayer(
                            polylines: [
                              for (final segment in widget.route)
                                if (segment.length > 1)
                                  Polyline(
                                    points: segment,
                                    color: context.colors.accent,
                                    strokeWidth: 5,
                                    borderColor: context.colors.surface,
                                    borderStrokeWidth: 2,
                                  ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              if (widget.floorPlan == null)
                                Marker(
                                  point: widget.center,
                                  width: 44,
                                  height: 44,
                                  child: Tooltip(
                                    message: widget.campusName,
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 36,
                                      color: context.colors.accent,
                                    ),
                                  ),
                                ),
                              for (final place in widget.places)
                                Marker(
                                  point: place.position,
                                  width: 44,
                                  height: 44,
                                  child: AppIconButton(
                                    tooltip: place.label,
                                    onPressed: place.onTap,
                                    icon: const Icon(Icons.place_outlined),
                                    tone: AppIconButtonTone.surface,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: AppIconButton(
                          icon: const Icon(Icons.center_focus_strong_rounded),
                          tooltip: 'Показать кампус',
                          tone: AppIconButtonTone.surface,
                          shape: AppIconButtonShape.circle,
                          onPressed: () {
                            final plan = widget.floorPlan;
                            if (plan == null) {
                              _controller.move(widget.center, 18);
                            } else {
                              _controller.fitCamera(
                                CameraFit.bounds(
                                  bounds: plan.geographicBounds,
                                  padding: const EdgeInsets.all(36),
                                  maxZoom: 19,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * .45,
                  ),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (widget.floorPlan != null) ...[
                              if (widget.floorPlan!.georeference
                                  case final quality?)
                                AppDisclosure(
                                  title: widget.floorPlan!.alignmentNote,
                                  contentPadding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (quality.summary.isNotEmpty)
                                        Text(
                                          quality.summary,
                                          style: AppText.body,
                                        ),
                                      for (final limitation
                                          in quality.limitations)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            limitation,
                                            style: AppText.caption.copyWith(
                                              color: context.colors.muted,
                                            ),
                                          ),
                                        ),
                                      Wrap(
                                        spacing: 8,
                                        children: [
                                          for (final source in quality.sources)
                                            if (source.link case final link?)
                                              AppButton.text(
                                                label: source.label,
                                                size: AppButtonSize.small,
                                                onPressed: () =>
                                                    unawaited(launchUrl(link)),
                                              ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Text(
                                  widget.floorPlan!.alignmentNote,
                                  style: AppText.caption.copyWith(
                                    color: context.colors.muted,
                                  ),
                                ),
                              Text('Прозрачность плана', style: AppText.label),
                              Slider(
                                value: _opacity,
                                min: .15,
                                label: '${(_opacity * 100).round()}%',
                                onChanged: (value) =>
                                    setState(() => _opacity = value),
                              ),
                            ] else
                              const AppBanner(
                                message:
                                    'План пока не привязан '
                                    'к координатам здания. '
                                    'Точное наложение появится после проверки '
                                    'опорных точек.',
                              ),
                            Wrap(
                              spacing: 8,
                              children: [
                                AppButton.text(
                                  label: AppMapTiles.attribution,
                                  size: AppButtonSize.small,
                                  onPressed: () => unawaited(
                                    launchUrl(
                                      Uri.parse(
                                        'https://www.openstreetmap.org/copyright',
                                      ),
                                    ),
                                  ),
                                ),
                                AppButton.text(
                                  label: 'Планы: Пульс МИРЭА',
                                  size: AppButtonSize.small,
                                  onPressed: () => unawaited(
                                    launchUrl(
                                      Uri.parse(
                                        'https://pulse.mirea.ru/services/maps',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _VectorFloorLayer extends StatelessWidget {
  const _VectorFloorLayer({required this.plan, required this.opacity});

  final GeographicFloorPlan plan;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final origin = camera.latLngToScreenOffset(plan.topLeft);
    final right = camera.latLngToScreenOffset(plan.topRight) - origin;
    final down = camera.latLngToScreenOffset(plan.bottomLeft) - origin;
    final matrix = Matrix4.identity()
      ..setEntry(0, 0, right.dx / plan.size.width)
      ..setEntry(1, 0, right.dy / plan.size.width)
      ..setEntry(0, 1, down.dx / plan.size.height)
      ..setEntry(1, 1, down.dy / plan.size.height)
      ..setEntry(0, 3, origin.dx)
      ..setEntry(1, 3, origin.dy);
    return IgnorePointer(
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: plan.size.width,
              height: plan.size.height,
              child: Transform(
                transform: matrix,
                child: RepaintBoundary(
                  child: Opacity(
                    opacity: opacity,
                    child: ClipPath(
                      clipper: MapGeoreferenceClipper(
                        plan.georeference?.excludedRegions ?? const [],
                      ),
                      child: plan.rooms.isNotEmpty
                          ? MapCartographicLayer(
                              svgContent: plan.svg,
                              syntheticRoomIds: plan.syntheticRoomIds,
                              rooms: plan.rooms,
                              places: plan.places,
                              size: plan.size,
                              transform: AlwaysStoppedAnimation(matrix),
                            )
                          : SvgPicture.string(
                              plan.svg,
                              fit: BoxFit.fill,
                              colorMapper: MapSvgColors(context.colors),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapGeoreferenceClipper extends CustomClipper<ui.Path> {
  const MapGeoreferenceClipper(this.excludedRegions);

  final List<MapGeoreferenceRegion> excludedRegions;

  @override
  ui.Path getClip(Size size) {
    var path = ui.Path()..addRect(Offset.zero & size);
    for (final region in excludedRegions) {
      if (region.width <= 0 || region.height <= 0) continue;
      path = ui.Path.combine(
        PathOperation.difference,
        path,
        ui.Path()..addRect(
          Rect.fromLTWH(
            region.x,
            region.y,
            region.width,
            region.height,
          ),
        ),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(MapGeoreferenceClipper oldClipper) =>
      excludedRegions != oldClipper.excludedRegions;
}
