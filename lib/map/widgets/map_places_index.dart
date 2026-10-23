import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/services/room_key.dart';
import 'package:rtu_mirea_app/map/widgets/map_place_kind.dart';

class MapPlacesIndex {
  MapPlacesIndex(CampusMapData campus)
    : _campusId = campus.campus.id,
      _rooms = List.of(campus.rooms),
      _floors = List.of(campus.floors),
      _floorNumbers = {
        for (final floor in campus.floors) floor.floor.id: floor.floor.number,
      } {
    final groups = <(String, String, String, String), MapPlaceEntry>{};
    for (final place in _rooms) {
      final label = roomKey(place.label);
      final category = mapPlaceKindLabel(place.kind);
      final separateService =
          category != 'Аудитория' &&
          (category != 'Сервис' || _metadataScore(place) > 0);
      final position = separateService
          ? '${place.x.toStringAsFixed(2)},${place.y.toStringAsFixed(2)}'
          : '';
      final key = (place.floorId, place.kind, label, position);
      final floor = _floorNumbers[place.floorId];
      final search = roomKey(
        [
          place.label,
          category,
          place.description ?? '',
          if (floor != null) '$floor этаж',
          ...place.equipment,
        ].join(' '),
      );
      final existing = groups[key];
      final richest =
          existing == null ||
              _metadataScore(place) > _metadataScore(existing.place)
          ? place
          : existing.place;
      groups[key] = MapPlaceEntry(
        place: richest,
        category: category,
        floor: floor,
        search: existing == null ? search : '${existing.search} $search',
      );
    }
    _entries = groups.values.toList(growable: false);
    kinds = _entries.map((entry) => entry.category).toSet().toList()..sort();
    for (final entry in _entries) {
      _floorCounts.update(
        entry.place.floorId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
  }

  final String _campusId;
  final List<MapPlaceData> _rooms;
  final List<MapFloorData> _floors;
  final Map<String, int> _floorNumbers;
  final _floorCounts = <String, int>{};
  late final List<MapPlaceEntry> _entries;
  late final List<String> kinds;
  (String, String?, String?, bool)? _selection;
  List<MapPlaceEntry> _results = const [];

  bool matches(CampusMapData campus) =>
      _campusId == campus.campus.id &&
      listEquals(_rooms, campus.rooms) &&
      listEquals(_floors, campus.floors);

  int countOnFloor(String? id) => _floorCounts[id] ?? 0;

  List<MapPlaceEntry> select({
    required String query,
    required String? category,
    required String? currentFloorId,
    required bool onlyCurrentFloor,
  }) {
    final selection = (query, category, currentFloorId, onlyCurrentFloor);
    if (_selection == selection) return _results;
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .map(roomKey)
        .where((token) => token.isNotEmpty)
        .toList();
    final exact = roomKey(query);
    final floorKnown = _floorNumbers.containsKey(currentFloorId);
    final results =
        _entries.where((entry) {
          if (category != null && entry.category != category) return false;
          if (onlyCurrentFloor &&
              floorKnown &&
              entry.place.floorId != currentFloorId) {
            return false;
          }
          return tokens.every(entry.search.contains);
        }).toList()..sort((a, b) {
          final exactA = exact.isNotEmpty && a.label == exact;
          final exactB = exact.isNotEmpty && b.label == exact;
          if (exactA != exactB) return exactA ? -1 : 1;
          final currentA = a.place.floorId == currentFloorId;
          final currentB = b.place.floorId == currentFloorId;
          if (currentA != currentB) return currentA ? -1 : 1;
          final labelOrder = _compareNatural(a.parts, b.parts);
          if (labelOrder != 0) return labelOrder;
          final floorOrder = (a.floor ?? 0).compareTo(b.floor ?? 0);
          if (floorOrder != 0) return floorOrder;
          return a.place.id.compareTo(b.place.id);
        });
    _selection = selection;
    return _results = List.unmodifiable(results);
  }
}

class MapPlaceEntry {
  MapPlaceEntry({
    required this.place,
    required this.category,
    required this.floor,
    required this.search,
  }) : label = roomKey(place.label),
       parts = _naturalParts(roomKey(place.label));

  final MapPlaceData place;
  final String category;
  final int? floor;
  final String search;
  final String label;
  final List<(String, int?)> parts;
}

int _metadataScore(MapPlaceData place) =>
    ((place.description?.isNotEmpty ?? false) ? 4 : 0) +
    ((place.scheduleClassroomId?.isNotEmpty ?? false) ? 8 : 0) +
    place.equipment.length +
    place.menu.length +
    ((place.openingHours?.isNotEmpty ?? false) ? 2 : 0) +
    (place.capacity == null ? 0 : 1);

List<(String, int?)> _naturalParts(String label) =>
    RegExp(r'\d+|\D+').allMatches(label).map((match) {
      final part = match.group(0)!;
      return (part, int.tryParse(part));
    }).toList();

int _compareNatural(List<(String, int?)> a, List<(String, int?)> b) {
  final first = a.iterator;
  final second = b.iterator;
  while (first.moveNext() && second.moveNext()) {
    final (partA, numberA) = first.current;
    final (partB, numberB) = second.current;
    final order = numberA != null && numberB != null
        ? numberA.compareTo(numberB)
        : partA.compareTo(partB);
    if (order != 0) return order;
  }
  return a.length.compareTo(b.length);
}
