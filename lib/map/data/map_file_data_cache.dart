import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rtu_mirea_app/map/data/map_data_cache.dart';
import 'package:uuid/uuid.dart';

MapDataCache createMapDataCache() {
  final legacy = PreferencesMapDataCache();
  return FileMapDataCache(
    legacyCache: legacy,
    onMigrated: legacy.removeMigrated,
  );
}

class FileMapDataCache implements MapDataCache {
  FileMapDataCache({
    Directory? directory,
    this.legacyCache,
    this.onMigrated,
    this.maximumBytes = 32 * 1024 * 1024,
  }) : _providedDirectory = directory;

  static Future<void> _ioTail = Future<void>.value();
  static const _uuid = Uuid();
  final Directory? _providedDirectory;
  final MapDataCache? legacyCache;
  final Future<void> Function(String key)? onMigrated;
  final int maximumBytes;
  static final _cacheName = RegExp(r'^[0-9a-f-]{36}\.cache$');
  static final _temporaryName = RegExp(
    r'^[0-9a-f-]{36}\.cache\.[0-9a-f-]{36}\.tmp$',
  );
  Future<Directory>? _directory;

  Future<Directory> _resolveDirectory() => _directory ??= () async {
    final directory =
        _providedDirectory ??
        Directory(
          path.join(
            (await getApplicationSupportDirectory()).path,
            'campus_map_v2',
          ),
        );
    await directory.create(recursive: true);
    return directory;
  }();

  String _name(String key) => '${_uuid.v5(Namespace.url.value, key)}.cache';

  @override
  Future<String?> read(String key) async {
    final stored = await _serialize(() => _readFile(key));
    if (stored != null) return stored;
    final legacy = await legacyCache?.read(key);
    if (legacy == null) return null;
    try {
      return await _serialize(() async {
        final current = await _readFile(key);
        if (current != null) return current;
        await _write(key, legacy);
        return legacy;
      });
    } on Exception {
      return legacy;
    }
  }

  Future<String?> _readFile(String key) async {
    try {
      final directory = await _resolveDirectory();
      final file = File(path.join(directory.path, _name(key)));
      final stat = file.statSync();
      if (stat.type == FileSystemEntityType.file && stat.size <= maximumBytes) {
        final bytes = await file.readAsBytes();
        final value = bytes.length > 65536
            ? await compute(_decodeEntry, (key, bytes))
            : _decodeEntry((key, bytes));
        if (value != null) {
          try {
            await file.setLastModified(DateTime.now());
          } on FileSystemException {
            return value;
          }
          return value;
        }
      }
    } on Exception {
      _directory = null;
    }
    return null;
  }

  @override
  Future<void> write(String key, String value) {
    return _serialize(() => _write(key, value));
  }

  static Future<T> _serialize<T>(Future<T> Function() action) {
    final operation = _ioTail.then((_) => action());
    _ioTail = operation.then<void>((_) {}, onError: (Object _) {});
    return operation;
  }

  Future<void> _write(String key, String value) async {
    final bytes = value.length > 65536
        ? await compute(_encodeEntry, (key, value))
        : _encodeEntry((key, value));
    if (bytes.length > maximumBytes ~/ 2) return;
    final directory = await _resolveDirectory();
    final target = File(path.join(directory.path, _name(key)));
    final temporary = File('${target.path}.${_uuid.v4()}.tmp');
    try {
      await _prune(directory, target.path, reserveBytes: bytes.length);
      await temporary.writeAsBytes(bytes, flush: true);
      await temporary.rename(target.path);
      try {
        await onMigrated?.call(key);
      } on Exception {
        return;
      }
    } finally {
      if (temporary.existsSync()) await temporary.delete();
    }
  }

  Future<void> _prune(
    Directory directory,
    String protectedPath, {
    int reserveBytes = 0,
  }) async {
    final entries = <(File, FileStat)>[];
    var total = reserveBytes;
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) continue;
      final name = path.basename(entity.path);
      if (_temporaryName.hasMatch(name)) {
        await entity.delete();
        continue;
      }
      if (!_cacheName.hasMatch(name)) continue;
      final stat = entity.statSync();
      entries.add((entity, stat));
      total += stat.size;
    }
    entries.sort((a, b) => a.$2.modified.compareTo(b.$2.modified));
    for (final (file, stat) in entries) {
      if (total <= maximumBytes) break;
      if (file.path == protectedPath) continue;
      await file.delete();
      total -= stat.size;
    }
    if (total > maximumBytes) {
      throw FileSystemException(
        'The map cache size limit was exceeded',
        directory.path,
      );
    }
  }
}

Uint8List _encodeEntry((String, String) input) =>
    Uint8List.fromList(utf8.encode('${jsonEncode(input.$1)}\n${input.$2}'));

String? _decodeEntry((String, Uint8List) input) {
  final text = utf8.decode(input.$2);
  final boundary = text.indexOf('\n');
  if (boundary < 0 || jsonDecode(text.substring(0, boundary)) != input.$1) {
    return null;
  }
  return text.substring(boundary + 1);
}
