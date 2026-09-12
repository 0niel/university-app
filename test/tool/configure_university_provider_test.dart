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

  test('preserves existing overrides and restores the default provider', () {
    final module = Directory('${root.path}/provider')..createSync();
    File(
      '${module.path}/pubspec.yaml',
    ).writeAsStringSync('name: university_provider\n');
    final overrides = File('${root.path}/pubspec_overrides.yaml')
      ..writeAsStringSync('dependency_overrides:\n  unrelated: 1.2.3\n');
    configureProvider(root, ['--local', module.path]);
    var saved = _map(jsonDecode(overrides.readAsStringSync()));
    expect(_map(saved['dependency_overrides'])['unrelated'], '1.2.3');
    expect(
      _map(_map(saved['dependency_overrides'])['university_provider'])['path'],
      module.resolveSymbolicLinksSync().replaceAll(r'\', '/'),
    );
    configureProvider(root, ['--remove']);
    saved = _map(jsonDecode(overrides.readAsStringSync()));
    expect(saved['dependency_overrides'], {'unrelated': '1.2.3'});
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
    final saved =
        jsonDecode(
              File('${root.path}/pubspec_overrides.yaml').readAsStringSync(),
            )
            as Map;
    expect(_map(saved['dependency_overrides'])['pinned'], '1.2.3');
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
    final saved =
        jsonDecode(
              File('${root.path}/pubspec_overrides.yaml').readAsStringSync(),
            )
            as Map;
    expect(
      _map(
        _map(_map(saved['dependency_overrides'])['university_provider'])['git'],
      )['ref'],
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
  test('local provider paths resolve against the requested app directory', () {
    final module = Directory('${root.path}/provider')..createSync();
    File('${module.path}/pubspec.yaml')
        .writeAsStringSync('name: university_provider\n');
    configureProvider(root, ['--local', 'provider']);
    final saved = _map(jsonDecode(
      File('${root.path}/pubspec_overrides.yaml').readAsStringSync(),
    ));
    expect(
      _map(_map(saved['dependency_overrides'])['university_provider'])['path'],
      module.resolveSymbolicLinksSync().replaceAll(r'\', '/'),
    );
  });

  test('duplicate source options leave existing configuration untouched', () {
    final file = File('${root.path}/pubspec_overrides.yaml')
      ..writeAsStringSync('dependency_overrides:\n  existing: 1.0.0\n');
    final previous = file.readAsStringSync();
    expect(
      () => configureProvider(root, ['--remove', '--remove']),
      throwsArgumentError,
    );
    expect(file.readAsStringSync(), previous);
    expect(Directory('${root.path}/.dart_tool/provider_backups').existsSync(), isFalse);
  });
}

Map<String, Object?> _map(Object? value) =>
    (value! as Map).cast<String, Object?>();
