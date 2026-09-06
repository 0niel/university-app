import 'package:collection/collection.dart';
import 'package:rtu_mirea_app/map/models/models.dart';

enum MapDataOrigin { remote, cache, bundled }

Map<String, Object?> mapJsonObject(Object? value) =>
    value is Map ? value.cast<String, Object?>() : const {};

List<Map<String, Object?>> mapJsonRows(Object? value) => value is List
    ? value
          .whereType<Map<Object?, Object?>>()
          .map((item) => item.cast<String, Object?>())
          .toList()
    : const [];

String _text(Object? value, [String fallback = '']) =>
    value is String ? value : fallback;
double? _number(Object? value) => value is num && value.isFinite
    ? value.toDouble()
    : double.tryParse(_text(value));
int _integer(Object? value, [int fallback = 0]) =>
    value is num ? value.toInt() : int.tryParse(_text(value)) ?? fallback;
DateTime? _date(Object? value) => DateTime.tryParse(_text(value));
List<String> _strings(Object? value) =>
    value is List ? List.unmodifiable(value.whereType<String>()) : const [];
String? _optionalText(Object? value) => switch (value) {
  null => null,
  final String text => text,
  _ => throw const FormatException('Expected a text field in map data'),
};
bool? _optionalBool(Object? value) => switch (value) {
  null => null,
  final bool flag => flag,
  _ => throw const FormatException('Expected a boolean field in map data'),
};

class MapCatalogData {
  const MapCatalogData({
    required this.entries,
    required this.origin,
    this.warning,
  });

  final List<MapCatalogEntry> entries;
  final MapDataOrigin origin;
  final String? warning;
}

class MapCatalogEntry {
  MapCatalogEntry.fromJson(Map<String, Object?> json)
    : id = _text(json['id']),
      title = _text(json['short_title'], _text(json['title'])),
      revision = _integer(json['revision']);

  final String id;
  final String title;
  final int revision;

  CampusModel get campus => CampusModel(id: id, displayName: title, floors: []);
}

class MapGeoAnchor {
  const MapGeoAnchor({
    required this.x,
    required this.y,
    required this.latitude,
    required this.longitude,
  });

  factory MapGeoAnchor.fromJson(Map<String, Object?> json) => MapGeoAnchor(
    x: _number(json['x']) ?? 0,
    y: _number(json['y']) ?? 0,
    latitude: _number(json['latitude']) ?? 0,
    longitude: _number(json['longitude']) ?? 0,
  );

  final double x;
  final double y;
  final double latitude;
  final double longitude;
}

class MapGeoreferenceData {
  MapGeoreferenceData.fromJson(Map<String, Object?> json)
    : status = _text(json['status']),
      method = _text(json['method']),
      summary = _text(json['summary']),
      checkedAt = _date(json['checked_at']),
      limitations = _strings(json['limitations']),
      sources = List.unmodifiable(
        mapJsonRows(json['sources']).map(MapGeoreferenceSource.fromJson),
      ),
      excludedRegions = List.unmodifiable(
        mapJsonRows(
          json['excluded_regions'],
        ).map(MapGeoreferenceRegion.fromJson),
      );

  final String status;
  final String method;
  final String summary;
  final DateTime? checkedAt;
  final List<String> limitations;
  final List<MapGeoreferenceSource> sources;
  final List<MapGeoreferenceRegion> excludedRegions;

  bool isReliableAt(double x, double y) =>
      x.isFinite &&
      y.isFinite &&
      !excludedRegions.any((region) => region.contains(x, y));
}

class MapGeoreferenceRegion {
  MapGeoreferenceRegion.fromJson(Map<String, Object?> json)
    : x = _number(json['x']) ?? 0,
      y = _number(json['y']) ?? 0,
      width = _number(json['width']) ?? 0,
      height = _number(json['height']) ?? 0;

  final double x;
  final double y;
  final double width;
  final double height;

  bool contains(double px, double py) =>
      width > 0 &&
      height > 0 &&
      px >= x &&
      px <= x + width &&
      py >= y &&
      py <= y + height;
}

class MapGeoreferenceSource {
  MapGeoreferenceSource.fromJson(Map<String, Object?> json)
    : label = _text(json['label']),
      url = _text(json['url']);

  final String label;
  final String url;

  Uri? get link {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty
        ? uri
        : null;
  }
}

