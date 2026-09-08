import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schedule_fetcher/source_fetcher.dart';

Future<void> main() async {
  final client = http.Client();
  try {
    final configured = Platform.environment['SCHEDULE_SOURCE_BASE_URL']?.trim();
    final selected = await selectScheduleSource(
      httpClient: client,
      relayBaseUrl: configured == null || configured.isEmpty
          ? null
          : Uri.tryParse(configured),
      relayAuthorization: Platform.environment['SCHEDULE_SOURCE_AUTHORIZATION']
          ?.trim(),
    );
    stdout.writeln(
      jsonEncode({
        'base_url': selected.baseUrl.toString(),
        'uses_relay': selected.usesRelay,
      }),
    );
  } finally {
    client.close();
  }
}
