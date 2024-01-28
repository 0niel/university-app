import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:nextcloud_test/src/presets.dart';
import 'package:process_run/process_run.dart';

int _randomPort() => 1024 + Random().nextInt(65535 - 1024);

/// Represents a docker container on the system.
class DockerContainer {
  DockerContainer._({
    required this.id,
    required this.port,
  });

  /// Creates a new docker container and returns its representation.
  static Future<DockerContainer> create(Preset preset) async {
    final dockerImageName = 'ghcr.io/nextcloud/neon/dev:${preset.name}-${preset.version.major}.${preset.version.minor}';

    var result = await runExecutableArguments(
      'docker',
      [
        'images',
        '-q',
        dockerImageName,
      ],
    );
    if (result.exitCode != 0) {
      throw Exception('Querying docker image failed: ${result.stderr}');
    }
    if (result.stdout.toString().isEmpty) {
      throw Exception('Missing docker image $dockerImageName. Please build it using ./tool/build-dev-container.sh');
    }

    late int port;
    while (true) {
      port = _randomPort();
      result = await runExecutableArguments(
        'docker',
        [
          'run',
          '--rm',
          '-d',
          '--add-host',
          'host.docker.internal:host-gateway',
          '-p',
          '$port:80',
          dockerImageName,
        ],
      );
      // 125 means the docker run command itself has failed which indicated the port is already used
      if (result.exitCode != 125) {
        break;
      }
    }

    if (result.exitCode != 0) {
      throw Exception('Failed to run docker container: ${result.stderr}');
    }

    return DockerContainer._(
      id: result.stdout.toString().replaceAll('\n', ''),
      port: port,
    );
  }

  /// ID of the docker container.
  final String id;

  /// Assigned port of docker container.
  final int port;

  /// Removes the docker container from the system.
  void destroy() => unawaited(
        runExecutableArguments(
          'docker',
          [
            'kill',
            id,
          ],
        ),
      );

  /// Reads the web server logs.
  Future<String> webServerLogs() async {
    final result = await runExecutableArguments(
      'docker',
      [
        'logs',
        id,
      ],
      stderrEncoding: utf8,
    );

    return result.stderr as String;
  }

  /// Reads the Nextcloud logs.
  Future<String> nextcloudLogs() async {
    final result = await runExecutableArguments(
      'docker',
      [
        'exec',
        id,
        'cat',
        'data/nextcloud.log',
      ],
      stdoutEncoding: utf8,
    );

    return result.stdout as String;
  }

  /// Reads all logs.
  ///
  /// Combines the output of [webServerLogs] and [nextcloudLogs].
  Future<String> allLogs() async => 'Web server:\n${await webServerLogs()}\nNextcloud:\n${await nextcloudLogs()}';
}
