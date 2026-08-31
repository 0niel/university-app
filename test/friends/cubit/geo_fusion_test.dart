import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/friends/cubit/geo_fusion.dart';

void main() {
  // МИРЭА, проспект Вернадского 78.
  const baseLat = 55.6699;
  const baseLng = 37.4803;
  final t0 = DateTime(2026, 6, 12, 12);

  GeoFix fix({
    double latitude = baseLat,
    double longitude = baseLng,
    double accuracyM = 10,
    int dtSeconds = 0,
    double? speedMps,
  }) => GeoFix(
    latitude: latitude,
    longitude: longitude,
    accuracyM: accuracyM,
    timestamp: t0.add(Duration(seconds: dtSeconds)),
    speedMps: speedMps,
  );

  group('GeoFusionFilter', () {
    test('seeds the estimate with the first finite fix', () {
      final filter = GeoFusionFilter();

      final estimate = filter.add(fix(accuracyM: 25));

      expect(estimate, isNotNull);
      expect(estimate!.latitude, baseLat);
      expect(estimate.longitude, baseLng);
      expect(estimate.accuracyM, 25);
    });

    test('rejects non-finite coordinates and keeps the previous estimate', () {
      final filter = GeoFusionFilter()..add(fix());

      final rejected = filter.add(
        fix(latitude: double.nan, longitude: double.nan, dtSeconds: 5),
      );

      expect(rejected, isNull);
      expect(filter.estimate!.latitude, baseLat);
    });

    test('rejects fixes older than the current estimate', () {
      final filter = GeoFusionFilter()..add(fix(dtSeconds: 10));

      expect(filter.add(fix(dtSeconds: 5)), isNull);
    });

    test('weights fixes by accuracy: precise pulls, coarse barely moves', () {
      // ~111 м к северу от базовой точки.
      const shiftedLat = baseLat + 0.001;

      final coarse = GeoFusionFilter()..add(fix());
      final coarseEstimate = coarse.add(
        fix(latitude: shiftedLat, accuracyM: 300, dtSeconds: 5),
      );

      final precise = GeoFusionFilter()..add(fix());
      final preciseEstimate = precise.add(
        fix(latitude: shiftedLat, accuracyM: 5, dtSeconds: 5),
      );

      final coarseShift = coarseEstimate!.latitude - baseLat;
      final preciseShift = preciseEstimate!.latitude - baseLat;
      expect(coarseShift, lessThan(0.0002));
      expect(preciseShift, greaterThan(0.0007));
    });

    test('repeated consistent fixes shrink the uncertainty', () {
      final filter = GeoFusionFilter();
      final first = filter.add(fix(accuracyM: 50));

      GeoFix? last;
      for (var i = 1; i <= 5; i++) {
        last = filter.add(fix(accuracyM: 50, dtSeconds: i * 5));
      }

      expect(last!.accuracyM, lessThan(first!.accuracyM));
    });

    test('rejects a single teleport (network-provider glitch)', () {
      final filter = GeoFusionFilter()..add(fix());

      // Скачок на ~11 км за 1 секунду.
      final rejected = filter.add(
        fix(latitude: baseLat + 0.1, accuracyM: 50, dtSeconds: 1),
      );

      expect(rejected, isNull);
      expect(filter.estimate!.latitude, baseLat);
    });

    test('accepts a relocation after a streak of consistent far fixes', () {
      final filter = GeoFusionFilter()..add(fix());
      const farLat = baseLat + 0.1;

      expect(filter.add(fix(latitude: farLat, dtSeconds: 1)), isNull);
      expect(filter.add(fix(latitude: farLat, dtSeconds: 2)), isNull);
      final accepted = filter.add(fix(latitude: farLat, dtSeconds: 3));

      expect(accepted, isNotNull);
      expect(accepted!.latitude, farLat);
    });

    test('distanceMeters: 0.001° широты ≈ 111 м', () {
      final d = GeoFusionFilter.distanceMeters(
        baseLat,
        baseLng,
        baseLat + 0.001,
        baseLng,
      );

      expect(d, closeTo(111, 2));
    });
  });
}
