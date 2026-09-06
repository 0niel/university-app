import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';
import 'package:rtu_mirea_app/map/widgets/map_geographic_view.dart';
import 'package:rtu_mirea_app/map/widgets/map_graph_editor_page.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, Object?> buildMapFloorAlignmentPatch({
  required MapFloorData floor,
  required List<FloorGeoAnchor> anchors,
  double? measuredDistanceMeters,
}) {
  if (anchors.length != 3) {
    throw const FormatException(
      'Отметьте три пары точек на плане и на здании.',
    );
  }
  for (final anchor in anchors) {
    if (anchor.x < 0 ||
        anchor.y < 0 ||
        anchor.x > floor.width ||
        anchor.y > floor.height) {
      throw const FormatException(
        'Опорные точки должны находиться внутри плана.',
      );
    }
  }
  final a = anchors[0];
  final b = anchors[1];
  final c = anchors[2];
  final area =
      ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)).abs() / 2;
  if (area < floor.width * floor.height * .005) {
    throw const FormatException(
      'Разнесите точки по зданию: выберите три разных угла, '
      'не лежащих на одной линии.',
    );
  }
  try {
    FloorGeoreference(anchors)
      ..pixelToGeographic(0, 0)
      ..pixelToGeographic(floor.width, floor.height);
  } on FormatException {
    throw const FormatException(
      'По этим точкам нельзя совместить план. '
      'Проверьте пары и выберите разные углы здания.',
    );
  }
  double? scale;
  if (measuredDistanceMeters != null) {
    if (!measuredDistanceMeters.isFinite || measuredDistanceMeters <= 0) {
      throw const FormatException(
        'Измеренное расстояние должно быть больше нуля.',
      );
    }
    scale =
        measuredDistanceMeters / (Offset(a.x, a.y) - Offset(b.x, b.y)).distance;
    if (!scale.isFinite || scale <= .000001 || scale >= 10000) {
      throw const FormatException(
        'Проверьте измеренное расстояние между точками 1 и 2.',
      );
    }
  }
  return {
    'anchors': [
      for (final anchor in anchors)
        {
          'x': anchor.x,
          'y': anchor.y,
          'latitude': anchor.latitude,
          'longitude': anchor.longitude,
        },
    ],
    'meters_per_unit': ?scale,
  };
}

class MapFloorAlignmentPage extends StatefulWidget {
  const MapFloorAlignmentPage({
    required this.campus,
    required this.repository,
    this.initialFloorId,
    super.key,
  });

  final CampusMapData campus;
  final MapDataRepository repository;
  final String? initialFloorId;

  @override
  State<MapFloorAlignmentPage> createState() => _MapFloorAlignmentPageState();
}

class _MapFloorAlignmentPageState extends State<MapFloorAlignmentPage> {
  static const _measurementKeyboard = TextInputType.numberWithOptions(
    decimal: true,
  );
  final _mapController = MapController();
  late final TileProvider _tiles = AppMapTiles.createTileProvider();
  final _measurement = TextEditingController();
  final _drafts = <String, List<FloorGeoAnchor>>{};
  final _measurements = <String, String>{};
  final _dirty = <String>{};
  late MapFloorData? _floor =
      widget.campus.floorForId(widget.initialFloorId ?? '') ??
      widget.campus.floors.firstOrNull;
  bool _showMap = false;
  bool _loadingPreview = false;
  Offset? _pending;
  int? _replaceIndex;
  String? _error;

  List<FloorGeoAnchor> get _anchors {
    final floor = _floor;
    if (floor == null) return [];
    return _drafts.putIfAbsent(
      floor.floor.id,
      () => floor.anchors
          .take(3)
          .map(
            (anchor) => FloorGeoAnchor(
              x: anchor.x,
              y: anchor.y,
              latitude: anchor.latitude,
              longitude: anchor.longitude,
            ),
          )
          .toList(),
    );
  }

