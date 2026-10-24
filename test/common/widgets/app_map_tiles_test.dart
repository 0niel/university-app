import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_vector_tiles/flutter_map_vector_tiles.dart' as vt;
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

class _TrackingStyle extends vt.Style {
  _TrackingStyle(String id)
    : super(
        theme: vt.Theme(id: id, layers: const []),
        providers: const vt.TileProviders({}),
      );

  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

Widget _map({
  required TileProvider provider,
  required AppMapStyleLoader loadStyle,
  required ValueNotifier<ThemeMode> themeMode,
}) => ValueListenableBuilder<ThemeMode>(
  valueListenable: themeMode,
  builder: (context, mode, child) => MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: mode,
    home: FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(55.67, 37.48),
        initialZoom: 15,
      ),
      children: [
        AppMapTileLayer(tileProvider: provider, styleLoader: loadStyle),
      ],
    ),
  ),
);

void main() {
  test('retains a cached, identifiable raster fallback', () async {
    final provider = AppMapTiles.createTileProvider(
      cachingProvider: const DisabledMapCachingProvider(),
    );
    expect(AppMapTiles.urlTemplate, contains('tile.openstreetmap.org'));
    expect(provider.headers['User-Agent'], contains('ninja.mirea.mireaapp'));
    expect(provider.attemptDecodeOfHttpErrorResponses, isFalse);
    expect(provider.abortObsoleteRequests, isTrue);
    expect(provider.cachingProvider, isA<DisabledMapCachingProvider>());
    await provider.dispose();
  });

  testWidgets('loads each theme once and releases late styles on removal', (
    tester,
  ) async {
    final provider = _TrackingTileProvider();
    final mode = ValueNotifier(ThemeMode.light);
    addTearDown(mode.dispose);
    final light = Completer<vt.Style>();
    final dark = Completer<vt.Style>();
    final requests = <Brightness>[];
    final lightStyle = _TrackingStyle('light');
    final darkStyle = _TrackingStyle('dark');

    await tester.pumpWidget(
      _map(
        provider: provider,
        themeMode: mode,
        loadStyle: (brightness) {
          requests.add(brightness);
          return brightness == .dark ? dark.future : light.future;
        },
      ),
    );
    expect(find.byType(TileLayer), findsNothing);
    light.complete(lightStyle);
    await tester.pumpAndSettle();
    expect(find.byType(vt.VectorTileLayer), findsOneWidget);
    expect(
      tester
          .widget<vt.VectorTileLayer>(find.byType(vt.VectorTileLayer))
          .labelMode,
      vt.LabelMode.tile,
    );
    mode.value = ThemeMode.dark;
    await tester.pumpAndSettle();
    mode.value = ThemeMode.light;
    await tester.pumpAndSettle();
    expect(requests, [Brightness.light, Brightness.dark]);
    expect(provider.disposed, isFalse);
    expect(lightStyle.disposed, isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(lightStyle.disposed, isTrue);
    expect(provider.disposed, isTrue);
    dark.complete(darkStyle);
    await tester.pump();
    expect(darkStyle.disposed, isTrue);
  });

  testWidgets('fallback survives failed theme, successful theme, then return', (
    tester,
  ) async {
    final provider = _TrackingTileProvider();
    final mode = ValueNotifier(ThemeMode.light);
    addTearDown(mode.dispose);
    final light = Completer<vt.Style>();
    final dark = Completer<vt.Style>();
    await tester.pumpWidget(
      _map(
        provider: provider,
        themeMode: mode,
        loadStyle: (brightness) =>
            brightness == .dark ? dark.future : light.future,
      ),
    );
    light.completeError(StateError('Unavailable'));
    await tester.pumpAndSettle();
    expect(find.byType(TileLayer), findsOneWidget);
    expect(find.byType(ColorFiltered), findsNothing);
    mode.value = ThemeMode.dark;
    await tester.pumpAndSettle();
    dark.complete(_TrackingStyle('dark'));
    await tester.pumpAndSettle();
    expect(find.byType(vt.VectorTileLayer), findsOneWidget);
    expect(provider.disposed, isFalse);
    mode.value = ThemeMode.light;
    await tester.pumpAndSettle();
    expect(find.byType(TileLayer), findsOneWidget);
    expect(provider.disposed, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(provider.disposed, isTrue);
  });

  testWidgets('times out to fallback and cancels load timers on disposal', (
    tester,
  ) async {
    final mode = ValueNotifier(ThemeMode.light);
    addTearDown(mode.dispose);
    final style = Completer<vt.Style>();
    await tester.pumpWidget(
      _map(
        provider: _TrackingTileProvider(),
        themeMode: mode,
        loadStyle: (_) => style.future,
      ),
    );
    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.byType(TileLayer), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    style.complete(_TrackingStyle('late'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
