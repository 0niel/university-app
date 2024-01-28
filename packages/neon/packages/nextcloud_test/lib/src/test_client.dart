import 'dart:async';
import 'dart:convert';

import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/src/docker_container.dart';
import 'package:nextcloud_test/src/fixtures.dart';
import 'package:nextcloud_test/src/proxy_http_client.dart';
import 'package:process_run/process_run.dart';

/// An extension for creating [NextcloudClient]s based on [DockerContainer]s.
extension TestNextcloudClient on NextcloudClient {
  /// Creates a new [NextcloudClient] for a given [container] and [username].
  ///
  /// It is expected that the password of the user matches the its [username].
  /// This is the case for the available test docker containers.
  static Future<NextcloudClient> create(
    DockerContainer container, {
    String? username = 'user1',
  }) async {
    String? appPassword;
    if (username != null) {
      final inputStream = StreamController<List<int>>();
      final process = runExecutableArguments(
        'docker',
        [
          'exec',
          '-i',
          container.id,
          'php',
          '-f',
          'occ',
          'user:add-app-password',
          username,
        ],
        stdin: inputStream.stream,
      );
      inputStream.add(utf8.encode(username));
      await inputStream.close();

      final result = await process;
      if (result.exitCode != 0) {
        throw Exception('Failed to run generate app password command\n${result.stderr}\n${result.stdout}');
      }
      appPassword = (result.stdout as String).split('\n')[1];
    }

    return NextcloudClient(
      Uri(
        scheme: 'http',
        host: 'localhost',
        port: container.port,
      ),
      loginName: username,
      password: username,
      appPassword: appPassword,
      cookieJar: CookieJar(),
      httpClient: getProxyHttpClient(
        onRequest: appendFixture,
      ),
    );
  }
}
