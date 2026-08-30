import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:network_location_client/src/failures.dart';
import 'package:network_location_client/src/models/models.dart';
import 'package:wifi_scan/wifi_scan.dart';

typedef WifiApScanner = Future<List<WifiAccessPointReading>> Function();

class NetworkLocationClient {
  NetworkLocationClient({
    http.Client? httpClient,
    Uri? geolocateEndpoint,
    WifiApScanner? scanner,
    String userAgent = 'university-app',
  }) : _http = httpClient ?? http.Client(),
       _endpoint =
           geolocateEndpoint ??
           Uri.parse('https://api.beacondb.net/v1/geolocate'),
       _scanner = scanner,
       _userAgent = userAgent;

  final http.Client _http;
  final Uri _endpoint;
  final WifiApScanner? _scanner;
  final String _userAgent;

  static const minAccessPoints = 2;

  static const maxAccessPoints = 40;

  Future<List<WifiAccessPointReading>> scanAccessPoints() async {
    final scanner = _scanner;
    if (scanner != null) return scanner();
    try {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) return const [];
      final results = await WiFiScan.instance.getScannedResults();
      return [
            for (final ap in results)
              if (!ap.ssid.endsWith('_nomap'))
                WifiAccessPointReading(
                  bssid: ap.bssid.toLowerCase(),
                  rssi: ap.level,
                ),
          ]
          .where((r) => r.isValidBssid && !r.isLocallyAdministered)
          .toList(growable: false);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(WifiScanFailure(error), stackTrace);
    }
  }

  Future<NetworkLocationEstimate?> geolocate(
    List<WifiAccessPointReading> accessPoints,
  ) async {
    if (accessPoints.length < minAccessPoints) return null;
    try {
      final response = await _http.post(
        _endpoint,
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': _userAgent,
        },
        body: jsonEncode({
          'wifiAccessPoints': [
            for (final ap in accessPoints.take(maxAccessPoints))
              {'macAddress': ap.bssid, 'signalStrength': ap.rssi},
          ],
        }),
      );
      if (response.statusCode == 404) return null;
      if (response.statusCode != 200) {
        throw http.ClientException(
          'Unexpected status ${response.statusCode}',
          _endpoint,
        );
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final location = json['location'] as Map<String, dynamic>?;
      final latitude = (location?['lat'] as num?)?.toDouble();
      final longitude = (location?['lng'] as num?)?.toDouble();
      final accuracyM = (json['accuracy'] as num?)?.toDouble();
      if (latitude == null ||
          longitude == null ||
          !latitude.isFinite ||
          !longitude.isFinite) {
        return null;
      }
      return NetworkLocationEstimate(
        latitude: latitude,
        longitude: longitude,
        accuracyM: (accuracyM != null && accuracyM.isFinite) ? accuracyM : 100,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GeolocateFailure(error), stackTrace);
    }
  }

  void close() => _http.close();
}
