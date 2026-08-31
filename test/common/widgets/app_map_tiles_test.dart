import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/common/widgets/app_map_tiles.dart';

class _TrackingTileProvider extends TileProvider {
  bool disposed = false;

  @override
  ImageProvider<Object> getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) => MemoryImage(TileProvider.transparentImage);

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

TileLayer _tileLayerFrom(Widget widget) {
  final boundary = widget as RepaintBoundary;
  final background = boundary.child! as ColoredBox;
  final content = background.child!;
  return (content as ColorFiltered).child! as TileLayer;
}

Future<Widget> _buildTiles(
  WidgetTester tester, {
  required ThemeData theme,
}) async {
  late Widget tiles;
  await tester.pumpWidget(
    MaterialApp(
      key: ValueKey(theme.brightness),
      theme: theme,
      home: Builder(
        builder: (context) {
          tiles = AppMapTiles.tileLayer(
            context,
            tileProvider: AssetTileProvider(),
          );
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return tiles;
}

void main() {
  test(
    'uses a keyless single-host endpoint with conservative requests',
    () async {
      final provider = AppMapTiles.createTileProvider(
        cachingProvider: const DisabledMapCachingProvider(),
      );

      expect(AppMapTiles.urlTemplate, contains('tile.openstreetmap.org'));
      expect(AppMapTiles.urlTemplate, isNot(contains('{s}')));
      expect(AppMapTiles.urlTemplate, isNot(contains('key=')));
      expect(provider.headers['User-Agent'], contains('ninja.mirea.mireaapp'));
      expect(provider.silenceExceptions, isTrue);
      expect(provider.attemptDecodeOfHttpErrorResponses, isFalse);
      expect(provider.abortObsoleteRequests, isTrue);
      expect(AppMapTiles.maxCacheSizeBytes, 128 * 1024 * 1024);
      expect(provider.cachingProvider, isA<DisabledMapCachingProvider>());

      await provider.dispose();
    },
  );

  testWidgets('keeps tile loading conservative and filters dark mode once', (
    tester,
  ) async {
    final lightTiles = await _buildTiles(tester, theme: AppTheme.lightTheme);
    final lightLayer = _tileLayerFrom(lightTiles);

    expect(lightTiles, isA<RepaintBoundary>());
    expect((lightTiles as RepaintBoundary).child, isA<ColoredBox>());
    expect((lightTiles.child! as ColoredBox).child, isA<ColorFiltered>());
    expect(lightLayer.maxNativeZoom, 19);
    expect(lightLayer.keepBuffer, 1);
    expect(lightLayer.panBuffer, 0);
    expect(lightLayer.subdomains, isEmpty);
    expect(lightLayer.resolvedRetinaMode, RetinaMode.disabled);
    expect(
      lightLayer.evictErrorTileStrategy,
      EvictErrorTileStrategy.notVisible,
    );

    final darkTiles = await _buildTiles(tester, theme: AppTheme.darkTheme);
    final darkBackground = (darkTiles as RepaintBoundary).child! as ColoredBox;
    expect(darkBackground.child, isA<ColorFiltered>());
    expect(_tileLayerFrom(darkTiles).urlTemplate, AppMapTiles.urlTemplate);
  });

  testWidgets('builds with the configured network provider', (tester) async {
    final provider = AppMapTiles.createTileProvider(
      cachingProvider: const DisabledMapCachingProvider(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(55.67, 37.48),
              initialZoom: 15,
            ),
            children: [
              AppMapTiles.tileLayer(context, tileProvider: provider),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(TileLayer), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('keeps the tile provider alive when the theme changes', (
    tester,
  ) async {
    final provider = _TrackingTileProvider();
    final themeMode = ValueNotifier(ThemeMode.light);
    addTearDown(themeMode.dispose);

    await tester.pumpWidget(
      ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, mode, child) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: Builder(
            builder: (context) => FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(55.67, 37.48),
                initialZoom: 15,
              ),
              children: [
                AppMapTiles.tileLayer(context, tileProvider: provider),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    themeMode.value = ThemeMode.dark;
    await tester.pumpAndSettle();

    expect(provider.disposed, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(provider.disposed, isTrue);
  });
}
