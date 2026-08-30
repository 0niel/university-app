// Usage:
//   dart tools/find_unused_l10n.dart
//   dart tools/find_unused_l10n.dart --arb lib/l10n/arb/app_en.arb --src lib --src wear/lib --fail-on-unused

import 'dart:convert';
import 'dart:io';

void printUsage() {
  stdout.writeln(
    'Usage: dart tools/find_unused_l10n.dart '
    '[--arb lib/l10n/arb/app_en.arb] '
    '[--src lib] [--src wear/lib] '
    '[--exclude generated] '
    '[--fail-on-unused]',
  );
}

String _escapeRegExp(String input) => RegExp.escape(input);

String? _nextArgument(Iterator<String> iterator) =>
    iterator.moveNext() ? iterator.current : null;

Set<String> loadArbKeys(String arbPath) {
  final file = File(arbPath);
  if (!file.existsSync()) {
    throw Exception('ARB file not found: $arbPath');
  }

  final content = file.readAsStringSync();
  final map = json.decode(content) as Map<String, dynamic>;

  final keys = <String>{};
  for (final key in map.keys) {
    if (key.startsWith('@')) continue;
    keys.add(key);
  }
  return keys;
}

bool _shouldSkipFile(String path, List<String> excludes) {
  final normalized = path.replaceAll(r'\', '/');
  if (!normalized.endsWith('.dart')) return true;
  if (normalized.contains('/.dart_tool/') || normalized.contains('/build/')) {
    return true;
  }
  for (final ex in excludes) {
    if (ex.isEmpty) continue;
    if (normalized.contains(ex)) return true;
  }
  return false;
}

List<File> collectDartFiles({
  required List<String> sourceDirs,
  required List<String> excludes,
}) {
  final files = <File>[];
  for (final src in sourceDirs) {
    final dir = Directory(src);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      if (_shouldSkipFile(entity.path, excludes)) continue;
      files.add(entity);
    }
  }
  return files;
}

Set<String> findUsedKeys({
  required Set<String> keys,
  required List<File> files,
}) {
  final used = <String>{};

  final keyPatterns = <String, RegExp>{
    for (final key in keys) key: RegExp('\\.${_escapeRegExp(key)}\\b'),
  };

  for (final file in files) {
    final content = file.readAsStringSync();
    for (final entry in keyPatterns.entries) {
      if (used.contains(entry.key)) continue;
      if (entry.value.hasMatch(content)) {
        used.add(entry.key);
      }
    }
    if (used.length == keys.length) break;
  }

  return used;
}

void main(List<String> args) {
  var arbPath = 'lib/l10n/arb/app_en.arb';
  final sourceDirs = ['lib'];
  final excludes = [
    '/l10n/generated/',
    '/generated/',
    '.g.dart',
    'app_localizations',
  ];
  var failOnUnused = false;

  final arguments = args.iterator;
  while (arguments.moveNext()) {
    final arg = arguments.current;
    if (arg == '--help' || arg == '-h') {
      printUsage();
      return;
    }
    if (arg == '--arb') {
      final value = _nextArgument(arguments);
      if (value != null) arbPath = value;
      continue;
    }
    if (arg == '--src') {
      final sourceDir = _nextArgument(arguments);
      if (sourceDir == null) continue;
      if (sourceDirs.length == 1 && sourceDirs.first == 'lib') {
        sourceDirs.clear();
      }
      sourceDirs.add(sourceDir);
      continue;
    }
    if (arg == '--exclude') {
      final exclude = _nextArgument(arguments);
      if (exclude != null) excludes.add(exclude.replaceAll(r'\', '/'));
      continue;
    }
    if (arg == '--fail-on-unused') {
      failOnUnused = true;
    }
  }

  try {
    final keys = loadArbKeys(arbPath);
    final files = collectDartFiles(
      sourceDirs: sourceDirs,
      excludes: excludes,
    );
    final used = findUsedKeys(keys: keys, files: files);
    final unused = (keys.difference(used).toList()..sort());

    stdout
      ..writeln('ARB keys: ${keys.length}')
      ..writeln('Scanned Dart files: ${files.length}')
      ..writeln('Used keys: ${used.length}')
      ..writeln('Unused keys: ${unused.length}');

    if (unused.isNotEmpty) {
      stdout.writeln('\nUnused l10n keys:');
      for (final key in unused) {
        stdout.writeln('- $key');
      }
    }

    if (failOnUnused && unused.isNotEmpty) {
      exitCode = 1;
    }
  } on Exception catch (e) {
    stderr.writeln('Error: $e');
    exitCode = 2;
  }
}
