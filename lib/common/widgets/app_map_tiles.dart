import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
import 'package:url_launcher/url_launcher.dart';

typedef AppMapStyleLoader = Future<vt.Style> Function(Brightness brightness);

class AppMapTiles {
  const AppMapTiles._();

  static const _packageName = 'ninja.mirea.mireaapp';
  static const _userAgent =
      'NinjaMirea ($_packageName; https://mirea.ninja; support@mirea.ninja)';
  static const int maxCacheSizeBytes = 128 * 1024 * 1024;

  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String lightStyleUrl =
      'https://tiles.openfreemap.org/styles/liberty';
  static const String darkStyleUrl =
      'https://tiles.openfreemap.org/styles/dark';
  static const String attribution = '© OpenMapTiles · © OpenStreetMap';

  static const _darkMap = ColorFilter.matrix(<double>[
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    205,
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    210,
    -0.1594,
    -0.5355,
    -0.0541,
    0,
    220,
    0,
    0,
    0,
    1,
    0,
  ]);
  static Future<vt.Style> loadStyle(Brightness brightness) => vt.StyleReader(
    uri: brightness == .dark ? darkStyleUrl : lightStyleUrl,
    headers: const {'User-Agent': _userAgent},
    language: 'ru',
  ).read();

  static Future<void> showAttribution(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          top: false,
          child: Column(
            mainAxisSize: .min,
            children: [
              for (final source in const {
                'OpenFreeMap': 'https://openfreemap.org/',
                '© OpenMapTiles': 'https://www.openmaptiles.org/',
                '© OpenStreetMap contributors':
                    'https://www.openstreetmap.org/copyright',
              }.entries)
                ListTile(
                  title: Text(source.key),
                  trailing: const Icon(Icons.open_in_new_rounded),
                  onTap: () => unawaited(
                    launchUrl(
                      Uri.parse(source.value),
                      mode: .externalApplication,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  static NetworkTileProvider createTileProvider({
    MapCachingProvider? cachingProvider,
  }) {
    return NetworkTileProvider(
      headers: {'User-Agent': _userAgent},
      silenceExceptions: true,
      attemptDecodeOfHttpErrorResponses: false,
      cachingProvider:
          cachingProvider ??
          BuiltInMapCachingProvider.getOrCreateInstance(
            maxCacheSize: maxCacheSizeBytes,
          ),
    );
  }

  static Widget tileLayer(
    BuildContext context, {
    required TileProvider tileProvider,
  }) => AppMapTileLayer(tileProvider: tileProvider);

  static Widget _fallbackLayer(
    BuildContext context, {
    required TileProvider tileProvider,
  }) {
    final isDark = Theme.of(context).brightness == .dark;
    final layer = TileLayer(
      urlTemplate: urlTemplate,
      tileProvider: tileProvider,
      userAgentPackageName: _packageName,
      subdomains: const [],
      keepBuffer: 1,
      panBuffer: 0,
      tileDisplay: const TileDisplay.fadeIn(
        duration: Duration(milliseconds: 80),
      ),
      evictErrorTileStrategy: EvictErrorTileStrategy.notVisible,
    );
    return RepaintBoundary(
      child: ColoredBox(
        color: isDark ? AppColors.mapCanvasDark : AppColors.mapCanvasLight,
        child: isDark
            ? ColorFiltered(colorFilter: _darkMap, child: layer)
            : layer,
      ),
    );
  }
}

class AppMapTileLayer extends StatefulWidget {
  const AppMapTileLayer({
    required this.tileProvider,
    this.styleLoader = AppMapTiles.loadStyle,
    super.key,
  });

  final TileProvider tileProvider;
  final AppMapStyleLoader styleLoader;

  @override
  State<AppMapTileLayer> createState() => _AppMapTileLayerState();
}

class _AppMapTileLayerState extends State<AppMapTileLayer> {
  final _styles = <Brightness, Future<vt.Style>>{};
  final _ownedStyles = <Future<vt.Style>>[];
  final _loadTimers = <Timer>[];
  late final _fallbackProvider = _RetainedTileProvider(widget.tileProvider);
  late Brightness _brightness;
  late Future<vt.Style> _style;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _brightness = Theme.of(context).brightness;
    _style = _styles.putIfAbsent(_brightness, () {
      final style = Future<vt.Style>.sync(
        () => widget.styleLoader(_brightness),
      );
      _ownedStyles.add(style);
      final result = Completer<vt.Style>();
      final timer = Timer(const Duration(seconds: 15), () {
        result.completeError(TimeoutException('Map style loading timed out'));
      });
      _loadTimers.add(timer);
      unawaited(
        style.then(
          (loaded) {
            timer.cancel();
            if (!result.isCompleted) result.complete(loaded);
          },
          onError: (Object error, StackTrace stackTrace) {
            timer.cancel();
            if (!result.isCompleted) result.completeError(error, stackTrace);
          },
        ),
      );
      return result.future;
    });
  }

  @override
  void dispose() {
    for (final timer in _loadTimers) {
      timer.cancel();
    }
    for (final style in _ownedStyles) {
      style.then((loaded) => loaded.dispose()).ignore();
    }
    widget.tileProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: ColoredBox(
      color: _brightness == .dark
          ? const Color(0xff0c0c0c)
          : const Color(0xfff8f4f0),
      child: FutureBuilder<vt.Style>(
        key: ValueKey(_brightness),
        future: _style,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppMapTiles._fallbackLayer(
              context,
              tileProvider: _fallbackProvider,
            );
          }
          final style = snapshot.data;
          if (style == null) return const SizedBox.expand();
          return vt.VectorTileLayer(
            theme: style.theme,
            tileProviders: style.providers,
            rasterSources: style.rasterSources,
            sprites: style.sprites,
            labelMode: .tile,
            tileFadeDuration: const Duration(milliseconds: 80),
            diskCacheMaximumSizeInBytes: AppMapTiles.maxCacheSizeBytes,
            diskCacheTtl: const Duration(hours: 12),
          );
        },
      ),
    ),
  );
}

class _RetainedTileProvider extends TileProvider {
  _RetainedTileProvider(this.provider) : super(headers: provider.headers);

  final TileProvider provider;

  @override
  bool get supportsCancelLoading => provider.supportsCancelLoading;

  @override
  ImageProvider<Object> getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) => provider.getImage(coordinates, options);

  @override
  ImageProvider<Object> getImageWithCancelLoadingSupport(
    TileCoordinates coordinates,
    TileLayer options,
    Future<void> cancelLoading,
  ) => provider.getImageWithCancelLoadingSupport(
    coordinates,
    options,
    cancelLoading,
  );
}
