import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart' show UsageException;
import 'package:http/http.dart' as http;
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';

const kScheduleBaseUrl = 'https://schedule-of.mirea.ru';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('ingest-url', help: 'Supabase Edge Function ingest URL.')
    ..addOption('ingest-key', help: 'Secret passed as x-ingest-key.')
    ..addOption(
      'supabase-api-key',
      help: 'Optional Supabase publishable/anon key for the Functions gateway.',
    )
    ..addOption(
      'organization',
      help: 'Organization/tenant id to write into the ingest payload.',
    )
    ..addOption(
      'schedule-base-url',
      defaultsTo: kScheduleBaseUrl,
      help: 'Base URL of a compatible schedule API.',
    )
    ..addOption(
      'source-id',
      defaultsTo: 'schedule-of.mirea.ru',
      help: 'Stable source identifier stored in Supabase.',
    )
    ..addOption(
      'source-name',
      defaultsTo: 'RTU MIREA schedule',
      help: 'Human-readable source name stored in Supabase.',
    )
    ..addOption(
      'source-organization-name',
      defaultsTo: 'RTU MIREA',
      help: 'Human-readable source organization name stored in Supabase.',
    )
    ..addOption(
      'source-timezone',
      defaultsTo: 'Europe/Moscow',
      help: 'IANA timezone used by the source.',
    )
    ..addOption('target-type', allowed: ['group', 'teacher', 'classroom'])
    ..addOption('match', help: 'Optional search query for partial sync.')
    ..addOption('skip', defaultsTo: '0', help: 'Matching targets to skip.')
    ..addOption('limit', help: 'Maximum targets to sync.')
    ..addOption('batch-size', defaultsTo: '1')
    ..addOption('target-part-batch-size', defaultsTo: '20')
    ..addOption('payload-output', help: 'Write each ingest payload to a file.')
    ..addOption(
      'ingest-transport',
      allowed: ['dart', 'deno'],
      defaultsTo: 'dart',
      help: 'HTTP transport used for posting to the ingest Edge Function.',
    )
    ..addFlag('dry-run')
    ..addFlag('help', abbr: 'h', negatable: false);

  final args = parser.parse(arguments);
  if (args.flag('help')) {
    stdout.writeln(parser.usage);
    return;
  }

  final ingestUrl = _requiredOption(
    args,
    'ingest-url',
    envName: 'SCHEDULE_INGEST_URL',
  );
  final ingestKey = _requiredOption(
    args,
    'ingest-key',
    envName: 'SCHEDULE_INGEST_KEY',
  );
  final supabaseApiKey = _optionalOption(
    args,
    'supabase-api-key',
    envName: 'SCHEDULE_SUPABASE_API_KEY',
  );
  final organizationId = _requiredOption(
    args,
    'organization',
    envName: 'SCHEDULE_ORGANIZATION_ID',
  );
  final scheduleBaseUrl = _httpsUri(
    args.option('schedule-base-url')!,
    'schedule-base-url',
  );
  final targetType = args.option('target-type');
  final match = args.option('match');
  final skip = _nonNegativeInt(args.option('skip')!, 'skip');
  final limit = _optionalPositiveInt(args.option('limit'), 'limit');
  final batchSize = _positiveInt(args.option('batch-size')!, 'batch-size');
  final targetPartBatchSize = _positiveInt(
    args.option('target-part-batch-size')!,
    'target-part-batch-size',
  );
  final payloadOutput = args.option('payload-output');
  final ingestTransport = args.option('ingest-transport')!;
  final dryRun = args.flag('dry-run');

  final client = http.Client();
  try {
    final sync = SyncMireaSchedule(
      httpClient: client,
      ingestUrl: Uri.parse(ingestUrl),
      ingestKey: ingestKey,
      supabaseApiKey: supabaseApiKey,
      organizationId: organizationId,
      batchSize: batchSize,
      targetPartBatchSize: targetPartBatchSize,
      payloadOutput: payloadOutput,
      ingestTransport: ingestTransport,
      dryRun: dryRun,
      scheduleBaseUrl: scheduleBaseUrl,
      sourceId: args.option('source-id')!,
      sourceName: args.option('source-name')!,
      sourceOrganizationName: args.option('source-organization-name')!,
      sourceTimezone: args.option('source-timezone')!,
    );
    await sync.run(
      targetType: targetType,
      match: match,
      skip: skip,
      limit: limit,
    );
  } finally {
    client.close();
  }
}

