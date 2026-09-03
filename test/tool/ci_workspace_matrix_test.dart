import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

import '../../tool/package_test_runtime.dart';

void main() {
  late YamlMap workflow;
  late YamlMap rootPubspec;
  late YamlMap jobs;

  setUpAll(() {
    workflow =
        loadYaml(
              File('.github/workflows/main.yml').readAsStringSync(),
            )
            as YamlMap;
    rootPubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;
    jobs = workflow['jobs'] as YamlMap;
  });

  test('CI matrix covers every workspace package exactly once', () {
    final packageJob = jobs['workspace-packages'] as YamlMap;
    final strategy = packageJob['strategy'] as YamlMap;
    final matrix = strategy['matrix'] as YamlMap;
    final packages = (matrix['package'] as YamlList).cast<String>();
    final workspace = (rootPubspec['workspace'] as YamlList).cast<String>();

    expect(packages.toSet(), hasLength(packages.length));
    expect(
      packages.map((package) => 'packages/$package'),
      unorderedEquals(workspace),
    );
    for (final package in packages) {
      expect(File('packages/$package/pubspec.yaml').existsSync(), isTrue);
    }
  });

  test('package jobs analyze and test their selected package', () {
    final packageJob = jobs['workspace-packages'] as YamlMap;
    final steps = (packageJob['steps'] as YamlList).cast<YamlMap>();
    final analyze = steps.singleWhere(
      (step) => step['name'] == 'Analyze package',
    );
    final test = steps.singleWhere((step) => step['name'] == 'Test package');
    const packageDirectory = r'packages/${{ matrix.package }}';

    expect(analyze['working-directory'], packageDirectory);
    expect(analyze['run'], contains('dart analyze --fatal-warnings'));
    expect(test['working-directory'], packageDirectory);
    expect(test['run'], contains('flutter test'));
    expect(test['run'], contains('dart test'));
    expect(test['run'], contains('tool/package_test_runtime.dart'));
    expect(test['run'], contains('flutter test --no-pub'));
  });

  test('edge job validates ingestion and mini-app notifications', () {
    final edgeJob = jobs['edge-functions'] as YamlMap;
    final steps = (edgeJob['steps'] as YamlList).cast<YamlMap>();
    for (final name in ['Check formatting', 'Type-check', 'Lint', 'Test']) {
      final command = steps.singleWhere((step) => step['name'] == name)['run'];
      expect(command, contains('supabase/functions/ingest'));
      expect(command, contains('supabase/functions/miniapp-notify'));
    }
  });

  group('package test runtime', () {
    Map<String, Object?> graph(List<Map<String, Object?>> packages) => {
      'packages': packages,
    };

    test('selects Flutter for a direct SDK dependency', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'dependencies': ['flutter'],
            },
          ]),
        ),
        'flutter',
      );
    });

    test('selects Flutter for a transitive plugin dependency', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'dependencies': ['app_links'],
            },
            {
              'name': 'app_links',
              'dependencies': ['flutter'],
            },
          ]),
        ),
        'flutter',
      );
    });

    test('includes development dependencies of the tested package', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'devDependencies': ['flutter_test'],
            },
            {
              'name': 'flutter_test',
              'dependencies': ['flutter'],
            },
          ]),
        ),
        'flutter',
      );
    });

    test('ignores unrelated Flutter workspace members', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {'name': 'subject', 'dependencies': <String>[]},
            {
              'name': 'application',
              'dependencies': ['flutter'],
            },
          ]),
        ),
        'dart',
      );
    });

    test('does not inherit development dependencies of another package', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'dependencies': ['shared'],
            },
            {
              'name': 'shared',
              'devDependencies': ['flutter'],
            },
          ]),
        ),
        'dart',
      );
    });

    test('handles dependency cycles', () {
      expect(
        packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'dependencies': ['shared'],
            },
            {
              'name': 'shared',
              'dependencies': ['subject'],
            },
          ]),
        ),
        'dart',
      );
    });

    test('rejects an unresolved dependency rather than choosing Dart', () {
      expect(
        () => packageTestRuntime(
          'subject',
          graph([
            {
              'name': 'subject',
              'dependencies': ['missing'],
            },
          ]),
        ),
        throwsFormatException,
      );
    });
  });

  test('root analysis resolves standalone Dart projects before running', () {
    final flutterJob = jobs['flutter'] as YamlMap;
    final steps = (flutterJob['steps'] as YamlList).cast<YamlMap>().toList();
    final analyzeIndex = steps.indexWhere(
      (step) => step['name'] == 'Analyze',
    );
    expect(analyzeIndex, greaterThanOrEqualTo(0));

    for (final directory in ['wear', 'tools/schedule_fetcher']) {
      final installIndex = steps.indexWhere(
        (step) =>
            step['working-directory'] == directory &&
            (step['run'] as String? ?? '').contains('pub get'),
      );
      expect(installIndex, greaterThanOrEqualTo(0));
      expect(installIndex, lessThan(analyzeIndex));
    }
  });

  test('database contracts run locally after migration replay', () {
    final databaseJob = jobs['supabase-migrations'] as YamlMap;
    final steps = (databaseJob['steps'] as YamlList).cast<YamlMap>().toList();
    final replayIndex = steps.indexWhere(
      (step) => step['name'] == 'Replay migrations',
    );
    final contractsIndex = steps.indexWhere(
      (step) => step['name'] == 'Verify database security contracts',
    );
    expect(replayIndex, greaterThanOrEqualTo(0));
    expect(contractsIndex, greaterThan(replayIndex));
    final contracts = steps[contractsIndex];
    final command = contracts['run'] as String;

    expect(steps[replayIndex]['run'], 'supabase db reset');
    expect(contracts['shell'], 'bash');
    expect(
      command,
      contains('for contract in supabase/tests/*_contract.sql; do'),
    );
    expect(
      command,
      contains('postgresql://postgres:postgres@127.0.0.1:54322/postgres'),
    );
    expect(command, contains('--set ON_ERROR_STOP=1'));
    expect(command, contains(r'--file "$contract"'));
    expect(command, contains('failed_contracts=()'));
    expect(command, contains(r'failed_contracts+=("$contract")'));
    expect(command, contains(r'${#failed_contracts[@]} > 0'));
    expect(command, contains('exit 1'));
    expect(command, isNot(contains('--linked')));
  });

  test('database contracts isolate their fixtures with rollback', () {
    final contracts = Directory('supabase/tests')
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('_contract.sql'))
        .toList();

    expect(contracts, isNotEmpty);
    expect(
      contracts.map((file) => file.uri.pathSegments.last),
      containsAll([
        'fresh_onboarding_profile_contract.sql',
        'material_access_contract.sql',
        'wallet_boundary_contract.sql',
      ]),
    );
    for (final contract in contracts) {
      final sql = contract.readAsStringSync().trim().toLowerCase();
      expect(sql, startsWith('begin;'), reason: contract.path);
      expect(sql, endsWith('rollback;'), reason: contract.path);
    }
  });

  test(
    'generated build backups are excluded without hiding project source',
    () {
      final options =
          loadYaml(
                File('analysis_options.yaml').readAsStringSync(),
              )
              as YamlMap;
      final analyzer = options['analyzer'] as YamlMap;
      final excluded = (analyzer['exclude'] as YamlList).cast<String>();

      expect(excluded, contains('build/**'));
      for (final source in ['lib/**', 'packages/**', 'tools/**', 'test/**']) {
        expect(excluded, isNot(contains(source)));
      }
    },
  );
}
