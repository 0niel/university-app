import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'university_provider_pin.dart';
import 'university_provider_source.dart';

typedef RepositoryAccess = bool Function(Uri repository);

bool gitRepositoryReachable(Uri repository) {
  final result = Process.runSync(
    'git',
    ['ls-remote', '--exit-code', '--quiet', repository.toString(), 'HEAD'],
    environment: const {'GIT_TERMINAL_PROMPT': '0'},
    runInShell: true,
  );
  return result.exitCode == 0;
}

final class UniversityProviderConfigurator {
  const UniversityProviderConfigurator({
    required this.root,
    this.canReach = gitRepositoryReachable,
  });
  final Directory root;
  final RepositoryAccess canReach;

  void configure(UniversityProviderSource source) {
    final manifest = File(path.join(root.path, 'pubspec.yaml'));
    if (!manifest.existsSync()) {
      throw ArgumentError('Run from the app directory.');
    }
    final app = loadYaml(manifest.readAsStringSync());
    if (app is! YamlMap || app['name'] != 'rtu_mirea_app') {
      throw ArgumentError('Run from the University App directory.');
    }
    final selected = source is PinnedUniversityProvider ? _pinned() : source;
    final provider = switch (selected) {
      DefaultUniversityProvider() || PinnedUniversityProvider() => null,
      LocalUniversityProvider(path: final directory) => _local(directory),
      GitUniversityProvider(
        :final repository,
        :final ref,
        path: final package,
      ) =>
        {
          'git': {'url': repository.toString(), 'ref': ref, 'path': package},
        },
    };
    final file = File(path.join(root.path, 'pubspec_overrides.yaml'));
    final original = file.existsSync() ? file.readAsStringSync() : null;
    final document = original == null
        ? <String, Object?>{}
        : _map(loadYaml(original));
    final overrides = <String, Object?>{
      if (app['dependency_overrides'] != null)
        ..._map(app['dependency_overrides']),
      if (document['dependency_overrides'] != null)
        ..._map(document['dependency_overrides']),
    };
    if (provider == null) {
      overrides.remove('university_provider');
    } else {
      overrides['university_provider'] = provider;
    }
    if (overrides.isEmpty) {
      document.remove('dependency_overrides');
    } else {
      document['dependency_overrides'] = overrides;
    }
    final updated = '${const JsonEncoder.withIndent('  ').convert(document)}\n';
    if (original == updated) return;
    if (original != null) {
      final backups = Directory(
        path.join(root.path, '.dart_tool', 'provider_backups'),
      )..createSync(recursive: true);
      File(
        path.join(
          backups.path,
          '${DateTime.now().microsecondsSinceEpoch}.yaml',
        ),
      ).writeAsStringSync(original);
    }
    file.writeAsStringSync(updated);
    stdout
      ..writeln(
        provider == null ? 'Default provider selected.' : 'Provider selected.',
      )
      ..writeln('Run fvm flutter pub get --no-example, then rebuild the app.');
  }

  UniversityProviderSource _pinned() {
    final pin = UniversityProviderPin.read(
      File(path.join(root.path, UniversityProviderPin.fileName)),
    );
    if (canReach(pin.url)) return pin.source;
    stdout.writeln('Provider repository ${pin.url} is not accessible.');
    return const DefaultUniversityProvider();
  }

  Map<String, Object?> _local(String directoryPath) {
    final directory = Directory(
      path.isAbsolute(directoryPath)
          ? directoryPath
          : path.join(root.path, directoryPath),
    );
    final pubspec = File(path.join(directory.path, 'pubspec.yaml'));
    if (!pubspec.existsSync()) {
      throw ArgumentError('Provider package is missing.');
    }
    final package = loadYaml(pubspec.readAsStringSync());
    if (package is! YamlMap || package['name'] != 'university_provider') {
      throw ArgumentError(
        'Provider package must be named university_provider.',
      );
    }
    final resolved = directory.resolveSymbolicLinksSync();
    final app = root.resolveSymbolicLinksSync();
    final location = path.isWithin(app, resolved)
        ? path.relative(resolved, from: app)
        : resolved;
    return {'path': location.replaceAll(r'\', '/')};
  }
}

Map<String, Object?> _map(Object? value) {
  if (value is! Map || value.keys.any((key) => key is! String)) {
    throw const FormatException('Expected a YAML mapping with string keys.');
  }
  return {
    for (final entry in value.entries) entry.key as String: _plain(entry.value),
  };
}

Object? _plain(Object? value) => switch (value) {
  final Map<Object?, Object?> map => _map(map),
  final List<Object?> list => list.map(_plain).toList(),
  _ => value,
};
