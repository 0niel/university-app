import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_data_repository.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_landmarks.dart';
import 'package:rtu_mirea_app/map/services/map_navigation_preparation.dart';
import 'package:rtu_mirea_app/map/services/objects_service.dart';
import 'package:rtu_mirea_app/map/widgets/map_floor_canvas.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';

const _durationSeconds = int.fromEnvironment(
  'MAP_PROBE_SECONDS',
  defaultValue: 120,
);

const _volume = bool.fromEnvironment('MAP_PROBE_VOLUME');
const _rotate = bool.fromEnvironment('MAP_PROBE_ROTATE');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const _RenderProbe(),
    ),
  );
}

void _report(String event, Map<String, Object?> values) {
  debugPrintSynchronously(
    jsonEncode({
      'map_render_probe': event,
      'utc': DateTime.now().toUtc().toIso8601String(),
      'rss_bytes': ProcessInfo.currentRss,
      'peak_rss_bytes': ProcessInfo.maxRss,
      ...values,
    }),
  );
}

class _ReadOnlyCache implements MapDataCache {
  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

class _PreparedFloor {
  const _PreparedFloor({
    required this.campus,
    required this.floor,
    required this.svg,
    required this.rooms,
    required this.places,
    required this.syntheticIds,
    required this.landmarks,
    required this.structure,
  });

  final String campus;
  final MapFloorData floor;
  final String svg;
  final List<RoomModel> rooms;
  final List<MapPlaceData> places;
  final Set<String> syntheticIds;
  final List<MapNavigationLandmark> landmarks;
  final MapStructureLayers? structure;
}

class _RenderProbe extends StatefulWidget {
  const _RenderProbe();

