import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/widgets/map_structure_layer.dart';
import 'package:xml/xml.dart';

List<XmlElement> _elements(String svg, String tag) => XmlDocument.parse(svg)
    .descendants
    .whereType<XmlElement>()
    .where((element) => element.name.local == tag)
    .toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preserves structure and transforms while separating door openings', () {
    const svg = '''
    <svg viewBox="0 0 100 100">
      <rect width="100" height="100" fill="white" />
      <rect id="outline" width="100" height="100" fill="none" stroke="black" />
      <defs><clipPath id="clip"><path d="M0 0L100 0L100 100Z" /></clipPath></defs>
      <g transform="translate(10 20)" clip-path="url(#clip)">
        <path id="corridor" d="M0 0L50 0L50 20Z" />
        <g data-object="room"><path id="room-path" d="M0 0L10 0L10 10Z" />
          <line id="room-line" x1="0" y1="0" x2="10" y2="0" /></g>
        <g transform="scale(2)"><line id="door" stroke-width="3" x1="2" y1="3" x2="4" y2="5" /></g>
        <ellipse id="sign" cx="20" cy="10" rx="2" ry="3" />
      </g>
    </svg>''';
    final split = MapStructureLayers.fromSvg(svg);
    expect(
      _elements(
        split.foundation,
        'rect',
      ).map((element) => element.getAttribute('id')),
      ['outline'],
    );
    expect(
      _elements(
        split.foundation,
        'path',
      ).map((element) => element.getAttribute('id')),
      [null, 'corridor'],
    );
    expect(split.foundation, isNot(contains('room-path')));
    expect(split.openings, isNot(contains('room-line')));
    expect(_elements(split.foundation, 'line'), isEmpty);
    expect(_elements(split.foundation, 'ellipse'), hasLength(1));
    final door = _elements(split.openings, 'line').single;
    expect(door.getAttribute('stroke-width'), '3');
    expect(door.parentElement?.getAttribute('transform'), 'scale(2)');
    expect(
      door.parentElement?.parentElement?.getAttribute('transform'),
      'translate(10 20)',
    );
    expect(
      door.parentElement?.parentElement?.getAttribute('clip-path'),
      'url(#clip)',
    );
    expect(_elements(split.openings, 'clipPath'), hasLength(1));
    expect(identical(split, MapStructureLayers.fromSvg(svg)), isTrue);
    expect(split.foundationShapes, hasLength(3));
    expect(
      split.openingShapes.single.path.getBounds(),
      const Rect.fromLTRB(14, 26, 18, 30),
    );
    expect(split.openingShapes.single.clips, hasLength(1));
    expect(
      split.foundationShapes[1].clips.single.contains(const Offset(12, 22)),
      isTrue,
    );
  });

  test('cached paths retain evenodd holes, clipping and rounded corners', () {
    const svg = '''
    <svg viewBox="10 20 100 100">
      <defs><clipPath id="ring" clip-rule="evenodd">
        <path d="M0 0H100V100H0Z M30 30H70V70H30Z"/>
      </clipPath></defs>
      <g transform="translate(10 20)" fill-rule="evenodd" opacity=".5">
        <path d="M0 0H100V100H0Z M30 30H70V70H30Z"/>
        <rect x="0" y="0" width="100" height="100" rx="12"
          clip-path="url(#ring)"/>
      </g>
    </svg>''';
    final layers = MapStructureLayers.fromSvg(svg);
    final ring = layers.foundationShapes.first;
    expect(ring.path.fillType, PathFillType.evenOdd);
    expect(ring.path.contains(const Offset(20, 20)), isTrue);
    expect(ring.path.contains(const Offset(50, 50)), isFalse);
    expect(ring.fillOpacity, .5);
    final rectangle = layers.foundationShapes.last;
    expect(rectangle.path.contains(Offset.zero), isFalse);
    expect(rectangle.path.contains(const Offset(50, 50)), isTrue);
    expect(rectangle.clips.single.contains(const Offset(50, 50)), isFalse);
    expect(rectangle.clips.single.contains(const Offset(20, 20)), isTrue);
    expect(
      identical(
        layers.foundationShapes,
        MapStructureLayers.fromSvg(svg).foundationShapes,
      ),
      isTrue,
    );
  });

  test(
    'retains all non-room paths and door lines on the 17 actual Pulse floors',
    () async {
      var count = 0;
      var structuralPaths = 0;
      var doors = 0;
      for (final campus in ['v-78', 'v-86', 's-20']) {
        final data =
            jsonDecode(
                  await rootBundle.loadString(
                    'packages/app_ui/assets/maps/pulse/campus_$campus.json',
                  ),
                )
                as Map<String, dynamic>;
        for (final floor in data['floors'] as List<dynamic>) {
          final json = floor as Map<String, dynamic>;
          final svg = json['svg'] as String;
          bool outsideRoom(XmlElement element) => !element.ancestors
              .whereType<XmlElement>()
              .any((ancestor) => ancestor.getAttribute('data-object') != null);
          final paths = _elements(svg, 'path').where(outsideRoom).toList();
          final lines = _elements(svg, 'line').where(outsideRoom).toList();
          final split = MapStructureLayers.fromSvg(svg);
          final context = '$campus floor ${json['level']}';
          expect(
            _elements(
              split.foundation,
              'path',
            ).map((element) => element.getAttribute('d')),
            paths.map((element) => element.getAttribute('d')),
            reason: context,
          );
          expect(
            _elements(
              split.openings,
              'line',
            ).map((element) => element.toXmlString()),
            lines.map((element) => element.toXmlString()),
            reason: context,
          );
          expect(
            split.foundation,
            isNot(contains('data-object=')),
            reason: context,
          );
          expect(
            split.openings,
            isNot(contains('data-object=')),
            reason: context,
          );
          expect(_elements(split.foundation, 'line'), isEmpty, reason: context);
          expect(split.foundationShapes.length, paths.length, reason: context);
          expect(split.openingShapes.length, lines.length, reason: context);
          count++;
          structuralPaths += paths.length;
          doors += lines.length;
        }
      }
      expect(count, 17);
      expect(structuralPaths, greaterThan(1000));
      expect(doors, greaterThan(2000));
    },
  );
}
