import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/map.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SvgRoomParser', () {
    test(
      'preserves inherited evenodd holes and unions separate room shapes',
      () async {
        final parser = SvgRoomParser(
          onLoadSvg: (_) async => '''
        <svg viewBox="0 0 100 100" fill-rule="evenodd">
          <g data-object="ring" transform="translate(10 10)">
            <path d="M0 0H40V40H0Z M10 10H30V30H10Z" />
          </g>
          <g data-object="combined">
            <path d="M50 0H90V40H50Z M60 10H80V30H60Z" />
            <rect x="65" y="15" width="10" height="10" />
          </g>
        </svg>
      ''',
        );
        final (rooms, _) = await parser.parseSvg('rings.svg');
        final ring = rooms.first.path;
        expect(ring.fillType, PathFillType.evenOdd);
        expect(ring.contains(const Offset(15, 15)), isTrue);
        expect(ring.contains(const Offset(30, 30)), isFalse);
        final combined = rooms.last.path;
        expect(combined.contains(const Offset(55, 5)), isTrue);
        expect(combined.contains(const Offset(62, 12)), isFalse);
        expect(combined.contains(const Offset(70, 20)), isTrue);
      },
    );

    test('includes transforms above a labelled room element', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
        <svg viewBox="0 0 100 100">
          <g transform="translate(10 20)"><g transform="scale(2)">
            <rect data-object="room" data-name="А-101" x="1" y="2" width="3" height="4" />
          </g></g>
        </svg>
      ''',
      );
      final (rooms, _) = await parser.parseSvg('remote.svg');
      expect(rooms.single.name, 'А-101');
      expect(rooms.single.path.getBounds(), const Rect.fromLTWH(12, 24, 6, 8));
    });

    test('parses direct and nested room shapes', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
          <svg viewBox="0 0 100 100">
            <rect data-object="direct" x="10" y="20" width="30" height="40" />
            <g data-object="nested">
              <circle cx="50" cy="50" r="5" />
            </g>
          </svg>
        ''',
      );

      final (rooms, bounds) = await parser.parseSvg('floor.svg');

      expect(rooms.map((room) => room.roomId), ['direct', 'nested']);
      expect(bounds, const Rect.fromLTWH(0, 0, 100, 100));
      expect(rooms.map((room) => room.path.getBounds()), [
        const Rect.fromLTWH(10, 20, 30, 40),
        const Rect.fromLTWH(45, 45, 10, 10),
      ]);
    });

    test('applies group and shape transforms', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
          <svg viewBox="0 0 1 1">
            <g data-object="room" transform="translate(10 20)">
              <rect width="2" height="3" transform="scale(2)" />
            </g>
          </svg>
        ''',
      );

      final (rooms, bounds) = await parser.parseSvg('floor.svg');

      expect(rooms, hasLength(1));
      expect(rooms.map((room) => room.path.getBounds()), [
        const Rect.fromLTWH(10, 20, 4, 6),
      ]);
      expect(bounds, const Rect.fromLTWH(0, 0, 14, 26));
    });

    test('applies a direct room-shape transform exactly once', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
          <svg viewBox="0 0 1 1">
            <rect
              data-object="room"
              width="2"
              height="3"
              transform="translate(10 20)"
            />
          </svg>
        ''',
      );

      final (rooms, _) = await parser.parseSvg('floor.svg');

      expect(rooms.map((room) => room.path.getBounds()), [
        const Rect.fromLTWH(10, 20, 2, 3),
      ]);
    });

    test('composes transforms from intermediate groups', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
          <svg viewBox="0 0 1 1">
            <g data-object="room" transform="translate(10 20)">
              <g transform="scale(2)">
                <rect x="1" y="2" width="3" height="4" />
              </g>
            </g>
          </svg>
        ''',
      );

      final (rooms, _) = await parser.parseSvg('floor.svg');

      expect(rooms.map((room) => room.path.getBounds()), [
        const Rect.fromLTWH(12, 24, 6, 8),
      ]);
    });

    test('supports skew transforms used by floor-plan assets', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '''
          <svg viewBox="0 0 1 1">
            <rect
              data-object="room"
              y="2"
              width="1"
              height="1"
              transform="skewX(45)"
            />
          </svg>
        ''',
      );

      final (rooms, _) = await parser.parseSvg('floor.svg');
      final bounds = switch (rooms) {
        [final room] => room.path.getBounds(),
        _ => throw StateError('Expected exactly one room'),
      };

      expect(bounds.left, closeTo(2, 0.000001));
      expect(bounds.top, closeTo(2, 0.000001));
      expect(bounds.width, closeTo(2, 0.000001));
      expect(bounds.height, closeTo(1, 0.000001));
    });

    test('parses a whitespace-wrapped viewBox', () async {
      final parser = SvgRoomParser(
        onLoadSvg: (_) async => '<svg viewBox="  -5 -6 100 200  " />',
      );

      final (_, bounds) = await parser.parseSvg('floor.svg');

      expect(bounds, const Rect.fromLTWH(-5, -6, 100, 200));
    });

    test(
      'keeps finite bounds when rooms contain no supported geometry',
      () async {
        final parser = SvgRoomParser(
          onLoadSvg: (_) async => '''
          <svg viewBox="10 20 300 400">
            <g data-object="empty"><text>Room</text></g>
          </svg>
        ''',
        );

        final (rooms, bounds) = await parser.parseSvg('floor.svg');

        expect(rooms, hasLength(1));
        expect(rooms.map((room) => room.path.getBounds().isEmpty), [isTrue]);
        expect(bounds, const Rect.fromLTWH(10, 20, 300, 400));
      },
    );

    test('rejects a document without an SVG root', () async {
      final parser = SvgRoomParser(onLoadSvg: (_) async => '<html />');

      await expectLater(
        parser.parseSvg('floor.svg'),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            'SVG document has no root element',
          ),
        ),
      );
    });

    test(
      'parses every configured floor-plan asset into finite rooms',
      () async {
        const parser = SvgRoomParser();
        var totalRooms = 0;

        for (final campus in CampusesConfig.campuses) {
          for (final floor in campus.floors) {
            final (rooms, bounds) = await parser.parseSvg(floor.svgPath);
            final context = '${campus.id} floor ${floor.number}';
            totalRooms += rooms.length;

            expect(
              [
                bounds.left,
                bounds.top,
                bounds.width,
                bounds.height,
              ].every((value) => value.isFinite),
              isTrue,
              reason: context,
            );
            expect(
              rooms.every((room) {
                final roomBounds = room.path.getBounds();
                return !roomBounds.isEmpty &&
                    roomBounds.left.isFinite &&
                    roomBounds.top.isFinite &&
                    roomBounds.width.isFinite &&
                    roomBounds.height.isFinite;
              }),
              isTrue,
              reason: context,
            );
          }
        }

        expect(totalRooms, greaterThan(0));
      },
    );
  });
}