  @override
  State<_RenderProbe> createState() => _RenderProbeState();
}

class _RenderProbeState extends State<_RenderProbe>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Matrix4> _transform = ValueNotifier(Matrix4.identity());
  final _frames = <ui.FrameTiming>[];
  late final Ticker _ticker;
  Timer? _reportTimer;
  List<_PreparedFloor> _floors = const [];
  Size _viewport = Size.zero;
  int _floorIndex = 0;
  int _frameCount = 0;
  int _over16 = 0;
  int _over33 = 0;
  int _buildMicros = 0;
  int _rasterMicros = 0;
  int _maxBuildMicros = 0;
  int _maxRasterMicros = 0;
  bool _running = false;
  bool _finished = false;
  String? _error;
  double _scale = 1;
  double _bearing = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    unawaited(_prepare());
  }

  Future<void> _prepare() async {
    final stopwatch = Stopwatch()..start();
    final repository = MapDataRepository(
      organizationId: 'mirea',
      bundledCatalogAsset: MapDataRepository.pulseCatalogAsset,
      cache: _ReadOnlyCache(),
      rpc: (_, _) async => throw const MapDataException('Bundled data only'),
    );
    final bloc = MapBloc(
      availableCampuses: [],
      repository: repository,
      objectsService: ObjectsService(),
    );
    try {
      final initial = bloc.stream.firstWhere(
        (state) =>
            state.status == MapStatus.loaded ||
            state.status == MapStatus.failure,
      );
      bloc.add(const MapEvent.initialized());
      await initial.timeout(const Duration(seconds: 30));
      if (bloc.state.status != MapStatus.loaded) {
        throw StateError(bloc.state.errorMessage ?? 'Map preparation failed');
      }
      final result = <_PreparedFloor>[];
      for (final campusId in ['v-78', 'v-86', 's-20', 'mp-1']) {
        if (bloc.state.selectedCampus?.id != campusId) {
          final selected = bloc.state.availableCampuses.firstWhere(
            (campus) => campus.id == campusId,
          );
          final ready = bloc.stream.firstWhere(
            (state) =>
                state.status == MapStatus.failure ||
                state.status == MapStatus.loaded &&
                    state.selectedCampus?.id == campusId,
          );
          bloc.add(MapEvent.campusSelected(selected));
          await ready.timeout(const Duration(seconds: 30));
        }
        final campus = bloc.state.campusData;
        if (bloc.state.status != MapStatus.loaded || campus == null) {
          throw StateError(
            bloc.state.errorMessage ?? 'Missing campus $campusId',
          );
        }
        final navigation = await prepareMapNavigation(campus);
        for (final floor in campus.floors) {
          if (bloc.state.selectedFloor?.id != floor.floor.id) {
            final ready = bloc.stream.firstWhere(
              (state) =>
                  state.status == MapStatus.failure ||
                  state.status == MapStatus.loaded &&
                      state.selectedFloor?.id == floor.floor.id,
            );
            bloc.add(
              MapEvent.floorSelected(campus: campus.campus, floor: floor.floor),
            );
            await ready.timeout(const Duration(seconds: 30));
          }
          if (bloc.state.status != MapStatus.loaded) {
            throw StateError(
              bloc.state.errorMessage ?? 'Floor preparation failed',
            );
          }
          final svg =
              bloc.state.svgContent ??
              await repository.loadSvg(floor.floor.svgPath);
          final prepared = _PreparedFloor(
            campus: campusId,
            floor: floor,
            svg: svg,
            structure: _volume ? MapStructureLayers.fromSvg(svg) : null,
            rooms: List.unmodifiable(bloc.state.rooms),
            places: List.unmodifiable(
              campus.rooms.where((place) => place.floorId == floor.floor.id),
            ),
            syntheticIds: Set.unmodifiable(bloc.syntheticRoomIds),
            landmarks: navigation.byFloor[floor.floor.id] ?? const [],
          );
          result.add(prepared);
          _report('prepared_floor', {
            'campus': campusId,
            'floor': floor.floor.id,
            'floor_width': floor.width,
            'floor_height': floor.height,
            'svg_characters': prepared.svg.length,
            'rooms': prepared.rooms.length,
            'places': prepared.places.length,
            'synthetic_rooms': prepared.syntheticIds.length,
            'landmarks': prepared.landmarks.length,
          });
        }
      }
      if (!mounted) return;
      setState(() => _floors = result);
      _report('prepared', {
        'floors': result.length,
        'elapsed_ms': stopwatch.elapsedMilliseconds,
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _running = true;
        WidgetsBinding.instance.addTimingsCallback(_recordFrames);
        _reportTimer = Timer.periodic(
          const Duration(seconds: 2),
          (_) => _reportFrames(),
        );
        _report('started', {
          'duration_seconds': _durationSeconds.clamp(10, 600),
          'mode': _volume ? '3d' : '2d',
          'rotation': _volume && _rotate,
        });
        unawaited(_ticker.start());
      });
    } on Object catch (error, stack) {
      _report('error', {'error': error.toString(), 'stack': stack.toString()});
      if (mounted) setState(() => _error = error.toString());
    } finally {
      await bloc.close();
      repository.dispose();
    }
  }

  void _tick(Duration elapsed) {
    if (_viewport.isEmpty || _floors.isEmpty) return;
    final seconds = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    final duration = _durationSeconds.clamp(10, 600);
    if (seconds >= duration) {
      _ticker.stop();
      _reportTimer?.cancel();
      _running = false;
      _reportFrames();
      WidgetsBinding.instance.removeTimingsCallback(_recordFrames);
      _report('complete', {
        'elapsed_seconds': seconds,
        'frames': _frameCount,
        'build_mean_ms': _frameCount == 0
            ? 0
            : _buildMicros / _frameCount / 1000,
        'raster_mean_ms': _frameCount == 0
            ? 0
            : _rasterMicros / _frameCount / 1000,
        'build_max_ms': _maxBuildMicros / 1000,
        'raster_max_ms': _maxRasterMicros / 1000,
        'frames_over_16_7_ms': _over16,
        'frames_over_33_3_ms': _over33,
      });
      setState(() => _finished = true);
      return;
    }
    final cycle = math.min(duration, 120);
    final stage = (seconds % cycle) * _floors.length / cycle;
    final index = stage.floor().clamp(0, _floors.length - 1);
    if (_floorIndex != index) _reportFrames();
    if (_floorIndex != index || _volume && _rotate) {
      setState(() {
        _floorIndex = index;
        _bearing = seconds * math.pi / 20;
      });
    }
    final floor = _floors[index];
    final progress = stage - index;
    final fit = math.min(
      _viewport.width / floor.floor.width,
      _viewport.height / floor.floor.height,
    );
    final scales = [
      fit,
      .5,
      1.0,
      2.0,
      5.0,
      10.0,
      20.0,
      50.0,
      50.0,
      20.0,
      5.0,
      fit,
    ];
    final phase = progress * (scales.length - 1);
    final first = phase.floor().clamp(0, scales.length - 2);
    _scale = math.exp(
      math.log(scales[first]) * (1 - (phase - first)) +
          math.log(scales[first + 1]) * (phase - first),
    );
    final width = floor.floor.width;
    final height = floor.floor.height;
    final center = Offset(
      width * (.5 + .38 * math.sin(progress * math.pi * 4)),
      height * (.5 + .38 * math.cos(progress * math.pi * 4)),
    );
    _transform.value = Matrix4.identity()
      ..scaleByDouble(_scale, _scale, 1, 1)
      ..setTranslationRaw(
        _viewport.width / 2 - center.dx * _scale,
        _viewport.height / 2 - center.dy * _scale,
        0,
      );
  }

  void _recordFrames(List<ui.FrameTiming> timings) {
    if (!_running) return;
    _frames.addAll(timings);
    for (final frame in timings) {
      _frameCount++;
      final build = frame.buildDuration.inMicroseconds;
      final raster = frame.rasterDuration.inMicroseconds;
      _buildMicros += build;
      _rasterMicros += raster;
      _maxBuildMicros = math.max(_maxBuildMicros, build);
      _maxRasterMicros = math.max(_maxRasterMicros, raster);
      if (math.max(build, raster) > 16667) _over16++;
      if (math.max(build, raster) > 33333) _over33++;
    }
  }

  Map<String, Object> _stats(Iterable<int> values) {
    final sorted = values.toList()..sort();
    if (sorted.isEmpty) return {'mean_ms': 0, 'p95_ms': 0, 'max_ms': 0};
    return {
      'mean_ms':
          sorted.fold<int>(0, (sum, value) => sum + value) /
          sorted.length /
          1000,
      'p95_ms': sorted[(sorted.length * .95).ceil() - 1] / 1000,
      'max_ms': sorted.last / 1000,
    };
  }

  void _reportFrames() {
    if (_floors.isEmpty) return;
    final floor = _floors[_floorIndex];
    _report('frames', {
      'campus': floor.campus,
      'floor': floor.floor.floor.id,
      'viewport_width': _viewport.width,
      'viewport_height': _viewport.height,
      'device_pixel_ratio': View.of(context).devicePixelRatio,
      'scale': _scale,
      'frames': _frames.length,
      'build': _stats(
        _frames.map((frame) => frame.buildDuration.inMicroseconds),
      ),
      'raster': _stats(
        _frames.map((frame) => frame.rasterDuration.inMicroseconds),
      ),
      'total_span': _stats(
        _frames.map((frame) => frame.totalSpan.inMicroseconds),
      ),
    });
    _frames.clear();
  }

  @override
  void dispose() {
    _running = false;
    _reportTimer?.cancel();
    WidgetsBinding.instance.removeTimingsCallback(_recordFrames);
    _ticker.dispose();
    _transform.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: _error != null || _finished || _floors.isEmpty
          ? Center(
              child: Text(
                _error ??
                    (_finished ? 'Проверка завершена' : 'Подготовка планов…'),
                style: AppText.bodyStrong,
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                _viewport = constraints.biggest;
                final floor = _floors[_floorIndex];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRect(
                      child: _volume
                          ? MapVolumeLayer(
                              key: ValueKey(
                                '${floor.campus}:${floor.floor.floor.id}',
                              ),
                              floorSize: Size(
                                floor.floor.width,
                                floor.floor.height,
                              ),
                              viewportSize: _viewport,
                              layers: floor.structure!,
                              rooms: floor.rooms,
                              places: floor.places,
                              navigationLandmarks: floor.landmarks,
                              syntheticRoomIds: floor.syntheticIds,
                              transform: _transform,
                              bearing: _rotate ? _bearing : 0,
                            )
                          : MapFloorCanvas(
                              key: ValueKey(
                                '${floor.campus}:${floor.floor.floor.id}',
                              ),
                              svgAssetPath: floor.floor.floor.svgPath,
                              svgContent: floor.svg,
                              canvasSize: Size(
                                floor.floor.width,
                                floor.floor.height,
                              ),
                              viewportSize: _viewport,
                              rooms: floor.rooms,
                              places: floor.places,
                              syntheticRoomIds: floor.syntheticIds,
                              navigationLandmarks: floor.landmarks,
                              transform: _transform,
                              showRoomLabels: true,
                            ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: AppCard(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${floor.campus} · ${floor.floor.floor.number} этаж · ${_floorIndex + 1}/${_floors.length}',
                          style: AppText.caption,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    ),
  );
}
