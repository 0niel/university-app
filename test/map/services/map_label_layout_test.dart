import 'dart:math';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/services/map_label_layout.dart';

void main() {
  group('placeMapLabels', () {
    test('keeps higher priority labels and orders equal priorities by id', () {
      final placed = placeMapLabels([
        _label('low', 0, 0, priority: 1),
        _label('z', 100, 0, priority: 2),
        _label('a', 200, 0, priority: 2),
        _label('high', 0, 0, priority: 3),
      ]);
      expect(placed.map((label) => label.id), ['high', 'a', 'z']);
    });

    test('inflates both labels and permits edges that only touch', () {
      final placed = placeMapLabels([
        _label('a', 0, 0),
        _label('b', 27, 0),
        _label('c', 28, 0),
      ]);
      expect(placed.map((label) => label.id), ['a', 'c']);
      expect(
        placed[0].bounds.inflate(4).overlaps(placed[1].bounds.inflate(4)),
        isFalse,
      );
    });

    test(
      'detects overlap across spatial cell boundaries and negative cells',
      () {
        final placed = placeMapLabels([
          _label('a', 63, 63),
          _label('b', 66, 66),
          _label('c', -63, -63),
          _label('d', -66, -66),
        ]);
        expect(placed.map((label) => label.id), ['a', 'c']);
      },
    );

    test('dense input matches deterministic brute-force placement', () {
      final random = Random(712);
      final candidates = List.generate(
        3000,
        (index) => _label(
          'label-${index.toString().padLeft(4, '0')}',
          random.nextDouble() * 1600 - 800,
          random.nextDouble() * 900 - 450,
          priority: random.nextInt(8),
          size: Size(
            10 + random.nextDouble() * 70,
            8 + random.nextDouble() * 15,
          ),
        ),
      );
      final expected = _bruteForce(candidates, gap: 3);
      final actual = placeMapLabels(candidates, gap: 3);
      final reordered = placeMapLabels(candidates.reversed, gap: 3);

      expect(actual.length, greaterThan(100));
      expect(
        actual.map((label) => label.id),
        expected.map((label) => label.id),
      );
      expect(
        reordered.map((label) => label.id),
        actual.map((label) => label.id),
      );
    });

    test('bounds grid growth for unusually large labels', () {
      final placed = placeMapLabels([
        _label(
          'large',
          0,
          0,
          priority: 5,
          size: const Size(1000000000, 1000000000),
        ),
        _label('covered', 10000, 10000),
        _label('outside', 1000000000, 1000000000),
      ]);
      expect(placed.map((label) => label.id), ['large', 'outside']);

      final smallerFirst = placeMapLabels([
        _label('small', 0, 0, priority: 5),
        _label('large', 0, 0, size: const Size(1000000000, 1000000000)),
      ]);
      expect(smallerFirst.map((label) => label.id), ['small']);
      expect(
        placeMapLabels([
          _label('enormous', 0, 0, size: const Size(1e300, 1e300)),
          _label('inside', 0, 0),
        ]).map((label) => label.id),
        ['enormous'],
      );
    });

    test('skips invalid geometry and places an id at most once', () {
      final placed = placeMapLabels([
        _label('nan', double.nan, 0),
        _label('infinite', 0, 0, size: const Size(double.infinity, 10)),
        _label('empty', 0, 0, size: Size.zero),
        _label('negative', 0, 0, size: const Size(-1, 10)),
        _label('duplicate', 100, 0),
        _label('duplicate', 0, 0, priority: 2),
      ]);
      expect(placed, hasLength(1));
      expect(placed.single.anchor, Offset.zero);
      expect(() => placeMapLabels([], gap: -1), throwsArgumentError);
      expect(() => placeMapLabels([], gap: double.nan), throwsArgumentError);
    });
  });

  group('mapInteriorLabelAnchor', () {
    test('uses the bounding center when the room contains it', () {
      final path = Path()..addRect(const Rect.fromLTWH(10, 20, 80, 60));
      expect(mapInteriorLabelAnchor(path), const Offset(50, 50));
    });

    test('finds an interior anchor for a concave L-shaped room', () {
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(100, 0)
        ..lineTo(100, 20)
        ..lineTo(20, 20)
        ..lineTo(20, 100)
        ..lineTo(0, 100)
        ..close();
      expect(path.contains(path.getBounds().center), isFalse);
      final anchor = mapInteriorLabelAnchor(path);
      expect(anchor, isNotNull);
      expect(path.contains(anchor!), isTrue);
      expect(anchor.dx < 20 || anchor.dy < 20, isTrue);
    });

    test('keeps the label out of an even-odd interior hole', () {
      final path = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(const Rect.fromLTWH(0, 0, 100, 100))
        ..addRect(const Rect.fromLTWH(25, 25, 50, 50));
      final anchor = mapInteriorLabelAnchor(path);
      expect(anchor, isNotNull);
      expect(path.contains(anchor!), isTrue);
      expect(const Rect.fromLTWH(25, 25, 50, 50).contains(anchor), isFalse);
    });

    test(
      'chooses a roomy component instead of the gap between separate parts',
      () {
        final path = Path()
          ..addRect(const Rect.fromLTWH(0, 0, 8, 8))
          ..addRect(const Rect.fromLTWH(120, 120, 50, 50));
        final anchor = mapInteriorLabelAnchor(path);
        expect(anchor, isNotNull);
        expect(path.contains(anchor!), isTrue);
        expect(const Rect.fromLTWH(120, 120, 50, 50).contains(anchor), isTrue);
      },
    );

    test('finds tiny isolated components missed by a global grid', () {
      final path = Path()
        ..addRect(const Rect.fromLTWH(0, 0, 0.1, 0.1))
        ..addRect(const Rect.fromLTWH(1000, 1000, 0.2, 0.2));
      final anchor = mapInteriorLabelAnchor(path);
      expect(anchor, isNotNull);
      expect(path.contains(anchor!), isTrue);
    });

    test('supports curved room boundaries with an interior hole', () {
      final path = Path()
        ..fillType = PathFillType.evenOdd
        ..addOval(const Rect.fromLTWH(-100, -100, 200, 200))
        ..addOval(const Rect.fromLTWH(-70, -70, 140, 140));
      final anchor = mapInteriorLabelAnchor(path);
      expect(anchor, isNotNull);
      expect(path.contains(anchor!), isTrue);
    });

    test('returns null for empty paths and zero-area geometry', () {
      expect(mapInteriorLabelAnchor(Path()), isNull);
      expect(
        mapInteriorLabelAnchor(Path()..addRect(Rect.zero)),
        isNull,
      );
      expect(
        mapInteriorLabelAnchor(
          Path()
            ..moveTo(0, 0)
            ..lineTo(100, 100),
        ),
        isNull,
      );
    });
  });
}

MapLabelCandidate _label(
  String id,
  double x,
  double y, {
  int priority = 0,
  Size size = const Size(20, 10),
}) => MapLabelCandidate(
  id: id,
  anchor: Offset(x, y),
  size: size,
  priority: priority,
);

List<MapLabelCandidate> _bruteForce(
  List<MapLabelCandidate> candidates, {
  required double gap,
}) {
  final ordered = [...candidates]
    ..sort((a, b) {
      final comparison = b.priority.compareTo(a.priority);
      return comparison == 0 ? a.id.compareTo(b.id) : comparison;
    });
  final accepted = <MapLabelCandidate>[];
  for (final candidate in ordered) {
    final bounds = candidate.bounds.inflate(gap);
    if (!accepted.any((item) => item.bounds.inflate(gap).overlaps(bounds))) {
      accepted.add(candidate);
    }
  }
  return accepted;
}
