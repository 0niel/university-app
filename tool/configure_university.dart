import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'src/university_configurator.dart';
import 'src/university_deployment_config.dart';

final class ConfigureUniversity {
  const ConfigureUniversity._();

  static const usage = '''
Generate local platform metadata from a university configuration.

Usage:
  dart run tool/configure_university.dart [options]

Options:
  --config <path>  JSON config path relative to the project root.
                   Default: config/university.local.json
  --root <path>    Project root. Default: current directory.
  --check          Exit with code 1 when generated files are missing or stale.
  --help           Show this help.
''';

  static void run(List<String> arguments) {
    try {
      final options = _Options.parse(arguments);
      if (options.showHelp) {
        stdout.write(usage);
        return;
      }

      final root = Directory(options.rootPath).absolute;
      final configPath = path.isAbsolute(options.configPath)
          ? options.configPath
          : path.join(root.path, options.configPath);
      final configurator = UniversityConfigurator(projectRoot: root);
      final config = configurator.readConfig(File(configPath));

      if (options.check) {
        final result = configurator.check(config);
        if (result.isCurrent) {
          stdout.writeln('University configuration is current.');
          return;
        }
        for (final missingPath in result.missingPaths) {
          stderr.writeln('Missing: $missingPath');
        }
        for (final outdatedPath in result.outdatedPaths) {
          stderr.writeln('Outdated: $outdatedPath');
        }
        exitCode = 1;
        return;
      }

      final result = configurator.write(config);
      for (final writtenPath in result.writtenPaths) {
        stdout.writeln('Generated: $writtenPath');
      }
      for (final unchangedPath in result.unchangedPaths) {
        stdout.writeln('Unchanged: $unchangedPath');
      }
    } on UniversityConfigurationException catch (error) {
      stderr.writeln('Configuration error: $error');
      exitCode = 64;
    } on UniversityOptionsException catch (error) {
      stderr
        ..writeln('Argument error: $error')
        ..write(usage);
      exitCode = 64;
    }
  }
}

void main(List<String> arguments) => ConfigureUniversity.run(arguments);

final class _Options {
  const _Options({
    required this.configPath,
    required this.rootPath,
    required this.check,
    required this.showHelp,
  });

  factory _Options.parse(List<String> arguments) {
    var configPath = path.join('config', 'university.local.json');
    var rootPath = Directory.current.path;
    var check = false;
    var showHelp = false;

    for (var index = 0; index < arguments.length; index++) {
      final argument = arguments.elementAtOrNull(index);
      if (argument == null) {
        break;
      }
      switch (argument) {
        case '--config':
          configPath = _readValue(arguments, ++index, argument);
        case '--root':
          rootPath = _readValue(arguments, ++index, argument);
        case '--check':
          check = true;
        case '--help' || '-h':
          showHelp = true;
        default:
          throw UniversityOptionsException('Unknown option: $argument');
      }
    }

    return _Options(
      configPath: configPath,
      rootPath: rootPath,
      check: check,
      showHelp: showHelp,
    );
  }

  final String configPath;
  final String rootPath;
  final bool check;
  final bool showHelp;

  static String _readValue(
    List<String> arguments,
    int index,
    String option,
  ) {
    final value = arguments.elementAtOrNull(index);
    if (value == null || value.startsWith('--')) {
      throw UniversityOptionsException('$option requires a path.');
    }
    return value;
  }
}

final class UniversityOptionsException implements Exception {
  const UniversityOptionsException(this.message);

  final String message;

  @override
  String toString() => message;
}
