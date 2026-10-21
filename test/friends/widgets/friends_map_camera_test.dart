import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rtu_mirea_app/friends/utils/friends_map_camera.dart';

void main() {
  testWidgets('an immediate camera move cancels the previous animated target', (
    tester,
  ) async {
    final controller = MapController();
    final camera = FriendsMapCamera(controller, vsync: tester);
    addTearDown(controller.dispose);
    addTearDown(camera.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: FlutterMap(
          mapController: controller,
          options: const MapOptions(
            initialCenter: LatLng(55.67, 37.48),
            initialZoom: 15,
          ),
          children: const [],
        ),
      ),
    );
    camera.focusOn(55.68, 37.49, animate: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    camera.focusOn(55.69, 37.50, animate: false);
    await tester.pump(const Duration(seconds: 1));
    expect(controller.camera.center, const LatLng(55.69, 37.50));
    expect(controller.camera.zoom, FriendsMapCamera.focusZoom);
    expect(tester.takeException(), isNull);
  });
}
