import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rtu_mirea_app/map/data/map_data_cache.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/data/map_preferences_data_cache.dart'
    if (dart.library.io) 'package:rtu_mirea_app/map/data/map_file_data_cache.dart'
    as platform_cache;
import 'package:rtu_mirea_app/map/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xml/xml.dart';

export 'package:rtu_mirea_app/map/data/map_data_cache.dart';

typedef MapDataRpc =
    Future<Object?> Function(
      String name,
      Map<String, Object?> parameters,
    );

Map<String, Object?> _decodeMapJson(String source) {
  final value = jsonDecode(source);
  if (value is! Map<String, Object?>) {
    throw const FormatException('Map document must be a JSON object');
  }
  return value;
}

Future<Map<String, Object?>> _decodeMapDocument(String source) =>
    source.length > 65536
    ? compute(_decodeMapJson, source)
    : Future.value(_decodeMapJson(source));

void _validateCampusPlans(List<Map<String, Object?>> floors) {
  for (final floor in floors) {
    final svg = MapDataRepository._string(floor['svg']);
    if (svg != null && svg.isNotEmpty) {
      MapDataRepository.validateSvg(
        svg,
        width: MapDataRepository._number(floor['width']) ?? 1000,
        height: MapDataRepository._number(floor['height']) ?? 1000,
      );
    }
  }
}

String _encodeMapJson(Map<String, Object?> document) => jsonEncode(document);

bool _largeMapDocument(Map<String, Object?> json) {
  final planSize = mapJsonRows(json['floors']).fold<int>(
    0,
    (total, floor) =>
        total + (floor['svg'] is String ? (floor['svg']! as String).length : 0),
  );
  final nodes = mapJsonObject(json['graph'])['nodes'];
  final rooms = json['rooms'];
  return planSize > 65536 ||
      (nodes is List && nodes.length > 512) ||
      (rooms is List && rooms.length > 128);
}

class MapDataException implements Exception {
  const MapDataException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;
}

class MapDataRepository {
  MapDataRepository({
    required this.organizationId,
    SupabaseClient? supabase,
    MapDataRpc? rpc,
    MapDataCache? cache,
    http.Client? httpClient,
    Future<String> Function(String)? assetLoader,
    DateTime Function()? clock,
    this.bundledCatalogAsset,
  }) : assert(supabase != null || rpc != null, 'A map API client is required'),
       _supabase = supabase,
       _rpc =
           rpc ??
           ((name, parameters) =>
               supabase!.rpc<Object?>(name, params: parameters)),
       _cache = cache ?? platform_cache.createMapDataCache(),
       _http = httpClient ?? http.Client(),
       _ownsHttp = httpClient == null,
       _assetLoader = assetLoader ?? rootBundle.loadString,
       _clock = clock ?? DateTime.now;

  static const int maximumSvgBytes = 8 * 1024 * 1024;
  static const pulseCatalogAsset =
      'packages/app_ui/assets/maps/pulse/catalog.json';
  static const _requestTimeout = Duration(seconds: 15);
  static const _cacheFreshness = Duration(minutes: 30);
  static const _cacheStoredAtKey = '_map_cache_stored_at';
  static const _acknowledgedRevisionKey = '_map_acknowledged_remote_revision';

  final String organizationId;
  final String? bundledCatalogAsset;
  final SupabaseClient? _supabase;
  final MapDataRpc _rpc;
  final MapDataCache _cache;
  final http.Client _http;
  final bool _ownsHttp;
  final Future<String> Function(String) _assetLoader;
  final DateTime Function() _clock;
  final _cacheStoredAt = <String, DateTime>{};
  final _svg = <String, String>{};
  final _inlineSvg = <String, String>{};
  final _remoteSvgUrls = <String, String>{};
  final _svgDimensions = <String, (double, double)>{};
  final _pendingSvg = <String, Future<String>>{};
  final _offlineSvg = <String>{};
  final _campuses = <String, CampusMapData>{};
  final _campusContent = Expando<Map<String, Object?>>();
  final _acknowledgedCampusRevisions = Expando<int>();
  final _campusGenerations = <String, int>{};
  final _pendingCampuses = <String, Future<CampusMapData>>{};
  final _pendingCachedCampuses = <String, Future<CampusMapData?>>{};
  final _bundledCampusAssets = <String, String>{};
  final _bundledCampusMetadata = <String, Map<String, Object?>>{};
  final _catalogRevisions = <String, int>{};
  MapCatalogData? _bundledCatalog;
  MapCatalogData? _catalog;