class MapFloorData {
  MapFloorData.fromJson(Map<String, Object?> json, {required String svgPath})
    : floor = FloorModel(
        id: _text(json['id']),
        number: _integer(json['level']),
        svgPath: svgPath,
      ),
      label = _text(json['label']),
      width = _number(json['width']) ?? 1000,
      height = _number(json['height']) ?? 1000,
      metersPerUnit = _number(json['meters_per_unit']),
      anchors = List.unmodifiable(
        mapJsonRows(json['anchors']).map(MapGeoAnchor.fromJson),
      ),
      georeference = json['georeference'] is Map
          ? MapGeoreferenceData.fromJson(mapJsonObject(json['georeference']))
          : null;

  final FloorModel floor;
  final String label;
  final double width;
  final double height;
  final double? metersPerUnit;
  final List<MapGeoAnchor> anchors;
  final MapGeoreferenceData? georeference;
}

class CampusMapData {
  CampusMapData({
    required this.campus,
    required this.floors,
    required this.rooms,
    required this.graph,
    required this.sourceUrl,
    required this.sourceLabel,
    required this.revision,
    required this.origin,
    this.canModerate = false,
    this.address = '',
    this.latitude,
    this.longitude,
    this.updatedAt,
    this.warning,
  });

  final CampusModel campus;
  final List<MapFloorData> floors;
  final List<MapPlaceData> rooms;
  final Map<String, Object?> graph;
  final String sourceUrl;
  final String sourceLabel;
  final int revision;
  final MapDataOrigin origin;
  final bool canModerate;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime? updatedAt;
  final String? warning;

  late final Map<String, MapPlaceData> _placesById = {
    for (final room in rooms) room.id: room,
  };
  late final Map<String, MapPlaceData> _placesByAlias = () {
    final aliases = <String, MapPlaceData>{};
    final ambiguous = <String>{};
    for (final room in rooms) {
      for (final alias in [
        ...room.legacyIds,
        ?room.sourceDatabaseId,
      ]) {
        if (alias.isEmpty || _placesById.containsKey(alias)) continue;
        if (aliases.containsKey(alias) && aliases[alias] != room) {
          ambiguous.add(alias);
        } else {
          aliases[alias] = room;
        }
      }
    }
    ambiguous.forEach(aliases.remove);
    return aliases;
  }();

  MapPlaceData? placeForId(String id) {
    final exact = _placesById[id] ?? _placesByAlias[id];
    if (exact != null) return exact;
    final marker = id.lastIndexOf('__r__');
    if (marker < 0) return null;
    final localId = id.substring(marker + 5);
    return _placesById[localId] ?? _placesByAlias[localId];
  }

  MapFloorData? floorForId(String id) =>
      floors.firstWhereOrNull((floor) => floor.floor.id == id);
}

class MapPlaceData {
  MapPlaceData.fromJson(Map<String, Object?> json)
    : id = _text(json['id']),
      floorId = _text(json['floor_id']),
      label = _text(json['label']),
      kind = _text(json['kind'], 'room'),
      legacyIds = _strings(json['legacy_ids']),
      sourceDatabaseId = _optionalText(json['source_db_id']),
      x = _number(json['x']) ?? 0,
      y = _number(json['y']) ?? 0,
      equipment = _strings(json['equipment']),
      openingHours = _optionalText(json['opening_hours']),
      menu = List.unmodifiable(
        mapJsonRows(json['menu']).map(MapMenuItem.fromJson),
      ),
      description = _optionalText(json['description']),
      scheduleClassroomId = json['schedule_classroom_id']?.toString(),
      capacity = json['capacity'] is num
          ? (json['capacity']! as num).toInt()
          : null,
      accessible = _optionalBool(json['accessible']),
      verifiedAt = _date(json['verified_at']),
      updatedAt = _date(json['updated_at']),
      menuDate = _date(json['menu_date']),
      expiresAt = _date(json['expires_at']),
      sourceUrl = _optionalText(json['source_url']),
      raw = Map.unmodifiable(json);

  final String id;
  final String floorId;
  final String label;
  final String kind;
  final List<String> legacyIds;
  final String? sourceDatabaseId;
  final double x;
  final double y;
  final List<String> equipment;
  final String? openingHours;
  final List<MapMenuItem> menu;
  final String? description;
  final String? scheduleClassroomId;
  final int? capacity;
  final bool? accessible;
  final DateTime? verifiedAt;
  final DateTime? updatedAt;
  final DateTime? menuDate;
  final DateTime? expiresAt;
  final String? sourceUrl;
  final Map<String, Object?> raw;

