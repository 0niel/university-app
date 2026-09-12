import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/configure_university_provider.dart';

void main() {
  late Directory root;
  setUp(() {
    root = Directory.systemTemp.createTempSync('university-provider-test-');
    File(
      '${root.path}/pubspec.yaml',
    ).writeAsStringSync('name: rtu_mirea_app\n');
  });
  tearDown(() => root.deleteSync(recursive: true));

  Map<String, Object?> overrides() => _map(
    _map(
      jsonDecode(
        File('${root.path}/pubspec_overrides.yaml').readAsStringSync(),
      ),
    )['dependency_overrides'],
  );

  Directory module(String name) {
    final directory = Directory('${root.path}/$name')
      ..createSync(recursive: true);
    File(
      '${directory.path}/pubspec.yaml',
    ).writeAsStringSync('name: university_provider\n');
    return directory;
  }

  void pin() {
    File('${root.path}/config/university_provider.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        jsonEncode({
          'repository': 'example/provider',
          'ref': 'a' * 40,
          'path': '.',
        }),
      );
  }

  test('preserves existing overrides and restores the default provider', () {
    final provider = module('provider');
    final overridesFile = File('${root.path}/pubspec_overrides.yaml')
      ..writeAsStringSync('dependency_overrides:\n  unrelated: 1.2.3\n');
    configureProvider(root, ['--local', provider.path]);
    expect(overrides()['unrelated'], '1.2.3');
    expect(_map(overrides()['university_provider'])['path'], 'provider');
    configureProvider(root, ['--remove']);
    expect(overrides(), {'unrelated': '1.2.3'});
    expect(overridesFile.existsSync(), isTrue);
    expect(
      Directory('${root.path}/.dart_tool/provider_backups').listSync(),
      hasLength(2),
    );
  });

  test('rejects mutable refs and credential-bearing repository URLs', () {
    expect(
      () => configureProvider(root, [
        '--repository',
        'https://github.com/example/provider.git',
        '--ref',
        'main',
      ]),
      throwsArgumentError,
    );
    expect(
      () => configureProvider(root, [
        '--repository',
        'https://secret@github.com/example/provider.git',
        '--ref',
        'a' * 40,
      ]),
      throwsArgumentError,
    );
    expect(File('${root.path}/pubspec_overrides.yaml').existsSync(), isFalse);
  });

  test('retains required app dependency pins in an override file', () {
    File('${root.path}/pubspec.yaml').writeAsStringSync(
      'name: rtu_mirea_app\ndependency_overrides:\n  pinned: 1.2.3\n',
    );
    configureProvider(root, [
      '--repository',
      'https://github.com/example/provider.git',
      '--ref',
      'a' * 40,
    ]);
    expect(overrides()['pinned'], '1.2.3');
  });

  test('pins git provider and rejects repository path escapes', () {
    configureProvider(root, [
      '--repository',
      'https://github.com/example/provider.git',
      '--ref',
      'a' * 40,
      '--path',
      'packages/provider',
    ]);
    expect(
      _map(_map(overrides()['university_provider'])['git'])['ref'],
      'a' * 40,
    );
    expect(
      () => configureProvider(root, [
        '--repository',
        'https://github.com/example/provider.git',
        '--ref',
        'a' * 40,
        '--path',
        '../outside',
      ]),
      throwsArgumentError,
    );
  });

  test('local providers inside the app resolve to relative paths', () {
    module('private/university_provider');
    configureProvider(root, ['--local', 'private/university_provider']);
    expect(
      _map(overrides()['university_provider'])['path'],
      'private/university_provider',
    );
  });

  test('local providers outside the app keep their absolute location', () {
    final outside = Directory.systemTemp.createTempSync('provider-outside-');
    addTearDown(() => outside.deleteSync(recursive: true));
    File(
      '${outside.path}/pubspec.yaml',
    ).writeAsStringSync('name: university_provider\n');
    configureProvider(root, ['--local', outside.path]);
    expect(
      _map(overrides()['university_provider'])['path'],
      outside.resolveSymbolicLinksSync().replaceAll(r'\', '/'),
    );
  });

  test('pinned provider is selected only when the repository is reachable', () {
    pin();
    final probed = <Uri>[];
    configureProvider(
      root,
      ['--pinned'],
      canReach: (repository) {
        probed.add(repository);
        return true;
      },
    );
    expect(probed, [Uri.parse('https://github.com/example/provider.git')]);
    expect(_map(_map(overrides()['university_provider'])['git']), {
      'url': 'https://github.com/example/provider.git',
      'ref': 'a' * 40,
      'path': '.',
    });
    configureProvider(root, ['--pinned'], canReach: (_) => false);
    expect(
      File('${root.path}/pubspec_overrides.yaml').readAsStringSync(),
      isNot(contains('university_provider')),
    );
  });

  test('pinned provider requires a valid committed pin', () {
    expect(
      () => configureProvider(root, ['--pinned'], canReach: (_) => true),
      throwsArgumentError,
    );
    for (final invalid in [
      {'repository': 'example/provider', 'ref': 'main'},
      {'repository': 'https://github.com/example/provider', 'ref': 'a' * 40},
      {'repository': 'example/provider.git', 'ref': 'a' * 40},
      {'repository': 'example/provider', 'ref': 'a' * 40, 'extra': true},
      {'repository': 'example/provider', 'ref': 'a' * 40, 'path': '../out'},
    ]) {
      File('${root.path}/config/university_provider.json')
        ..createSync(recursive: true)
        ..writeAsStringSync(jsonEncode(invalid));
      expect(
        () => configureProvider(root, ['--pinned'], canReach: (_) => true),
        throwsA(anyOf(isArgumentError, isFormatException)),
        reason: '$invalid',
      );
    }
    expect(File('${root.path}/pubspec_overrides.yaml').existsSync(), isFalse);
  });

  test('duplicate source options leave existing configuration untouched', () {
    final file = File('${root.path}/pubspec_overrides.yaml')
      ..writeAsStringSync('dependency_overrides:\n  existing: 1.0.0\n');
    final previous = file.readAsStringSync();
    for (final arguments in [
      ['--remove', '--remove'],
      ['--pinned', '--remove'],
      ['--pinned', '--local', 'provider'],
    ]) {
      expect(
        () => configureProvider(root, arguments),
        throwsArgumentError,
        reason: '$arguments',
      );
    }
    expect(file.readAsStringSync(), previous);
    expect(
      Directory('${root.path}/.dart_tool/provider_backups').existsSync(),
      isFalse,
    );
  });
}

Map<String, Object?> _map(Object? value) =>
    (value! as Map).cast<String, Object?>();
