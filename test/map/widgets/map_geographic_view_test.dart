import 'dart:convert';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/navigation/floor_georeference.dart';
import 'package:rtu_mirea_app/map/widgets/map_geographic_view.dart';

void main() {
  test('all 23 bundled floor references round trip within their campus', () {
    var floorCount = 0;
    for (final id in ['v-78', 'v-86', 's-20', 'mp-1']) {
      final campus = _campus(id);
      for (final floor
          in (campus['floors'] as List).cast<Map<String, dynamic>>()) {
        floorCount++;
        final reference = FloorGeoreference.fromJson(floor);
        final metadata = MapFloorData.fromJson(floor, svgPath: 'test.svg');
        expect(metadata.georeference!.status, 'approximate');
        expect(metadata.georeference!.sources.length, greaterThanOrEqualTo(2));
        expect(
          metadata.georeference!.sources.every((source) => source.link != null),
          isTrue,
        );
        for (final fraction in [0.0, .3, .7, 1.0]) {
          final x = metadata.width * fraction;
          final y = metadata.height * (1 - fraction);
          final geographic = reference.pixelToGeographic(x, y);
          expect(
            (geographic.latitude - (campus['latitude'] as num)).abs(),
            lessThan(.02),
          );
          expect(
            (geographic.longitude - (campus['longitude'] as num)).abs(),
            lessThan(.02),
          );
          final original = reference.geographicToPixel(
            geographic.latitude,
            geographic.longitude,
          );
          expect(original.x, closeTo(x, 1e-5));
          expect(original.y, closeTo(y, 1e-5));
        }
      }
    }
    expect(floorCount, 23);
  });

  test('V86 detached block is clipped while source room metadata survives', () {
    final campus = _campus('v-86');
    final floor = (campus['floors'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((floor) => floor['level'] == 1);
    final metadata = MapFloorData.fromJson(floor, svgPath: 'test.svg');
    final quality = metadata.georeference!;
    final region = quality.excludedRegions.single;
    final path = MapGeoreferenceClipper(
      quality.excludedRegions,
    ).getClip(Size(metadata.width, metadata.height));
    final hiddenRooms = (campus['rooms'] as List)
        .cast<Map<String, dynamic>>()
        .where(
          (room) =>
              room['floor_id'] == floor['id'] &&
              region.contains(
                (room['x'] as num).toDouble(),
                (room['y'] as num).toDouble(),
              ),
        )
        .toList();
    expect(hiddenRooms, isNotEmpty);
    for (final room in hiddenRooms) {
      final x = (room['x'] as num).toDouble();
      final y = (room['y'] as num).toDouble();
      expect(quality.isReliableAt(x, y), isFalse);
      expect(path.contains(Offset(x, y)), isFalse);
    }
    expect(
      path.contains(Offset(metadata.width * .75, metadata.height * .75)),
      isTrue,
    );
  });

  testWidgets('geographic disclosure fits 320px with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final quality = MapGeoreferenceData.fromJson({
      'status': 'approximate',
      'summary':
          'Привязка по контуру здания. Точность на местности не измерена.',
      'limitations': ['Отдельный блок скрыт на городской карте.'],
      'sources': [
        {
          'label': 'Контур OpenStreetMap',
          'url': 'https://www.openstreetmap.org/relation/7331729',
        },
      ],
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: MapGeographicView(
          campusName: 'В-86',
          center: const LatLng(55.661, 37.477),
          floorPlan: GeographicFloorPlan(
            svg:
                '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0H100V100H0Z"/></svg>',
            size: const Size(100, 100),
            topLeft: const LatLng(55.662, 37.476),
            topRight: const LatLng(55.662, 37.478),
            bottomLeft: const LatLng(55.660, 37.476),
            georeference: quality,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Привязка приблизительная'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(quality.summary), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(FlutterMap)).height,
      greaterThanOrEqualTo(220),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

Map<String, dynamic> _campus(String id) =>
    jsonDecode(
          File(
            'packages/app_ui/assets/maps/pulse/campus_$id.json',
          ).readAsStringSync(),
        )
        as Map<String, dynamic>;