  Map<String, Object?> get metadata => raw;
}

class MapMenuItem {
  MapMenuItem.fromJson(Map<String, Object?> json)
    : name = _text(json['name']),
      price = _number(json['price']),
      currency = _text(json['currency'], 'RUB'),
      description = _optionalText(json['description']),
      available = json['available'] != false;

  final String name;
  final double? price;
  final String currency;
  final String? description;
  final bool available;
}

class MapRoomDetails {
  MapRoomDetails.fromJson(Map<String, Object?> json)
    : room = MapPlaceData.fromJson(mapJsonObject(json['room'])),
      date = _date(json['date']) ?? DateTime.now(),
      scheduleLinked = json['schedule_linked'] == true,
      schedule = List.unmodifiable(
        mapJsonRows(json['schedule']).map(MapRoomLesson.fromJson),
      ),
      revision = _integer(json['revision']),
      canModerate = json['can_moderate'] == true,
      verification = MapRoomVerification.fromJson(
        mapJsonObject(json['verification']),
      );

  final MapPlaceData room;
  final DateTime date;
  final bool scheduleLinked;
  final List<MapRoomLesson> schedule;
  final int revision;
  final bool canModerate;
  final MapRoomVerification verification;

  int get confirmationCount => verification.confirmationCount;
  DateTime? get lastConfirmedAt => verification.lastConfirmedAt;
  bool get confirmedByMe => verification.confirmedByMe;
}

class MapRoomVerification {
  MapRoomVerification.fromJson(Map<String, Object?> json)
    : confirmationCount = _integer(json['confirmation_count']),
      lastConfirmedAt = _date(json['last_confirmed_at']),
      confirmedByMe = json['confirmed_by_me'] == true;

  final int confirmationCount;
  final DateTime? lastConfirmedAt;
  final bool confirmedByMe;
}

class MapBookmark {
  MapBookmark.fromJson(Map<String, Object?> json)
    : campusId = _text(json['campus_id']),
      roomId = _text(json['room_id']),
      roomLabel = _text(json['room_label']),
      campusTitle = _text(json['campus_title']),
      savedAt = _date(json['saved_at']);

  final String campusId;
  final String roomId;
  final String roomLabel;
  final String campusTitle;
  final DateTime? savedAt;
}

class MapRoomLesson {
  MapRoomLesson.fromJson(Map<String, Object?> json)
    : id = _text(json['id']),
      title = _text(json['title']),
      kind = _text(json['kind'], _text(json['lesson_type'])),
      startTime = _text(json['start_time']),
      endTime = _text(json['end_time']),
      groups = _strings(json['groups']),
      teachers = _strings(json['teachers']);

  final String id;
  final String title;
  final String kind;
  final String startTime;
  final String endTime;
  final List<String> groups;
  final List<String> teachers;
}

class MapProposal {
  MapProposal.fromJson(Map<String, Object?> json)
    : id = _text(json['id']),
      campusId = _text(json['campus_id']),
      baseRevision = _integer(json['base_revision']),
      entityType = _text(json['entity_type']),
      entityId = _text(json['entity_id']),
      patch = Map.unmodifiable(mapJsonObject(json['patch'])),
      hasFullPatch = json['patch'] is Map && json['has_full_patch'] != false,
      patchKeys = List.unmodifiable(
        json['patch_keys'] is List
            ? (json['patch_keys']! as List).whereType<String>()
            : mapJsonObject(json['patch']).keys,
      ),
      patchBytes = _integer(json['patch_bytes']),
      reason = _text(json['reason']),
      status = _text(json['status']),
      createdAt = _date(json['created_at']),
      reviewNote = _optionalText(json['review_note']),
      isMine = json['is_mine'] == true,
      canReview = json['can_review'] == true;

  final String id;
  final String campusId;
  final int baseRevision;
  final String entityType;
  final String entityId;
  final Map<String, Object?> patch;
  final bool hasFullPatch;
  final List<String> patchKeys;
  final int patchBytes;
  final String reason;
  final String status;
  final DateTime? createdAt;
  final String? reviewNote;
  final bool isMine;
  final bool canReview;
}

class MapProposalList {
  MapProposalList.fromJson(Map<String, Object?> json)
    : canModerate = json['can_moderate'] == true,
      proposals = List.unmodifiable(
        mapJsonRows(json['proposals']).map(MapProposal.fromJson),
      );

  final bool canModerate;
  final List<MapProposal> proposals;
}
