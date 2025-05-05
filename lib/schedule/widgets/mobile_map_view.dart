import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Creates a map view for mobile platforms using OpenStreetMap
Widget createMapView({required double latitude, required double longitude}) {
  final mapController = MapController();
  final markerLocation = LatLng(latitude, longitude);

  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      initialCenter: markerLocation,
      initialZoom: 16.0,
      onTap: (tapPosition, tapPoint) {
        launchUrlString('https://www.openstreetmap.org/?mlat=${tapPoint.latitude}&mlon=${tapPoint.longitude}&zoom=16');
      },
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'ru.mirea.app',
        maxZoom: 19,
      ),
      MarkerLayer(
        markers: [
          Marker(
            width: 40.0,
            height: 40.0,
            point: markerLocation,
            child: const Icon(Icons.location_on, color: Colors.red, size: 40.0),
          ),
        ],
      ),
    ],
  );
}