  LatLng get _center {
    if (_anchors.isNotEmpty) {
      return LatLng(_anchors.first.latitude, _anchors.first.longitude);
    }
    if (widget.campus.latitude case final latitude?) {
      if (widget.campus.longitude case final longitude?) {
        return LatLng(latitude, longitude);
      }
    }
    return const LatLng(55.75, 37.62);
  }

  @override
  void dispose() {
    _measurement.dispose();
    _mapController.dispose();
    _tiles.dispose();
    super.dispose();
  }

  void _selectFloor(MapFloorData floor) {
    if (_floor != null) _measurements[_floor!.floor.id] = _measurement.text;
    setState(() {
      _floor = floor;
      _measurement.text = _measurements[floor.floor.id] ?? '';
      _pending = null;
      _replaceIndex = null;
      _error = null;
      _showMap = false;
    });
  }

  void _planTap(Offset point, double hitRadius) {
    if (_anchors.length == 3 && _replaceIndex == null) {
      setState(
        () => _error =
            'Три точки уже выбраны. '
            'Нажмите номер пары ниже, чтобы заменить её.',
      );
      return;
    }
    setState(() {
      _pending = point;
      _showMap = true;
      _error = null;
    });
  }

  void _geographicTap(LatLng point) {
    final pending = _pending;
    if (pending == null) {
      setState(() => _error = 'Сначала выберите эту же точку на плане.');
      return;
    }
    setState(() {
      final anchor = FloorGeoAnchor(
        x: pending.dx,
        y: pending.dy,
        latitude: point.latitude,
        longitude: point.longitude,
      );
      if (_replaceIndex case final index?) {
        _anchors[index] = anchor;
        if (index < 2) {
          _measurement.clear();
          _measurements.remove(_floor!.floor.id);
        }
      } else {
        _anchors.add(anchor);
      }
      _dirty.add(_floor!.floor.id);
      _pending = null;
      _replaceIndex = null;
      _showMap = false;
      _error = null;
    });
  }

  Map<String, Object?> _patch() {
    final value = _measurement.text.trim();
    final measurement = value.isEmpty
        ? null
        : double.tryParse(value.replaceAll(',', '.'));
    if (value.isNotEmpty && measurement == null) {
      throw const FormatException(
        'Введите измеренное расстояние в метрах, например 25,5.',
      );
    }
    return buildMapFloorAlignmentPatch(
      floor: _floor!,
      anchors: _anchors,
      measuredDistanceMeters: measurement,
    );
  }