  bool get isCatalogCacheFresh => _isCacheFresh('$organizationId:catalog');

  bool isCampusCacheFresh(String campusId) =>
      _isCacheFresh('$organizationId:campus:$campusId') &&
      _satisfiesCatalog(campusId, _campuses[campusId]);

  bool _satisfiesCatalog(String campusId, CampusMapData? data) {
    if (data == null) return false;
    final revision = _catalogRevisions[campusId] ?? 0;
    return data.revision >= revision ||
        (_acknowledgedCampusRevisions[data] ?? -1) >= revision;
  }

  bool sameCampusContent(CampusMapData a, CampusMapData b) {
    if (identical(a, b)) return true;
    final before = _campusContent[a];
    final after = _campusContent[b];
    return before != null &&
        after != null &&
        const DeepCollectionEquality().equals(before, after);
  }

  bool _isCacheFresh(String key) {
    final saved = _cacheStoredAt[key];
    if (saved == null) return false;
    final age = _clock().difference(saved);
    return !age.isNegative && age <= _cacheFreshness;
  }

  Future<MapCatalogData?> loadCachedCatalog() async {
    if (_catalog != null) return _catalog;
    final cached = await _read('$organizationId:catalog');
    final bundled = await _tryBundledCatalog();
    if (_catalog != null) return _catalog;
    if (cached != null) {
      List<MapCatalogEntry> entries;
      try {
        entries = _catalogEntries(cached);
      } on FormatException {
        entries = const [];
      }
      if (entries.isNotEmpty) {
        return _rememberCatalog(
          MapCatalogData(
            entries: _mergeCatalogEntries(
              entries,
              bundled?.entries ?? const [],
            ),
            origin: MapDataOrigin.cache,
          ),
          remoteEntries: entries,
        );
      }
    }
    if (bundled == null) return null;
    return _rememberCatalog(
      MapCatalogData(entries: bundled.entries, origin: MapDataOrigin.bundled),
    );
  }

  Future<CampusMapData?> loadCachedCampus(String campusId) {
    final memory = _campuses[campusId];
    if (memory != null && _satisfiesCatalog(campusId, memory)) {
      return Future.value(memory);
    }
    return _pendingCachedCampuses.putIfAbsent(campusId, () async {
      final generation = _campusGenerations[campusId] ?? 0;
      try {
        final cached = await _read('$organizationId:campus:$campusId');
        await _tryBundledCatalog();
        final metadata = _bundledCampusMetadata[campusId];
        final preferBundle =
            cached == null ||
            (metadata != null && _newerBundledSource(metadata, cached));
        Future<CampusMapData?> parse(
          Map<String, Object?>? document,
          MapDataOrigin origin,
        ) async {
          try {
            if (document == null || _string(document['id']) != campusId) {
              return null;
            }
            final complete = await _completeCampusDocument(
              {...document, 'can_moderate': false},
              origin,
              allowNetwork: false,
            );
            return await _parseCampusDocument(
              complete,
              origin,
              shouldApply: () =>
                  generation == (_campusGenerations[campusId] ?? 0),
            );
          } on Exception {
            return null;
          }
        }

        final bundled = preferBundle
            ? await _tryBundledCampusJson(campusId)
            : null;
        final result =
            (preferBundle
                ? await parse(bundled, MapDataOrigin.bundled)
                : null) ??
            await parse(cached, MapDataOrigin.cache) ??
            (!preferBundle
                ? await parse(
                    await _tryBundledCampusJson(campusId),
                    MapDataOrigin.bundled,
                  )
                : null);
        if (result == null ||
            generation != (_campusGenerations[campusId] ?? 0)) {
          return null;
        }
        if (result.origin == MapDataOrigin.bundled) {
          _cacheStoredAt.remove('$organizationId:campus:$campusId');
        }
        _campuses[campusId] = result;
        return result;
      } finally {
        unawaited(_pendingCachedCampuses.remove(campusId));
      }
    });
  }

  bool get isAuthenticated => _supabase?.auth.currentUser != null;
  bool isSvgOffline(String path) => _offlineSvg.contains(path);