class SyncMireaSchedule {
  const SyncMireaSchedule({
    required this._httpClient,
    required this._ingestUrl,
    required this._ingestKey,
    required this._supabaseApiKey,
    required this._organizationId,
    required this._batchSize,
    required this._targetPartBatchSize,
    required this._payloadOutput,
    required this._ingestTransport,
    required this._dryRun,
    required this._scheduleBaseUrl,
    required this._sourceId,
    required this._sourceName,
    required this._sourceOrganizationName,
    required this._sourceTimezone,
  });

  final http.Client _httpClient;
  final Uri _ingestUrl;
  final String _ingestKey;
  final String? _supabaseApiKey;
  final String _organizationId;
  final int _batchSize;
  final int _targetPartBatchSize;
  final String? _payloadOutput;
  final String _ingestTransport;
  final bool _dryRun;
  final Uri _scheduleBaseUrl;
  final String _sourceId;
  final String _sourceName;
  final String _sourceOrganizationName;
  final String _sourceTimezone;

  Future<void> run({
    required String? targetType,
    required String? match,
    required int skip,
    required int? limit,
  }) async {
    final batch = <Map<String, Object?>>[];
    var seenMatching = 0;
    var handled = 0;
    var failed = 0;

    await for (final target in _fetchTargets(match: match)) {
      if (targetType != null && target.targetType != targetType) continue;
      seenMatching++;
      if (seenMatching <= skip) continue;
      if (limit != null && handled >= limit) break;

      try {
        final normalized = await _normalizeTarget(target);
        final parts = normalized['parts'];
        if (parts is! List<Object?>) {
          throw StateError('Normalized target has no parts list');
        }
        final chunks = _splitTargetPayload(normalized);
        handled++;

        stdout.writeln(
          'Prepared #$handled ${target.targetType}:${target.id} '
          '${target.fullTitle} parts=${parts.length} '
          'chunks=${chunks.length}',
        );

        for (final chunk in chunks) {
          batch.add(chunk);
          if (batch.length >= _batchSize) {
            try {
              await _flush(batch);
            } finally {
              batch.clear();
            }
          }
        }
      } on Object catch (error, stackTrace) {
        failed++;
        stderr
          ..writeln(
            'Failed ${target.targetType}:${target.id} ${target.fullTitle}: '
            '$error',
          )
          ..writeln(stackTrace);
      }
    }

    if (batch.isNotEmpty) {
      try {
        await _flush(batch);
      } on Object catch (error, stackTrace) {
        failed += batch.length;
        stderr
          ..writeln('Failed final batch size=${batch.length}: $error')
          ..writeln(stackTrace);
      } finally {
        batch.clear();
      }
    }

    stdout.writeln('Done. targets=$handled failed=$failed dryRun=$_dryRun');
  }

