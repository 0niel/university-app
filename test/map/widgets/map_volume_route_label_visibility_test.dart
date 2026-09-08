import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:rtu_mirea_app/map/services/map_label_hit_index.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';
import 'package:rtu_mirea_app/map/widgets/map_volume_layer.dart';

void main() {
  for (final marker in ['start', 'destination', 'instruction']) {
    testWidgets('3D labels leave the visible $marker marker unobstructed', (
      tester,
    ) async {
      final transform = TransformationController();
      addTearDown(transform.dispose);
      final hits = MapLabelHitIndex();
      final boundaryKey = GlobalKey();
      final rooms = [
        RoomModel(
          roomId: 'auditorium',
          name: '101',
          path: Path()..addRect(const Rect.fromLTWH(150, 150, 100, 100)),
        ),
        RoomModel(
          roomId: 'nearby',
          name: '102',
          path: Path()..addRect(const Rect.fromLTWH(40, 150, 80, 100)),
        ),
      ];
      final layers = MapStructureLayers.fromSvg('<svg viewBox="0 0 400 400"/>');
      final segments = [
        [
          if (marker == 'start')
            const Offset(200, 200)
          else
            const Offset(80, 80),
          if (marker == 'destination')
            const Offset(200, 200)
          else
            const Offset(320, 320),
        ],
      ];
      late Color accent;
      Future<void> pump({required bool enabled, bool emptyRoute = false}) =>
          tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.lightTheme,
              home: Builder(
                builder: (context) {
                  accent = context.colors.accent;
                  return Align(
                    alignment: Alignment.topLeft,
                    child: RepaintBoundary(
                      key: boundaryKey,
                      child: MapVolumeLayer(
                        floorSize: const Size(400, 400),
                        viewportSize: const Size(400, 400),
                        layers: layers,
                        rooms: rooms,
                        transform: transform,
                        hitIndex: hits,
                        bearing: .7,
                        routeSegments: emptyRoute ? const [] : segments,
                        showRouteStart: enabled && marker == 'start',
                        showRouteDestination:
                            enabled && marker == 'destination',
                        instructionPoint: enabled && marker == 'instruction'
                            ? const Offset(200, 200)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          );

      await pump(enabled: false);
      expect(hits.hitTest(const Offset(200, 200)), 'auditorium');
      await pump(enabled: true);
      expect(hits.bounds, isNot(contains('auditorium')));
      expect(hits.bounds, contains('nearby'));
      expect(
        hits.bounds.values.any(
          const Rect.fromLTWH(188, 188, 24, 24).overlaps,
        ),
        isFalse,
      );
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = (await tester.runAsync(boundary.toImage))!;
      final data = (await tester.runAsync(image.toByteData))!;
      final bytes = data.buffer.asUint8List();
      final argb = accent.toARGB32();
      var visibleAccentPixels = 0;
      for (var y = 188; y < 212; y++) {
        for (var x = 188; x < 212; x++) {
          final offset = (y * image.width + x) * 4;
          if (bytes[offset] == (argb >> 16 & 255) &&
              bytes[offset + 1] == (argb >> 8 & 255) &&
              bytes[offset + 2] == (argb & 255) &&
              bytes[offset + 3] == 255) {
            visibleAccentPixels++;
          }
        }
      }
      image.dispose();
      expect(visibleAccentPixels, greaterThan(10));
      await pump(enabled: false);
      expect(hits.hitTest(const Offset(200, 200)), 'auditorium');
      await pump(enabled: true, emptyRoute: true);
      expect(hits.hitTest(const Offset(200, 200)), 'auditorium');
      expect(tester.takeException(), isNull);
    });
  }
}