  Future<MapCatalogData> loadCatalog() async {
    const warning = 'Нет связи с каталогом. Показана сохранённая карта.';
    final key = '$organizationId:catalog';
    try {
      final json = _object(
        await _call('get_map_catalog', {
          'p_organization_id': organizationId,
        }),
      );
      final entries = _catalogEntries(json);
      final bundled = await _tryBundledCatalog();
      if (entries.isEmpty) {
        if (bundled != null) return _rememberCatalog(bundled);
      }
      await _store(key, json);
      return _rememberCatalog(
        MapCatalogData(
          entries: _mergeCatalogEntries(entries, bundled?.entries ?? const []),
          origin: MapDataOrigin.remote,
        ),
        remoteEntries: entries,
      );
    } on Exception {
      final cached = await _read(key);
      final bundled = await _tryBundledCatalog();
      if (cached != null) {
        final cachedEntries = _catalogEntries(cached);
        final bundledEntries = bundled?.entries ?? const <MapCatalogEntry>[];
        final usesCache = cachedEntries.isNotEmpty;
        return _rememberCatalog(
          MapCatalogData(
            entries: _mergeCatalogEntries(cachedEntries, bundledEntries),
            origin: usesCache ? MapDataOrigin.cache : MapDataOrigin.bundled,
            warning: usesCache ? warning : bundled?.warning,
          ),
        );
      }
      if (bundled != null) return _rememberCatalog(bundled);
      return const MapCatalogData(
        entries: [],
        origin: MapDataOrigin.bundled,
        warning: 'Серверный каталог недоступен. Показаны встроенные планы.',
      );
    }
  }

  Future<CampusMapData> loadCampus(
    String campusId, {
    bool refresh = false,
    bool afterPending = false,
  }) {
    final pending = _pendingCampuses[campusId];
    if (pending != null && !afterPending) return pending;
    final cached = _campuses[campusId];
    if (!refresh && cached != null && _satisfiesCatalog(campusId, cached)) {
      return Future.value(cached);
    }
    late final Future<CampusMapData> request;
    request = () async {
      if (pending != null) {
        try {
          await pending;
        } on Object {
          // A failed earlier request must not prevent an explicit retry.
        }
      }
      if (refresh) _svg.clear();
      _campusGenerations[campusId] = (_campusGenerations[campusId] ?? 0) + 1;
      try {
        final result = await _loadCampus(campusId);
        _campusGenerations[campusId] = (_campusGenerations[campusId] ?? 0) + 1;
        _campuses[campusId] = result;
        return result;
      } finally {
        if (identical(_pendingCampuses[campusId], request)) {
          unawaited(_pendingCampuses.remove(campusId));
        }
      }
    }();
    _pendingCampuses[campusId] = request;
    return request;
  }

  Future<CampusMapData> _loadCampus(String campusId) async {
    final key = '$organizationId:campus:$campusId';
    try {
      final json = _object(
        await _call('get_map_campus', {
          'p_campus_id': campusId,
        }),
      );
      if (_string(json['id']) != campusId) {
        throw const FormatException('Campus response does not match request');
      }
      if ((_number(json['revision']) ?? 0) <
          (_catalogRevisions[campusId] ?? 0)) {
        throw const FormatException(
          'Campus response predates its catalog revision',
        );
      }
      await _tryBundledCatalog();
      final bundledMetadata = _bundledCampusMetadata[campusId];
      if (bundledMetadata != null &&
          _newerBundledSource(bundledMetadata, json)) {
        final bundled = await _tryBundledCampusJson(campusId);
        if (bundled != null && _newerBundledSource(bundled, json)) {
          try {
            final complete = await _completeCampusDocument(
              {
                ...bundled,
                'can_moderate': false,
                _acknowledgedRevisionKey:
                    _number(json['revision'])?.toInt() ?? 0,
              },
              MapDataOrigin.bundled,
              allowNetwork: false,
            );
            final data = await _parseCampusDocument(
              complete,
              MapDataOrigin.bundled,
            );
            await _store(key, complete);
            return data;
          } on Exception {
            return await _publishedCampus(json, key);
          }
        }
      }
      return await _publishedCampus(json, key);
    } on Exception {
      final cached = await _read(key);
      final bundled = await _tryBundledCampusJson(campusId);
      final preferBundle =
          bundled != null &&
          (cached == null || _newerBundledSource(bundled, cached));
      final candidates = <(Map<String, Object?>, MapDataOrigin)>[
        if (preferBundle) (bundled, MapDataOrigin.bundled),
        if (cached != null) (cached, MapDataOrigin.cache),
        if (!preferBundle && bundled != null) (bundled, MapDataOrigin.bundled),
      ];
      for (final candidate in candidates) {
        try {
          if (_string(candidate.$1['id']) != campusId) continue;
          final complete = await _completeCampusDocument(
            {...candidate.$1, 'can_moderate': false},
            candidate.$2,
          );
          return await _parseCampusDocument(
            complete,
            candidate.$2,
            warning: candidate.$2 == MapDataOrigin.bundled
                ? _bundledCatalog?.warning
                : 'Офлайн-копия. Актуальность изменений не проверена.',
          );
        } on Exception {
          continue;
        }
      }
      rethrow;
    }
  }