  Stream<_ScheduleTarget> _fetchTargets({required String? match}) async* {
    String? nextPageToken;
    do {
      final query = <String, String>{};
      if (nextPageToken != null) query['pageToken'] = nextPageToken;
      if (match != null && match.trim().isNotEmpty) {
        query['match'] = match.trim();
      }

      final uri = _scheduleBaseUrl
          .resolve('/schedule/api/search')
          .replace(queryParameters: query.isEmpty ? null : query);
      final response = await _httpClient
          .get(
            uri,
            headers: const {HttpHeaders.acceptHeader: 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != HttpStatus.ok) {
        throw StateError(
          'Schedule search failed: ${response.statusCode} ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, Object?>;
      nextPageToken = json['nextPageToken'] as String?;
      final data = json['data'] as List<Object?>? ?? const [];
      for (final item in data.whereType<Map<String, Object?>>()) {
        yield _ScheduleTarget.fromJson(item);
      }
    } while (nextPageToken != null);
  }

  Future<Map<String, Object?>> _normalizeTarget(_ScheduleTarget target) async {
    final calendarFeedUri = target.calendarFeedUri.replace(
      queryParameters: {
        ...target.calendarFeedUri.queryParameters,
        'includeMeta': 'true',
      },
    );
    final response = await _httpClient
        .get(
          calendarFeedUri,
          headers: const {HttpHeaders.acceptHeader: 'text/calendar,*/*'},
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != HttpStatus.ok) {
      throw StateError(
        'iCal fetch failed: ${response.statusCode} ${response.body}',
      );
    }

    final parts = ICalParser.fromString(
      response.body,
    ).parse().map((part) => part.toJson()).toList();

    return {
      'target_type': target.targetType,
      'external_id': target.id.toString(),
      'target_title': target.targetTitle,
      'full_title': target.fullTitle,
      'source_links': {
        'calendar_feed': target.calendarFeedLink,
        if (target.previewImageLink.isNotEmpty)
          'preview_image': target.previewImageLink,
        if (target.updatePreviewImageLink.isNotEmpty)
          'update_preview_image': target.updatePreviewImageLink,
        if (target.webLink.isNotEmpty) 'web': target.webLink,
      },
      'full_replace': true,
      'parts': parts,
      // Full set of this target's part UIDs (across all chunks) so the ingest
      // can reconcile vanished lessons (cancellations) without partial state.
      'source_uids': parts
          .map((part) => part['uid'])
          .whereType<String>()
          .toList(),
      'metadata': {'scheduleTarget': target.scheduleTarget},
    };
  }

  List<Map<String, Object?>> _splitTargetPayload(Map<String, Object?> target) {
    final parts = target['parts'];
    if (parts is! List || parts.length <= _targetPartBatchSize) {
      return [target];
    }

    final chunks = <Map<String, Object?>>[];
    for (
      var offset = 0;
      offset < parts.length;
      offset += _targetPartBatchSize
    ) {
      final end = offset + _targetPartBatchSize > parts.length
          ? parts.length
          : offset + _targetPartBatchSize;
      chunks.add({
        ...target,
        'full_replace': offset == 0,
        'parts': parts.sublist(offset, end),
      });
    }
    return chunks;
  }

  Future<void> _flush(List<Map<String, Object?>> targets) async {
    final body = jsonEncode({
      'entity': 'schedule',
      'organization_id': _organizationId,
      'source': {
        'source_type': 'schedule',
        'source_external_id': _sourceId,
        'source_name': _sourceName,
        'organization_name': _sourceOrganizationName,
        'timezone': _sourceTimezone,
      },
      'targets': targets,
    });
    if (_payloadOutput != null) {
      final file = File(_payloadOutput);
      await file.writeAsString(body);
      stdout.writeln('Wrote ingest payload to ${file.path}');
    }

    if (_dryRun) {
      final bodySize = utf8.encode(body).length;
      stdout.writeln(
        'Dry-run: skip ingest batch size=${targets.length} '
        'bodyBytes=$bodySize',
      );
      return;
    }

    if (_ingestTransport == 'deno') {
      await _flushWithDeno(body, targets.length);
      return;
    }

    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await _httpClient
            .post(
              _ingestUrl,
              headers: {
                HttpHeaders.acceptHeader: 'application/json',
                HttpHeaders.authorizationHeader: 'Bearer $_ingestKey',
                HttpHeaders.connectionHeader: 'close',
                HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
                HttpHeaders.userAgentHeader:
                    'university-app-schedule-fetcher/0.1',
                'apikey': ?_supabaseApiKey,
                'x-ingest-key': _ingestKey,
              },
              body: body,
            )
            .timeout(const Duration(seconds: 90));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          stdout.writeln(
            'Ingested batch size=${targets.length}: ${response.body}',
          );
          return;
        }

        if (attempt == 3 || response.statusCode < 500) {
          throw StateError(
            'Ingest failed: ${response.statusCode} ${response.body}',
          );
        }
      } catch (error) {
        if (attempt == 3 || !_isRetryableIngestError(error)) rethrow;
      }

      final delay = Duration(seconds: attempt * 2);
      stderr.writeln(
        'Retry ingest batch size=${targets.length} '
        'attempt=${attempt + 1} after ${delay.inSeconds}s',
      );
      await Future<void>.delayed(delay);
    }
  }

