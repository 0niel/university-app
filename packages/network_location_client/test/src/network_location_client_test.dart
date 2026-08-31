import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:network_location_client/network_location_client.dart';

import 'test_http_client.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('WifiAccessPointReading', () {
    test('isValidBssid accepts canonical and rejects garbage', () {
      const valid = WifiAccessPointReading(
        bssid: '00:11:22:33:44:55',
        rssi: -50,
      );
      const invalid = WifiAccessPointReading(bssid: 'не-mac', rssi: -50);

      expect(valid.isValidBssid, isTrue);
      expect(invalid.isValidBssid, isFalse);
    });

    test('isLocallyAdministered detects randomized MACs', () {
      const randomized = WifiAccessPointReading(
        bssid: '02:11:22:33:44:55',
        rssi: -50,
      );
      const universal = WifiAccessPointReading(
        bssid: '00:11:22:33:44:55',
        rssi: -50,
      );

      expect(randomized.isLocallyAdministered, isTrue);
      expect(universal.isLocallyAdministered, isFalse);
    });

    test('toJson matches the RPC contract', () {
      const reading = WifiAccessPointReading(
        bssid: '00:11:22:33:44:55',
        rssi: -62,
      );

      expect(reading.toJson(), {'bssid': '00:11:22:33:44:55', 'rssi': -62});
    });

    test('round-trips the RPC contract through JSON', () {
      final reading = WifiAccessPointReading.fromJson({
        'bssid': '00:11:22:33:44:55',
        'rssi': -62,
      });

      expect(
        reading,
        const WifiAccessPointReading(
          bssid: '00:11:22:33:44:55',
          rssi: -62,
        ),
      );
    });
  });

  group('NetworkLocationClient', () {
    late http.Client httpClient;
    late NetworkLocationClient client;

    const aps = [
      WifiAccessPointReading(bssid: '00:11:22:33:44:55', rssi: -50),
      WifiAccessPointReading(bssid: '00:11:22:33:44:66', rssi: -70),
    ];

    setUp(() {
      httpClient = TestHttpClient();
      client = NetworkLocationClient(httpClient: httpClient);
    });

    group('scanAccessPoints', () {
      test('uses the injected scanner', () async {
        final scanning = NetworkLocationClient(
          httpClient: httpClient,
          scanner: () async => aps,
        );

        expect(await scanning.scanAccessPoints(), aps);
      });
    });

    group('geolocate', () {
      test('uses a neutral default user agent', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            '{"location":{"lat":55.6699,"lng":37.4803}}',
            200,
          ),
        );

        await client.geolocate(aps);

        verify(
          () => httpClient.post(
            any(),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'university-app',
            },
            body: any(named: 'body'),
          ),
        ).called(1);
      });

      test('returns null without a request when fewer than two APs', () async {
        final estimate = await client.geolocate(aps.take(1).toList());

        expect(estimate, isNull);
        verifyNever(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        );
      });

      test('parses a successful MLS response', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            '{"location":{"lat":55.6699,"lng":37.4803},"accuracy":48.5}',
            200,
          ),
        );

        final estimate = await client.geolocate(aps);

        expect(
          estimate,
          const NetworkLocationEstimate(
            latitude: 55.6699,
            longitude: 37.4803,
            accuracyM: 48.5,
          ),
        );
      });

      test('returns null when the service answers 404 (not found)', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response('{"error":{"code":404}}', 404),
        );

        expect(await client.geolocate(aps), isNull);
      });

      test('throws GeolocateFailure on an unexpected status', () {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) => Future.value(http.Response('oops', 500)));

        expect(
          () => client.geolocate(aps),
          throwsA(isA<GeolocateFailure>()),
        );
      });

      test('throws GeolocateFailure on a malformed body', () {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) => Future.value(http.Response('not-json', 200)));

        expect(
          () => client.geolocate(aps),
          throwsA(isA<GeolocateFailure>()),
        );
      });

      test('returns null when coordinates are missing or non-finite', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response('{"location":{},"accuracy":10}', 200),
        );

        expect(await client.geolocate(aps), isNull);
      });
    });
  });
}