  Future<CampusMapData> _publishedCampus(
    Map<String, Object?> json,
    String key,
  ) async {
    final document = Map<String, Object?>.of(json)
      ..remove(_acknowledgedRevisionKey);
    final complete = await _completeCampusDocument(
      document,
      MapDataOrigin.remote,
    );
    final data = await _parseCampusDocument(complete, MapDataOrigin.remote);
    await _store(key, {...complete, 'can_moderate': false});
    return data;
  }

  Future<CampusMapData> refreshCampus(
    String campusId, {
    bool afterPending = false,
  }) => loadCampus(campusId, refresh: true, afterPending: afterPending);

  Future<Map<String, Object?>> _completeCampusDocument(
    Map<String, Object?> document,
    MapDataOrigin origin, {
    bool allowNetwork = true,
  }) async {
    final id = _string(document['id']) ?? '';
    final revision = _number(document['revision'])?.toInt() ?? 0;
    final floors = <Map<String, Object?>>[];
    var changed = false;
    for (final floor in mapJsonRows(document['floors'])) {
      final inline = _string(floor['svg']);
      final url = _string(floor['image_url']);
      if ((inline != null && inline.isNotEmpty) || url == null || url.isEmpty) {
        floors.add(floor);
        continue;
      }
      final floorId = _string(floor['id']) ?? '';
      final path = _floorPlanPath(id, floorId, revision, origin);
      final cacheKey = '$organizationId:svg:$path';
      final dimensions = MapFloorData.fromJson(floor, svgPath: path);
      String? saved;
      try {
        saved = await _cache.read(cacheKey);
      } on Exception {
        saved = null;
      }
      if (origin != MapDataOrigin.remote && saved != null) {
        try {
          final svg = validateSvg(
            saved,
            width: dimensions.width,
            height: dimensions.height,
          );
          floors.add({...floor, 'svg': svg});
          _offlineSvg.add(path);
          changed = true;
          continue;
        } on Exception {
          saved = null;
        }
      }
      if (!allowNetwork) {
        throw const FormatException('No saved floor plan is available');
      }
      String svg;
      try {
        svg = await _fetchSvg(
          _httpsPlanUri(url),
          width: dimensions.width,
          height: dimensions.height,
        );
        _offlineSvg.remove(path);
      } on Exception {
        if (saved == null) rethrow;
        svg = validateSvg(
          saved,
          width: dimensions.width,
          height: dimensions.height,
        );
        _offlineSvg.add(path);
      }
      floors.add({...floor, 'svg': svg});
      changed = true;
    }
    return changed ? {...document, 'floors': floors} : document;
  }

  static String _floorPlanPath(
    String campusId,
    String floorId,
    int revision,
    MapDataOrigin origin,
  ) =>
      'map://$campusId/$floorId/'
      '${origin == MapDataOrigin.bundled ? 'bundled-$revision' : revision}';

