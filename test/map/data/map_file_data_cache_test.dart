import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:rtu_mirea_app/map/data/map_data_cache.dart';
import 'package:rtu_mirea_app/map/data/map_file_data_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class _LegacyCache implements MapDataCache {
  String? value = 'saved plan';
  Completer<String?>? pending;
  final removed = <String>[];

  @override
  Future<String?> read(String key) async => pending?.future ?? value;

  @override
  Future<void> write(String key, String value) async => this.value = value;

  Future<void> remove(String key) async {
    removed.add(key);
    value = null;
  }
}

File _file(Directory directory, String key) => File(
  path.join(
    directory.path,
    '${const Uuid().v5(Namespace.url.value, key)}.cache',
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('map-file-cache-test-');
  });
  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test(
    'four real campus plans survive reopening without shared preferences',
    () async {
      final cache = FileMapDataCache(directory: directory);
      for (final id in ['v-78', 'v-86', 's-20', 'mp-1']) {
        final document = await File(
          'packages/app_ui/assets/maps/pulse/campus_$id.json',
        ).readAsString();
        await cache.write('mirea:campus:$id', document);
      }
      final reopened = FileMapDataCache(directory: directory);
      for (final id in ['v-78', 'v-86', 's-20', 'mp-1']) {
        expect(
          await reopened.read('mirea:campus:$id'),
          await File(
            'packages/app_ui/assets/maps/pulse/campus_$id.json',
          ).readAsString(),
        );
      }
      var bytes = 0;
      await for (final entity in directory.list()) {
        bytes += entity.statSync().size;
        expect(path.basename(entity.path), matches(r'^[0-9a-f-]{36}\.cache$'));
      }
      expect(bytes, lessThanOrEqualTo(32 * 1024 * 1024));
    },
  );

  test(
    'atomic replacement across instances never exposes a partial document',
    () async {
      final first = FileMapDataCache(directory: directory);
      final second = FileMapDataCache(directory: directory);
      final old = 'старый план'.padRight(90000, 'a');
      final next = 'новый план'.padRight(120000, 'b');
      await first.write('tenant:campus', old);
      var completed = false;
      final write = second
          .write('tenant:campus', next)
          .whenComplete(() => completed = true);
      while (!completed) {
        expect(await first.read('tenant:campus'), anyOf(old, next));
      }
      await write;
      expect(await first.read('tenant:campus'), next);
      expect(await directory.list().length, 1);
    },
  );

  test(
    'bounded eviction preserves recently used entries and unrelated files',
    () async {
      final cache = FileMapDataCache(directory: directory, maximumBytes: 200);
      for (final key in ['a', 'b', 'c']) {
        await cache.write(key, ''.padRight(60, key));
        await _file(directory, key).setLastModified(DateTime.utc(2020));
      }
      await _file(directory, 'b').setLastModified(DateTime.utc(2019));
      await cache.read('a');
      final unrelated = File(path.join(directory.path, 'keep.txt'));
      await unrelated.writeAsString('unrelated');
      await cache.write('d', ''.padRight(60, 'd'));
      expect(await cache.read('b'), isNull);
      expect(await cache.read('a'), isNotNull);
      expect(await cache.read('c'), isNotNull);
      expect(await cache.read('d'), isNotNull);
      expect(await unrelated.readAsString(), 'unrelated');
      var bytes = 0;
      await for (final entity in directory.list()) {
        if (entity.path.endsWith('.cache')) bytes += entity.statSync().size;
      }
      expect(bytes, lessThanOrEqualTo(200));
    },
  );

  test('oversized replacements keep the last complete document', () async {
    final cache = FileMapDataCache(directory: directory, maximumBytes: 200);
    await cache.write('a', 'valid');
    await cache.write('a', ''.padRight(200, 'x'));
    expect(await cache.read('a'), 'valid');
  });

  test(
    'concurrent writers clean interrupted files and share the byte limit',
    () async {
      final first = FileMapDataCache(directory: directory, maximumBytes: 200);
      final second = FileMapDataCache(directory: directory, maximumBytes: 200);
      final interrupted = File(
        '${_file(directory, 'old').path}.${const Uuid().v4()}.tmp',
      );
      await interrupted.writeAsString(''.padRight(150, 'x'));
      await Future.wait([
        first.write('a', ''.padRight(60, 'a')),
        second.write('b', ''.padRight(60, 'b')),
        first.write('c', ''.padRight(60, 'c')),
        second.write('d', ''.padRight(60, 'd')),
      ]);
      var bytes = 0;
      await for (final entity in directory.list()) {
        expect(entity.path.endsWith('.tmp'), isFalse);
        bytes += entity.statSync().size;
      }
      expect(bytes, lessThanOrEqualTo(200));
      expect(await first.read('d'), ''.padRight(60, 'd'));
    },
  );

  test('successful migration deletes only its exact legacy map key', () async {
    SharedPreferences.setMockInitialValues({
      'campus_map_v1:tenant:campus:a': 'plan',
      'campus_map_v1:tenant:campus:b': 'another plan',
      'profile': 'retained',
      'campus_map_v1:index': [
        'campus_map_v1:tenant:campus:a',
        'campus_map_v1:tenant:campus:b',
      ],
    });
    final legacy = PreferencesMapDataCache();
    final cache = FileMapDataCache(
      directory: directory,
      legacyCache: legacy,
      onMigrated: legacy.removeMigrated,
    );
    expect(await cache.read('tenant:campus:a'), 'plan');
    expect(await legacy.read('tenant:campus:a'), isNull);
    expect(await legacy.read('tenant:campus:b'), 'another plan');
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('profile'), 'retained');
    expect(preferences.getStringList('campus_map_v1:index'), [
      'campus_map_v1:tenant:campus:b',
    ]);
    expect(
      await FileMapDataCache(directory: directory).read('tenant:campus:a'),
      'plan',
    );
  });

  test('failed file migration leaves the old cache usable', () async {
    final blocked = File(path.join(directory.path, 'blocked'));
    await blocked.writeAsString('file, not a directory');
    final legacy = _LegacyCache();
    final cache = FileMapDataCache(
      directory: Directory(blocked.path),
      legacyCache: legacy,
      onMigrated: legacy.remove,
    );
    expect(await cache.read('tenant:a'), 'saved plan');
    expect(legacy.value, 'saved plan');
    expect(legacy.removed, isEmpty);
  });

  test(
    'a delayed legacy migration cannot replace a newer native write',
    () async {
      final legacy = _LegacyCache()..pending = Completer<String?>();
      final cache = FileMapDataCache(
        directory: directory,
        legacyCache: legacy,
        onMigrated: legacy.remove,
      );
      final pending = cache.read('tenant:a');
      await cache.write('tenant:a', 'current');
      legacy.pending!.complete('outdated');
      expect(await pending, 'current');
      expect(await cache.read('tenant:a'), 'current');
    },
  );

  test(
    'keys cannot escape the directory and remain isolated by tenant',
    () async {
      final cache = FileMapDataCache(directory: directory);
      await cache.write('first:../../plan\n', 'first');
      await cache.write('second:../../plan\n', 'second');
      expect(await cache.read('first:../../plan\n'), 'first');
      expect(await cache.read('second:../../plan\n'), 'second');
      final files = await directory.list().toList();
      expect(files, hasLength(2));
      for (final file in files) {
        expect(path.dirname(file.path), directory.path);
      }
    },
  );
}