  Future<void> _flushWithDeno(String body, int targetCount) async {
    const script = r'''
const chunks = [];
for await (const chunk of Deno.stdin.readable) chunks.push(chunk);
const size = chunks.reduce((sum, chunk) => sum + chunk.length, 0);
const bytes = new Uint8Array(size);
let offset = 0;
for (const chunk of chunks) {
  bytes.set(chunk, offset);
  offset += chunk.length;
}
const headers = {
  "accept": "application/json",
  "authorization": `Bearer ${Deno.env.get("INGEST_KEY") ?? ""}`,
  "content-type": "application/json",
  "x-ingest-key": Deno.env.get("INGEST_KEY") ?? "",
};
const apiKey = Deno.env.get("SUPABASE_API_KEY");
if (apiKey) headers.apikey = apiKey;
const response = await fetch(Deno.env.get("INGEST_URL"), {
  method: "POST",
  headers,
  body: bytes,
});
const text = await response.text();
console.log(`${response.status} ${text}`);
if (!response.ok) Deno.exit(1);
''';

    for (var attempt = 1; attempt <= 3; attempt++) {
      final process = await Process.start(
        'deno',
        ['eval', script],
        environment: {
          'INGEST_URL': _ingestUrl.toString(),
          'INGEST_KEY': _ingestKey,
          'SUPABASE_API_KEY': ?_supabaseApiKey,
        },
      );

      process.stdin.write(body);
      await process.stdin.close();

      final (stdoutText, stderrText, exitCode) = await (
        utf8.decoder.bind(process.stdout).join(),
        utf8.decoder.bind(process.stderr).join(),
        process.exitCode,
      ).wait;

      if (exitCode == 0) {
        stdout.writeln('Ingested batch size=$targetCount: $stdoutText');
        return;
      }

      if (attempt == 3) {
        throw StateError(
          'Deno ingest failed with exitCode=$exitCode '
          'stdout=$stdoutText stderr=$stderrText',
        );
      }

      final delay = Duration(seconds: attempt * 2);
      stderr.writeln(
        'Retry deno ingest batch size=$targetCount '
        'attempt=${attempt + 1} after ${delay.inSeconds}s',
      );
      await Future<void>.delayed(delay);
    }
  }
}

class _ScheduleTarget {
  const _ScheduleTarget({
    required this.id,
    required this.targetTitle,
    required this.fullTitle,
    required this.scheduleTarget,
    required this.calendarFeedLink,
    required this.previewImageLink,
    required this.updatePreviewImageLink,
    required this.webLink,
  });

  factory _ScheduleTarget.fromJson(Map<String, Object?> json) {
    return _ScheduleTarget(
      id: _required(json, 'id'),
      targetTitle: _required(json, 'targetTitle'),
      fullTitle: _required(json, 'fullTitle'),
      scheduleTarget: _required(json, 'scheduleTarget'),
      calendarFeedLink: _required(json, 'iCalLink'),
      previewImageLink: json['scheduleImageLink'] as String? ?? '',
      updatePreviewImageLink: json['scheduleUpdateImageLink'] as String? ?? '',
      webLink: json['scheduleUIAddToCalendarLink'] as String? ?? '',
    );
  }

  final int id;
  final String targetTitle;
  final String fullTitle;
  final int scheduleTarget;
  final String calendarFeedLink;
  final String previewImageLink;
  final String updatePreviewImageLink;
  final String webLink;

  String get targetType {
    return switch (scheduleTarget) {
      1 => 'group',
      2 => 'teacher',
      3 => 'classroom',
      _ => throw StateError('Unsupported scheduleTarget=$scheduleTarget'),
    };
  }

  Uri get calendarFeedUri => Uri.parse(calendarFeedLink);
}

T _required<T>(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! T) throw FormatException('$key is missing or invalid');
  return value;
}

String _requiredOption(
  ArgResults args,
  String name, {
  required String envName,
}) {
  final value = args.option(name) ?? Platform.environment[envName];
  if (value == null || value.trim().isEmpty) {
    throw UsageException('Missing --$name or $envName.', '');
  }
  return value.trim();
}

String? _optionalOption(
  ArgResults args,
  String name, {
  required String envName,
}) {
  final value = args.option(name) ?? Platform.environment[envName];
  if (value == null || value.trim().isEmpty) return null;
  return value.trim();
}

int _positiveInt(String value, String name) {
  final parsed = int.tryParse(value);
  if (parsed == null || parsed < 1) {
    throw UsageException('--$name must be a positive integer.', '');
  }
  return parsed;
}

Uri _httpsUri(String value, String name) {
  final uri = Uri.tryParse(value);
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
    throw UsageException('--$name must be an absolute HTTPS URL.', '');
  }
  return uri;
}

int _nonNegativeInt(String value, String name) {
  final parsed = int.tryParse(value);
  if (parsed == null || parsed < 0) {
    throw UsageException('--$name must be a non-negative integer.', '');
  }
  return parsed;
}

int? _optionalPositiveInt(String? value, String name) {
  if (value == null || value.trim().isEmpty) return null;
  return _positiveInt(value, name);
}

bool _isRetryableIngestError(Object error) {
  return error is http.ClientException ||
      error is SocketException ||
      error is TimeoutException;
}