  static Uri _httpsPlanUri(String source) {
    final uri = Uri.tryParse(source);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw const FormatException('Floor plan requires a valid HTTPS URL');
    }
    return uri;
  }

  Future<String> _fetchSvg(Uri uri, {double? width, double? height}) async {
    final response = await _http
        .send(
          http.Request('GET', uri)..followRedirects = false,
        )
        .timeout(_requestTimeout);
    if (response.statusCode != 200 ||
        (response.contentLength ?? 0) > maximumSvgBytes) {
      await response.stream.listen(null).cancel();
      throw const MapDataException('Не удалось загрузить план этажа.');
    }
    final bytes = <int>[];
    await for (final chunk in response.stream.timeout(_requestTimeout)) {
      if (bytes.length + chunk.length > maximumSvgBytes) {
        throw const FormatException('Floor plan exceeds size limit');
      }
      bytes.addAll(chunk);
    }
    return validateSvg(utf8.decode(bytes), width: width, height: height);
  }

  static bool _newerBundledSource(
    Map<String, Object?> bundled,
    Map<String, Object?> cached,
  ) {
    final bundledHash = bundled['source_plan_sha256'];
    final cachedHash = cached['source_plan_sha256'];
    if (bundledHash is String && bundledHash == cachedHash) return false;
    final bundledTime = DateTime.tryParse(
      bundled['source_captured_at'] is String
          ? bundled['source_captured_at']! as String
          : '',
    );
    final publishedTime = DateTime.tryParse(
      _string(cached['updated_at']) ?? '',
    );
    if (publishedTime != null &&
        (bundledTime == null || publishedTime.isAfter(bundledTime))) {
      return false;
    }
    final cachedTime = DateTime.tryParse(
      cached['source_captured_at'] is String
          ? cached['source_captured_at']! as String
          : cached['updated_at'] is String
          ? cached['updated_at']! as String
          : '',
    );
    if (bundledTime != null && cachedTime != null) {
      return bundledTime.isAfter(cachedTime);
    }
    return bundledHash is String &&
        bundledHash.isNotEmpty &&
        cachedHash == null &&
        bundled['source_capture_method'] == 'authenticated_GetCampus_response';
  }

  static List<MapCatalogEntry> _mergeCatalogEntries(
    List<MapCatalogEntry> primary,
    List<MapCatalogEntry> bundled,
  ) {
    final entries = {for (final entry in primary) entry.id: entry};
    for (final entry in bundled) {
      if (!entries.containsKey(entry.id)) {
        entries[entry.id] = entry;
      }
    }
    return List.unmodifiable(entries.values);
  }

  MapCatalogData _rememberCatalog(
    MapCatalogData catalog, {
    List<MapCatalogEntry> remoteEntries = const [],
  }) {
    _campuses.clear();
    _catalogRevisions.clear();
    for (final entry in remoteEntries) {
      _catalogRevisions[entry.id] = entry.revision;
    }
    return _catalog = catalog;
  }

  Future<MapCatalogData?> _tryBundledCatalog() async {
    try {
      return await _loadBundledCatalog();
    } on Exception {
      return null;
    }
  }

  Future<MapCatalogData?> _loadBundledCatalog() async {
    if (_bundledCatalog != null) return _bundledCatalog;
    final asset = bundledCatalogAsset;
    if (asset == null) return null;
    final json = await _decodeMapDocument(await _assetLoader(asset));
    final entries = _catalogEntries(json);
    for (final entry in mapJsonRows(json['campuses'])) {
      final id = _string(entry['id']);
      if (id == null || id.isEmpty) continue;
      _bundledCampusMetadata[id] = entry;
      final file = _string(entry['asset']) ?? 'campus_$id.json';
      _bundledCampusAssets[id] = file.startsWith('packages/')
          ? file
          : Uri.parse(asset).resolve(file).toString();
    }
    if (entries.isEmpty) return null;
    return _bundledCatalog = MapCatalogData(
      entries: entries,
      origin: MapDataOrigin.bundled,
      warning:
          'Показаны встроенные планы кампуса. '
          'Обновления сервера пока недоступны.',
    );
  }

  Future<Map<String, Object?>?> _tryBundledCampusJson(String campusId) async {
    try {
      await _loadBundledCatalog();
      final asset = _bundledCampusAssets[campusId];
      if (asset == null) return null;
      final json = await _decodeMapDocument(await _assetLoader(asset));
      if (_string(json['id']) != campusId) return null;
      return json;
    } on Exception {
      return null;
    }
  }

  Future<String> loadSvg(String path) async {
    final inline = _inlineSvg[path];
    if (inline != null) return inline;
    final cached = _svg.remove(path);
    if (cached != null) {
      _svg[path] = cached;
      return cached;
    }
    return _pendingSvg.putIfAbsent(path, () async {
      try {
        final content = await _loadSvg(path);
        _svg[path] = content;
        while (_svg.length > 12) {
          _svg.remove(_svg.keys.first);
        }
        return content;
      } finally {
        unawaited(_pendingSvg.remove(path));
      }
    });
  }

  Future<String> _loadSvg(String path) async {
    final uri = Uri.tryParse(_remoteSvgUrls[path] ?? path);
    if (uri == null || !uri.hasScheme) return _assetLoader(path);
    if (uri.scheme != 'https' || uri.host.isEmpty || uri.userInfo.isNotEmpty) {
      throw const FormatException('Floor plan requires a valid HTTPS URL');
    }
    final cacheKey = '$organizationId:svg:$path';
    try {
      final dimensions = _svgDimensions[path];
      final svg = await _fetchSvg(
        uri,
        width: dimensions?.$1,
        height: dimensions?.$2,
      );
      _offlineSvg.remove(path);
      try {
        await _cache.write(cacheKey, svg);
      } on Exception {
        // A storage quota must not prevent displaying a downloaded plan.
      }
      return svg;
    } on Exception {
      try {
        final cached = await _cache.read(cacheKey);
        if (cached != null) {
          final svg = _validatePlan(cached, path);
          _offlineSvg.add(path);
          return svg;
        }
      } on Exception {
        // A corrupt cached plan cannot replace the original load failure.
      }
      rethrow;
    }
  }

  String _validatePlan(String source, String path) {
    final dimensions = _svgDimensions[path];
    return validateSvg(source, width: dimensions?.$1, height: dimensions?.$2);
  }

  static String validateSvg(String source, {double? width, double? height}) {
    if (utf8.encode(source).length > maximumSvgBytes ||
        source.contains('<!DOCTYPE') ||
        source.contains('<!ENTITY')) {
      throw const FormatException('Unsupported floor-plan document');
    }
    final document = XmlDocument.parse(source);
    if (document.rootElement.name.local != 'svg') {
      throw const FormatException('Floor plan must be SVG');
    }
    final viewBox = document.rootElement.getAttribute('viewBox');
    if (viewBox == null) {
      throw const FormatException('Floor plan requires an explicit viewBox');
    } else {
      final bounds = viewBox
          .trim()
          .split(RegExp(r'[\s,]+'))
          .map(double.tryParse)
          .toList();
      if (bounds.length != 4 ||
          bounds.any((value) => value == null || !value.isFinite) ||
          bounds[0] != 0 ||
          bounds[1] != 0 ||
          bounds[2]! <= 0 ||
          bounds[3]! <= 0) {
        throw const FormatException(
          'Floor-plan coordinates require a finite zero-origin viewBox',
        );
      }
      if ((width != null && (bounds[2]! - width).abs() > 0.01) ||
          (height != null && (bounds[3]! - height).abs() > 0.01)) {
        throw const FormatException(
          'Floor-plan dimensions do not match campus metadata',
        );
      }
    }
    for (final element in document.descendants.whereType<XmlElement>()) {
      if (element.name.local == 'style' && _externalCss(element.innerText)) {
        throw const FormatException('External SVG styles are unsupported');
      }
      if (const {'script', 'foreignObject', 'iframe', 'use'}.contains(
        element.name.local,
      )) {
        if (element.name.local != 'use' ||
            !(element.getAttribute('href') ??
                    element.getAttribute(
                      'href',
                      namespace: 'http://www.w3.org/1999/xlink',
                    ) ??
                    '')
                .startsWith('#')) {
          throw const FormatException('Unsupported active SVG content');
        }
      }
      for (final attribute in element.attributes) {
        final name = attribute.name.local.toLowerCase();
        if (name.startsWith('on') ||
            (name == 'href' && !attribute.value.startsWith('#')) ||
            _externalCss(attribute.value)) {
          throw const FormatException('External SVG resources are unsupported');
        }
      }
    }
    return source;
  }

  static bool _externalCss(String value) =>
      value.toLowerCase().contains('@import') ||
      RegExp(r'''url\(\s*["']?([^\)"']+)''', caseSensitive: false)
          .allMatches(value)
          .any((match) => !match.group(1)!.trim().startsWith('#'));

  Future<MapRoomDetails> getRoom(
    String campusId,
    String roomId, {
    DateTime? date,
  }) async => MapRoomDetails.fromJson(
    _object(
      await _call('get_map_room', {
        'p_campus_id': campusId,
        'p_room_id': roomId,
        if (date != null) 'p_date': date.toIso8601String().substring(0, 10),
      }),
    ),
  );

  Future<MapProposalList> getProposals(
    String campusId, {
    String status = 'pending',
    int limit = 50,
  }) async => MapProposalList.fromJson(
    _object(
      await _call('get_map_proposals', {
        'p_campus_id': campusId,
        'p_status': status,
        'p_limit': limit.clamp(1, 100),
      }),
    ),
  );

  Future<MapProposal> getProposal(String id) async {
    final proposal = MapProposal.fromJson(
      _object(await _call('get_map_proposal', {'p_proposal_id': id})),
    );
    if (proposal.id != id || !proposal.hasFullPatch) {
      throw const FormatException('Incomplete map proposal details');
    }
    return proposal;
  }

  Future<MapRoomVerification> confirmRoom(
    String campusId,
    String roomId,
    int baseRevision, {
    bool confirmed = true,
  }) async => MapRoomVerification.fromJson(
    _object(
      await _call('confirm_map_room', {
        'p_campus_id': campusId,
        'p_room_id': roomId,
        'p_base_revision': baseRevision,
        'p_confirmed': confirmed,
      }),
    ),
  );

  Future<List<MapBookmark>> getBookmarks() async {
    final result = _object(await _call('get_map_bookmarks', {}));
    return List.unmodifiable(
      mapJsonRows(result['bookmarks']).map(MapBookmark.fromJson),
    );
  }

  Future<bool> setBookmark(
    String campusId,
    String roomId, {
    required bool saved,
  }) async {
    final result = _object(
      await _call('set_map_bookmark', {
        'p_campus_id': campusId,
        'p_room_id': roomId,
        'p_saved': saved,
      }),
    );
    return result['saved'] == true;
  }

  Future<MapProposal> submitProposal({
    required String campusId,
    required int baseRevision,
    required String entityType,
    required String entityId,
    required Map<String, Object?> patch,
    required String reason,
  }) async => MapProposal.fromJson(
    _object(
      await _call('submit_map_proposal', {
        'p_campus_id': campusId,
        'p_base_revision': baseRevision,
        'p_entity_type': entityType,
        'p_entity_id': entityId,
        'p_patch': patch,
        'p_reason': reason.trim(),
      }),
    ),
  );

  Future<MapProposal> reviewProposal(
    String id, {
    required bool approve,
    String? note,
  }) async {
    final proposal = MapProposal.fromJson(
      _object(
        await _call(
          'review_map_proposal',
          {
            'p_proposal_id': id,
            'p_decision': approve ? 'approved' : 'rejected',
            'p_note': note,
          },
        ),
      ),
    );
    _campuses.remove(proposal.campusId);
    return proposal;
  }

  Future<Object?> _call(String name, Map<String, Object?> parameters) async {
    try {
      return await _rpc(name, parameters).timeout(_requestTimeout);
    } on PostgrestException catch (error) {
      throw MapDataException(error.message, code: error.code);
    }
  }

  static Map<String, Object?> _object(Object? value) {
    if (value is! Map) throw const FormatException('Invalid map API response');
    return value.cast<String, Object?>();
  }

  static List<MapCatalogEntry> _catalogEntries(Map<String, Object?> json) =>
      List.unmodifiable(
        mapJsonRows(
          json['campuses'],
        ).map(MapCatalogEntry.fromJson).where((entry) => entry.id.isNotEmpty),
      );

  Future<CampusMapData> _parseCampusDocument(
    Map<String, Object?> json,
    MapDataOrigin origin, {
    String? warning,
    bool Function()? shouldApply,
  }) async {
    final planDocuments = mapJsonRows(json['floors']);
    final planSize = planDocuments.fold<int>(
      0,
      (sum, floor) => sum + (_string(floor['svg'])?.length ?? 0),
    );
    if (planSize > 65536) {
      await compute(_validateCampusPlans, planDocuments);
    } else {
      _validateCampusPlans(planDocuments);
    }
    if (shouldApply != null && !shouldApply()) {
      throw const FormatException('The campus snapshot was superseded');
    }
    return _parseCampus(json, origin, warning: warning);
  }

  CampusMapData _parseCampus(
    Map<String, Object?> json,
    MapDataOrigin origin, {
    String? warning,
  }) {
    final id =
        _string(json['id']) ??
        (throw const FormatException('Missing campus id'));
    final revision = _number(json['revision'])?.toInt() ?? 0;
    final floors = <MapFloorData>[];
    final newInline = <String, String>{};
    final newRemote = <String, String>{};
    for (final floorJson in mapJsonRows(json['floors'])) {
      final floorId =
          _string(floorJson['id']) ??
          (throw const FormatException('Missing floor id'));
      final inline = _string(floorJson['svg']);
      final url = _string(floorJson['image_url']);
      if ((inline == null || inline.isEmpty) && (url == null || url.isEmpty)) {
        continue;
      }
      final path = _floorPlanPath(id, floorId, revision, origin);
      final floorData = MapFloorData.fromJson(floorJson, svgPath: path);
      if (inline != null && inline.isNotEmpty) {
        newInline[path] = inline;
      } else {
        newRemote[path] = url!;
      }
      floors.add(floorData);
    }
    if (floors.isEmpty) {
      throw const FormatException('Campus has no floor plans');
    }
    floors.sort((a, b) => a.floor.number.compareTo(b.floor.number));
    final data = CampusMapData(
      campus: CampusModel(
        id: id,
        displayName: _string(json['short_title'] ?? json['title']) ?? id,
        floors: floors.map((floor) => floor.floor).toList(),
      ),
      floors: List.unmodifiable(floors),
      rooms: List.unmodifiable(
        mapJsonRows(json['rooms']).map(MapPlaceData.fromJson),
      ),
      graph: Map.unmodifiable(mapJsonObject(json['graph'])),
      sourceUrl: _string(json['source_url']) ?? '',
      sourceLabel: _string(json['source_label']) ?? 'Пульс РТУ МИРЭА',
      revision: revision,
      origin: origin,
      warning: warning,
      address: _string(json['address']) ?? '',
      latitude: _number(json['latitude']),
      longitude: _number(json['longitude']),
      updatedAt: DateTime.tryParse(_string(json['updated_at']) ?? ''),
      canModerate:
          origin == MapDataOrigin.remote && json['can_moderate'] == true,
    );
    _campusContent[data] = {
      for (final entry in json.entries)
        if (entry.key != _cacheStoredAtKey &&
            entry.key != _acknowledgedRevisionKey)
          entry.key: entry.value,
      'can_moderate': data.canModerate,
    };
    if (origin != MapDataOrigin.remote) {
      _acknowledgedCampusRevisions[data] = _number(
        json[_acknowledgedRevisionKey],
      )?.toInt();
    }
    _inlineSvg
      ..removeWhere((key, _) => key.startsWith('map://$id/'))
      ..addAll(newInline);
    _remoteSvgUrls
      ..removeWhere((key, _) => key.startsWith('map://$id/'))
      ..addAll(newRemote);
    for (final floor in floors) {
      _svgDimensions[floor.floor.svgPath] = (floor.width, floor.height);
    }
    return data;
  }

  static String? _string(Object? value) => switch (value) {
    null => null,
    final String text => text,
    _ => throw const FormatException('Expected text in campus map document'),
  };

  static double? _number(Object? value) => switch (value) {
    null => null,
    final num number when number.isFinite => number.toDouble(),
    _ => throw const FormatException(
      'Expected finite number in campus map document',
    ),
  };

  Future<Map<String, Object?>?> _read(String key) async {
    try {
      final value = await _cache.read(key);
      if (value == null) return null;
      final decoded = await _decodeMapDocument(value);
      final saved = decoded[_cacheStoredAtKey];
      if (saved is String) {
        final timestamp = DateTime.tryParse(saved);
        final previous = _cacheStoredAt[key];
        if (timestamp != null &&
            (previous == null || timestamp.isAfter(previous))) {
          _cacheStoredAt[key] = timestamp;
        }
      }
      return decoded;
    } on Exception {
      return null;
    }
  }

  Future<void> _store(String key, Map<String, Object?> json) async {
    final saved = _clock();
    _cacheStoredAt[key] = saved;
    try {
      final document = {
        ...json,
        _cacheStoredAtKey: saved.toUtc().toIso8601String(),
      };
      final value = _largeMapDocument(json)
          ? await compute(_encodeMapJson, document)
          : jsonEncode(document);
      await _cache.write(key, value);
    } on Exception {
      // Public cached data is optional when persistent storage is unavailable.
    }
  }

  void dispose() {
    if (_ownsHttp) _http.close();
  }
}