  Future<void> _preview() async {
    try {
      _patch();
      final floor = _floor!;
      final reference = FloorGeoreference(_anchors);
      setState(() {
        _loadingPreview = true;
        _error = null;
      });
      final svg = await widget.repository.loadSvg(floor.floor.svgPath);
      if (!mounted) return;
      final topLeft = reference.pixelToGeographic(0, 0);
      final topRight = reference.pixelToGeographic(floor.width, 0);
      final bottomLeft = reference.pixelToGeographic(0, floor.height);
      final center = reference.pixelToGeographic(
        floor.width / 2,
        floor.height / 2,
      );
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => MapGeographicView(
            campusName: '${widget.campus.campus.displayName} · предпросмотр',
            center: LatLng(center.latitude, center.longitude),
            floorPlan: GeographicFloorPlan(
              svg: svg,
              size: Size(floor.width, floor.height),
              topLeft: LatLng(topLeft.latitude, topLeft.longitude),
              topRight: LatLng(topRight.latitude, topRight.longitude),
              bottomLeft: LatLng(bottomLeft.latitude, bottomLeft.longitude),
            ),
          ),
        ),
      );
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on Object {
      if (mounted) {
        setState(
          () => _error =
              'Не удалось загрузить план для предпросмотра. Повторите попытку.',
        );
      }
    } finally {
      if (mounted) setState(() => _loadingPreview = false);
    }
  }

  Future<void> _review() async {
    try {
      final patch = _patch();
      setState(() => _error = null);
      final scaleSummary = patch.containsKey('meters_per_unit')
          ? 'Масштаб рассчитан по измерению между точками 1 и 2.'
          : 'Масштаб проходов не изменяется.';
      final sent = await showMapEditorReview(
        context: context,
        campus: widget.campus,
        repository: widget.repository,
        entityType: 'floor',
        entityId: _floor!.floor.id,
        patch: patch,
        summary:
            'Этаж ${_floor!.floor.number}: 3 опорные точки.'
            '\n$scaleSummary'
            '\nПеред отправкой проверьте наложение: '
            'углы и контуры плана должны совпадать со зданием.',
      );
      if (sent && mounted) Navigator.pop(context, true);
    } on FormatException catch (error) {
      setState(() => _error = error.message);
    }
  }

  Widget _map() => Stack(
    children: [
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _center,
          initialZoom: widget.campus.latitude != null || _anchors.isNotEmpty
              ? 18
              : 11,
          maxZoom: 22,
          onTap: (position, point) => _geographicTap(point),
        ),
        children: [
          AppMapTiles.tileLayer(context, tileProvider: _tiles),
          MarkerLayer(
            markers: [
              for (var index = 0; index < _anchors.length; index++)
                Marker(
                  point: LatLng(
                    _anchors[index].latitude,
                    _anchors[index].longitude,
                  ),
                  width: 32,
                  height: 32,
                  child: _AnchorBadge(number: index + 1),
                ),
            ],
          ),
        ],
      ),
      Positioned(
        right: 12,
        top: 12,
        child: AppIconButton(
          icon: const Icon(Icons.center_focus_strong_rounded),
          tooltip: 'Вернуться к зданию',
          tone: AppIconButtonTone.surface,
          onPressed: () => _mapController.move(_center, 18),
        ),
      ),
      Positioned(
        left: 8,
        bottom: 0,
        child: ColoredBox(
          color: context.colors.surface,
          child: AppButton.text(
            label: AppMapTiles.attribution,
            size: AppButtonSize.small,
            textStyle: AppText.captionSmall,
            onPressed: () => unawaited(
              launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
            ),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final floor = _floor;
    final index = (_replaceIndex ?? _anchors.length) + 1;
    return Scaffold(
      backgroundColor: context.colors.canvas,
      body: Column(
        children: [
          AppInnerHeader(
            title: 'Привязка плана',
            titleStyle: AppText.title,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              MediaQuery.paddingOf(context).top + AppSpacing.sm,
              AppSpacing.screen,
              AppSpacing.sm,
            ),
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: floor == null
                ? const Center(child: Text('Планы этажей недоступны.'))
                : Column(
                    children: [
                      MapEditorFloorPicker(
                        floors: widget.campus.floors,
                        selected: floor.floor.id,
                        onSelected: _selectFloor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppChip(
                                label: 'План',
                                selected: !_showMap,
                                onTap: () => setState(() => _showMap = false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppChip(
                                label: 'Здание',
                                selected: _showMap,
                                onTap: () => setState(() => _showMap = true),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MapEditorHint(
                        label: _showMap && _pending != null
                            ? 'Точка $index: тот же угол на карте'
                            : _anchors.length == 3 && _replaceIndex == null
                            ? 'Проверьте наложение контуров'
                            : _showMap
                            ? 'Найдите здание на карте'
                            : 'Точка $index: выберите угол на плане',
                        help:
                            'Выберите узнаваемый угол здания на плане, '
                            'затем тот же угол на реальной карте. '
                            'Так соедините три пары точек.\n\n'
                            'Разнесите точки по зданию: они не должны лежать '
                            'на одной линии. Нажмите номер готовой пары, чтобы '
                            'заменить её. Перед отправкой откройте наложение '
                            'и проверьте совпадение контуров.',
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: _showMap ? 1 : 0,
                          children: [
                            MapEditorFloorCanvas(
                              key: ValueKey(floor.floor.id),
                              floor: floor,
                              repository: widget.repository,
                              places: widget.campus.rooms,
                              onTap: _planTap,
                              painter: _AnchorPainter(
                                floor: floor,
                                anchors: List.of(_anchors),
                                pending: _pending,
                                color: context.colors.accent,
                                background: context.colors.surface,
                                foreground: context.colors.onAccent,
                              ),
                            ),
                            _map(),
                          ],
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * .30,
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (
                                        var index = 0;
                                        index < _anchors.length;
                                        index++
                                      )
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          child: Tooltip(
                                            message:
                                                'Изменить пару ${index + 1}',
                                            child: AppChip(
                                              label: '${index + 1}',
                                              selected: _replaceIndex == index,
                                              onTap: () => setState(() {
                                                _replaceIndex = index;
                                                _pending = null;
                                                _showMap = false;
                                                _error = null;
                                              }),
                                            ),
                                          ),
                                        ),
                                      if (_anchors.isNotEmpty ||
                                          _pending != null)
                                        AppIconButton(
                                          icon: const Icon(Icons.undo_rounded),
                                          tooltip: 'Отменить точку',
                                          onPressed: () => setState(() {
                                            if (_pending == null &&
                                                _anchors.isNotEmpty) {
                                              _anchors.removeLast();
                                            }
                                            _pending = null;
                                            _replaceIndex = null;
                                            _showMap = false;
                                            _error = null;
                                            _dirty.add(floor.floor.id);
                                            _measurement.clear();
                                          }),
                                        ),
                                    ],
                                  ),
                                ),
                                if (_anchors.length == 3)
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    title: const Text('Масштаб по измерению'),
                                    children: [
                                      AppInputField(
                                        controller: _measurement,
                                        label: 'Между точками 1 и 2, м',
                                        placeholder: 'По замеру или чертежу',
                                        keyboardType: _measurementKeyboard,
                                        onChanged: (value) => setState(
                                          () => _dirty.add(floor.floor.id),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_error != null) ...[
                                  AppBanner(
                                    message: _error!,
                                    tone: AppBannerTone.warn,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Row(
                                  children: [
                                    AppIconButton(
                                      icon: _loadingPreview
                                          ? const SizedBox.square(
                                              dimension: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(Icons.layers_outlined),
                                      tooltip: 'Предпросмотр наложения',
                                      onPressed:
                                          _anchors.length == 3 &&
                                              !_loadingPreview
                                          ? _preview
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: AppButton.primary(
                                        label: 'Проверить',
                                        onPressed:
                                            _anchors.length == 3 &&
                                                _dirty.contains(floor.floor.id)
                                            ? _review
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                AppButton.text(
                                  label: 'Пульс МИРЭА',
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
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _AnchorBadge extends StatelessWidget {
  const _AnchorBadge({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.accent,
      shape: BoxShape.circle,
      border: Border.all(color: context.colors.surface, width: 2),
    ),
    child: Center(
      child: Text(
        '$number',
        style: TextStyle(
          color: context.colors.onAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class _AnchorPainter extends CustomPainter {
  const _AnchorPainter({
    required this.floor,
    required this.anchors,
    required this.pending,
    required this.color,
    required this.background,
    required this.foreground,
  });
  final MapFloorData floor;
  final List<FloorGeoAnchor> anchors;
  final Offset? pending;
  final Color color;
  final Color background;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      for (final anchor in anchors) Offset(anchor.x, anchor.y),
      ?pending,
    ];
    for (var index = 0; index < points.length; index++) {
      final point = Offset(
        points[index].dx / floor.width * size.width,
        points[index].dy / floor.height * size.height,
      );
      canvas
        ..drawCircle(point, 11, Paint()..color = background)
        ..drawCircle(point, 9, Paint()..color = color);
      final text = TextPainter(
        text: TextSpan(
          text: index >= anchors.length ? '+' : '${index + 1}',
          style: TextStyle(
            color: foreground,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text
        ..paint(canvas, point - Offset(text.width / 2, text.height / 2))
        ..dispose();
    }
  }

  @override
  bool shouldRepaint(_AnchorPainter oldDelegate) => true;
}
