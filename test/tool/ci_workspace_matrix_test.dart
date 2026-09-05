import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

import '../../tool/package_test_runtime.dart';

void main() {
  late YamlMap workflow;
  late YamlMap jobs;

  setUpAll(() {
    workflow =
        loadYaml(
              File('.github/workflows/main.yml').readAsStringSync(),
            )
            as YamlMap;
    jobs = workflow['jobs'] as YamlMap;
  });

  test('package matrix comes from the change planner', () {
    final packageJob = jobs['workspace-packages'] as YamlMap;
    final strategy = packageJob['strategy'] as YamlMap;
    expect(
      strategy['matrix'],
      r'${{ fromJSON(needs.changes.outputs.package-matrix) }}',
    );
    expect(packageJob['needs'], 'changes');
    expect(packageJob['if'], "needs.changes.outputs.has-packages == 'true'");
    final steps = (packageJob['steps'] as YamlList).cast<YamlMap>();
    final runner = steps.singleWhere(
      (step) => step['name'] == 'Analyze and test packages',
    );
    expect(runner['run'], 'python tool/ci_packages.py');
    expect(
      (runner['env'] as YamlMap)['CI_PACKAGES'],
      r'${{ toJSON(matrix.packages) }}',
    );
  });

  test('aggregate check rejects failed and cancelled jobs', () {
    final check = jobs['checks'] as YamlMap;
    expect(check['if'], 'always()');
    expect(
      (check['needs'] as YamlList).cast<String>(),
      unorderedEquals(jobs.keys.where((key) => key != 'checks')),
    );
    final command = ((check['steps'] as YamlList).single as YamlMap)['run'];
    expect(command, contains('.changes.result == "success"'));
    expect(command, contains('.result == "success" or .result == "skipped"'));
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

  test('notification deployment resolves its pinned imports', () {
    final config = File('supabase/config.toml').readAsStringSync();
    final section = config
        .split('[functions.miniapp-notify]')
        .last
        .split('[')
        .first;
    expect(section, contains('import_map = "./functions/deno.json"'));
    final imports = File('supabase/functions/deno.json').readAsStringSync();
    expect(imports, contains('npm:@supabase/supabase-js@2.110.2'));
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

  test('standalone projects have their own analysis and test jobs', () {
    final flutterJob = jobs['flutter'] as YamlMap;
    final steps = (flutterJob['steps'] as YamlList).cast<YamlMap>();
    final analyze = steps.singleWhere((step) => step['name'] == 'Analyze');
    expect(analyze['run'], contains('for directory in lib test tool tools'));
    expect(steps.any((step) => step['working-directory'] == 'wear'), isFalse);
    for (final name in ['wear', 'schedule-fetcher']) {
      final job = jobs[name] as YamlMap;
      final standaloneSteps = (job['steps'] as YamlList).cast<YamlMap>();
      expect(standaloneSteps.any((step) => step['name'] == 'Analyze'), isTrue);
      expect(standaloneSteps.any((step) => step['name'] == 'Test'), isTrue);
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
