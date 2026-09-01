import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart' show UsageException;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:rtu_mirea_schedule_api_client/rtu_mirea_schedule_api_client.dart';

const kScheduleBaseUrl = 'https://schedule-of.mirea.ru';
const _minimumFullSyncTargetCounts = {
  'group': 750,
  'teacher': 1100,
  'classroom': 550,
};
const _minimumFullSyncDatedParts = 10000;
const _maximumFullSyncUndatedRatio = 0.05;
const _fullReingestInterval = Duration(hours: 24);

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
    ..addOption('fetch-concurrency', defaultsTo: '8')
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
  final fetchConcurrency = _positiveInt(
    args.option('fetch-concurrency')!,
    'fetch-concurrency',
  );
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
      fetchConcurrency: fetchConcurrency,
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
  SyncMireaSchedule({
    required this._httpClient,
    required this._ingestUrl,
    required this._ingestKey,
    required this._supabaseApiKey,
    required this._organizationId,
    required this._batchSize,
    required this._fetchConcurrency,
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
  final int _fetchConcurrency;
  final int _targetPartBatchSize;
  final String? _payloadOutput;
  final String _ingestTransport;
  final bool _dryRun;
  final Uri _scheduleBaseUrl;
  final String _sourceId;
  final String _sourceName;
  final String _sourceOrganizationName;
  final String _sourceTimezone;
  String? _syncRunId;
  Map<String, String> _previousTargetHashes = const {};
  DateTime? _lastFullReingestAt;
  var _reingestUnchanged = true;

  Future<void> run({
    required String? targetType,
    required String? match,
    required int skip,
    required int? limit,
  }) async {
    final fullSync =
        targetType == null &&
        (match == null || match.trim().isEmpty) &&
        skip == 0 &&
        limit == null;
    if (!_dryRun) {
      final started = await _startSync(fullSync: fullSync);
      _syncRunId = started.syncRunId;
      _previousTargetHashes = started.targetHashes;
      _lastFullReingestAt = started.lastFullReingestAt;
      final lastFullReingestAt = _lastFullReingestAt;
      _reingestUnchanged =
          !fullSync ||
          lastFullReingestAt == null ||
          DateTime.now().toUtc().difference(lastFullReingestAt) >=
              _fullReingestInterval;
    }

    try {
      final result = await _syncTargets(
        targetType: targetType,
        match: match,
        skip: skip,
        limit: limit,
        enforceCoverage: fullSync,
      );
      if (result.failed > 0) {
        throw StateError('Schedule sync incomplete: ${result.failed} failures');
      }
      if (fullSync) {
        if (result.datedParts < _minimumFullSyncDatedParts) {
          throw StateError(
            'Schedule dated part coverage is below threshold: '
            '${result.datedParts} minimum=$_minimumFullSyncDatedParts',
          );
        }
        final totalParts = result.datedParts + result.undatedParts;
        if (totalParts > 0 &&
            result.undatedParts / totalParts > _maximumFullSyncUndatedRatio) {
          throw StateError(
            'Schedule undated part ratio is above threshold: '
            '${result.undatedParts}/$totalParts',
          );
        }
      }
      if (_syncRunId != null) {
        final completedAt = DateTime.now().toUtc();
        final checkpointHashes = fullSync
            ? result.targetHashes
            : {..._previousTargetHashes, ...result.targetHashes};
        await _finishSync(
          status: 'succeeded',
          checkpoint: {
            'completed_at': completedAt.toIso8601String(),
            'targets': result.handled,
            'targets_ingested': result.ingested,
            'target_counts': result.targetCounts,
            'part_counts': {
              'dated': result.datedParts,
              'undated': result.undatedParts,
            },
            'target_hashes': checkpointHashes,
            'last_full_reingest_at': fullSync && _reingestUnchanged
                ? completedAt.toIso8601String()
                : _lastFullReingestAt?.toIso8601String(),
            'full_sync': fullSync,
          },
        );
      }
    } on Object catch (error, stackTrace) {
      if (_syncRunId != null) {
        try {
          await _finishSync(status: 'failed', errorMessage: '$error');
        } on Object catch (finishError) {
          stderr.writeln('Failed to record sync failure: $finishError');
        }
      }
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _syncRunId = null;
      _previousTargetHashes = const {};
      _lastFullReingestAt = null;
      _reingestUnchanged = true;
    }
  }

  Future<
    ({
      int handled,
      int ingested,
      int failed,
      int datedParts,
      int undatedParts,
      Map<String, int> targetCounts,
      Map<String, String> targetHashes,
    })
  >
  _syncTargets({
    required String? targetType,
    required String? match,
    required int skip,
    required int? limit,
    required bool enforceCoverage,
  }) async {
    final batch = <Map<String, Object?>>[];
    final targets = <_ScheduleTarget>[];
    var seenMatching = 0;
    var handled = 0;
    var ingested = 0;
    var failed = 0;
    var datedParts = 0;
    var undatedParts = 0;
    final targetHashes = <String, String>{};

    await for (final target in _fetchTargets(match: match)) {
      if (targetType != null && target.targetType != targetType) continue;
      seenMatching++;
      if (seenMatching <= skip) continue;
      if (limit != null && targets.length >= limit) break;
      targets.add(target);
    }

    final targetCounts = {
      for (final type in _minimumFullSyncTargetCounts.keys)
        type: targets.where((target) => target.targetType == type).length,
    };
    if (enforceCoverage) {
      for (final entry in _minimumFullSyncTargetCounts.entries) {
        if (targetCounts[entry.key]! < entry.value) {
          throw StateError(
            'Schedule target coverage is below threshold: '
            '${entry.key}=${targetCounts[entry.key]} minimum=${entry.value}',
          );
        }
      }
    }

    for (var offset = 0; offset < targets.length; offset += _fetchConcurrency) {
      final end = offset + _fetchConcurrency > targets.length
          ? targets.length
          : offset + _fetchConcurrency;
      final preparedTargets = await Future.wait(
        targets.sublist(offset, end).map(_prepareTarget),
      );

      for (final prepared in preparedTargets) {
        final target = prepared.target;
        if (prepared.error != null) {
          failed++;
          stderr
            ..writeln(
              'Failed ${target.targetType}:${target.id} ${target.fullTitle}: '
              '${prepared.error}',
            )
            ..writeln(prepared.stackTrace);
          continue;
        }

        try {
          final normalized = prepared.normalized!;
          final parts = normalized['parts'];
          if (parts is! List<Object?>) {
            throw StateError('Normalized target has no parts list');
          }
          final metadata = normalized['metadata'];
          final currentUndated = metadata is Map<String, Object?>
              ? metadata['undated_parts'] as int? ?? 0
              : 0;
          datedParts += parts.length;
          undatedParts += currentUndated;
          final sourceHash = metadata is Map<String, Object?>
              ? metadata['source_hash'] as String?
              : null;
          if (sourceHash == null) {
            throw StateError('Normalized target has no source hash');
          }
          final targetKey = '${target.targetType}:${target.id}';
          targetHashes[targetKey] = sourceHash;
          handled++;
          if (!_reingestUnchanged &&
              _previousTargetHashes[targetKey] == sourceHash) {
            stdout.writeln(
              'Unchanged #$handled ${target.targetType}:${target.id} '
              '${target.fullTitle} parts=${parts.length} '
              'undated=$currentUndated',
            );
            continue;
          }
          final chunks = _splitTargetPayload(normalized);
          ingested++;

          stdout.writeln(
            'Prepared #$handled ${target.targetType}:${target.id} '
            '${target.fullTitle} parts=${parts.length} '
            'undated=$currentUndated chunks=${chunks.length}',
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
    return (
      handled: handled,
      ingested: ingested,
      failed: failed,
      datedParts: datedParts,
      undatedParts: undatedParts,
      targetCounts: targetCounts,
      targetHashes: targetHashes,
    );
  }

  Future<_PreparedTarget> _prepareTarget(_ScheduleTarget target) async {
    try {
      return _PreparedTarget(
        target: target,
        normalized: await _normalizeTarget(target),
      );
    } on Object catch (error, stackTrace) {
      return _PreparedTarget(
        target: target,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<
    ({
      String syncRunId,
      Map<String, String> targetHashes,
      DateTime? lastFullReingestAt,
    })
  >
  _startSync({required bool fullSync}) async {
    final response = await _postControl({
      'entity': 'sync_start',
      'organization_id': _organizationId,
      'source': _sourceId,
      'source_type': 'schedule',
      'metadata': {'full_sync': fullSync},
    });
    final result = response['result'];
    if (result is! Map<String, Object?> || result['sync_run_id'] is! String) {
      throw StateError('Sync start response has no sync_run_id');
    }
    final checkpoint = result['checkpoint'];
    final checkpointMap = checkpoint is Map<String, Object?>
        ? checkpoint
        : const <String, Object?>{};
    final rawHashes = checkpointMap['target_hashes'];
    final targetHashes =
        (rawHashes is Map<String, Object?>
              ? rawHashes.map(
                  (key, value) => MapEntry(key, value is String ? value : ''),
                )
              : <String, String>{})
          ..removeWhere((_, value) => value.isEmpty);
    final rawReingestAt = checkpointMap['last_full_reingest_at'];
    return (
      syncRunId: result['sync_run_id']! as String,
      targetHashes: targetHashes,
      lastFullReingestAt: rawReingestAt is String
          ? DateTime.tryParse(rawReingestAt)?.toUtc()
          : null,
    );
  }

  Future<void> _finishSync({
    required String status,
    Map<String, Object?>? checkpoint,
    String? errorMessage,
  }) async {
    final boundedError = errorMessage != null && errorMessage.length > 2000
        ? errorMessage.substring(0, 2000)
        : errorMessage;
    await _postControl({
      'entity': 'sync_finish',
      'organization_id': _organizationId,
      'sync_run_id': _syncRunId,
      'source': _sourceId,
      'source_type': 'schedule',
      'status': status,
      'checkpoint': checkpoint,
      'error_message': boundedError,
      'metadata': const <String, Object?>{},
    });
  }

  Future<Map<String, Object?>> _postControl(
    Map<String, Object?> payload,
  ) async {
    final response = await _postIngest(
      jsonEncode(payload),
      label: payload['entity']! as String,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?>) {
      throw StateError('Ingest control response is not a JSON object');
    }
    return decoded;
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
      final response = await _getWithRetry(
        uri,
        accept: 'application/json',
        timeout: const Duration(seconds: 45),
        label: 'schedule search',
      );

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
    final sourceUri = target.calendarFeedUri;
    if (sourceUri.scheme != 'https' ||
        sourceUri.host.toLowerCase() != _scheduleBaseUrl.host.toLowerCase() ||
        sourceUri.port != _scheduleBaseUrl.port ||
        sourceUri.userInfo.isNotEmpty ||
        sourceUri.fragment.isNotEmpty ||
        !sourceUri.path.startsWith('/schedule/api/ical/')) {
      throw const FormatException('Invalid iCal source URL');
    }
    final calendarFeedUri = sourceUri.replace(
      queryParameters: {
        ...sourceUri.queryParameters,
        'includeMeta': 'true',
      },
    );
    final response = await _getWithRetry(
      calendarFeedUri,
      accept: 'text/calendar,*/*',
      timeout: const Duration(seconds: 60),
      label: 'iCal fetch',
    );

    if (response.statusCode != HttpStatus.ok) {
      throw StateError(
        'iCal fetch failed: ${response.statusCode} ${response.body}',
      );
    }

    final parsedParts = ICalParser.fromString(
      response.body,
    ).parse().map((part) => part.toJson()).toList();
    final parts = parsedParts.where((part) {
      final dates = part['dates'];
      return dates is List && dates.isNotEmpty;
    }).toList();
    final undatedParts = parsedParts.length - parts.length;
    final sourceHash = sha256
        .convert(
          utf8.encode(
            '${target.targetType}\n${target.id}\n${target.targetTitle}\n'
            '${target.fullTitle}\n${target.calendarFeedLink}\n${response.body}',
          ),
        )
        .toString();

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
      'source_uids': parts
          .map((part) => part['uid'])
          .whereType<String>()
          .toList(),
      'metadata': {
        'scheduleTarget': target.scheduleTarget,
        'raw_parts': parsedParts.length,
        'undated_parts': undatedParts,
        'source_hash': sourceHash,
      },
    };
  }

  Future<http.Response> _getWithRetry(
    Uri uri, {
    required String accept,
    required Duration timeout,
    required String label,
  }) async {
    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await _httpClient
            .get(
              uri,
              headers: {
                HttpHeaders.acceptHeader: accept,
                HttpHeaders.userAgentHeader:
                    'university-app-schedule-fetcher/0.1',
              },
            )
            .timeout(timeout);
        if (!_isRetryableStatus(response.statusCode) || attempt == 3) {
          return response;
        }
      } on Object catch (error) {
        if (attempt == 3 || !_isRetryableIngestError(error)) rethrow;
      }

      final delay = Duration(seconds: attempt * 2);
      stderr.writeln(
        'Retry $label attempt=${attempt + 1} after ${delay.inSeconds}s',
      );
      await Future<void>.delayed(delay);
    }
    throw StateError('$label retry loop ended unexpectedly');
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
      'sync_run_id': _syncRunId,
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

    final response = await _postIngest(
      body,
      label: 'schedule batch size=${targets.length}',
    );
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, Object?>) {
      throw StateError('Schedule ingest response is not a JSON object');
    }
    final result = decoded['result'];
    if (result is! Map<String, Object?>) {
      throw StateError('Schedule ingest response has no result object');
    }
    final skipped = result['items_skipped'];
    if (skipped is int && skipped > 0) {
      throw StateError('Schedule ingest skipped $skipped items');
    }
    stdout.writeln('Ingested batch size=${targets.length}: ${response.body}');
  }

  Future<http.Response> _postIngest(
    String body, {
    required String label,
  }) async {
    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await _httpClient
            .post(_ingestUrl, headers: _ingestHeaders, body: body)
            .timeout(const Duration(seconds: 90));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        if (attempt == 3 || !_isRetryableStatus(response.statusCode)) {
          throw StateError(
            '$label failed: ${response.statusCode} ${response.body}',
          );
        }
      } catch (error) {
        if (attempt == 3 || !_isRetryableIngestError(error)) rethrow;
      }

      final delay = Duration(seconds: attempt * 2);
      stderr.writeln(
        'Retry $label '
        'attempt=${attempt + 1} after ${delay.inSeconds}s',
      );
      await Future<void>.delayed(delay);
    }
    throw StateError('$label retry loop ended unexpectedly');
  }

  Map<String, String> get _ingestHeaders => {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $_ingestKey',
    HttpHeaders.connectionHeader: 'close',
    HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
    HttpHeaders.userAgentHeader: 'university-app-schedule-fetcher/0.1',
    'apikey': ?_supabaseApiKey,
    'x-ingest-key': _ingestKey,
  };

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
console.log(JSON.stringify({ status: response.status, body: text }));
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
        final transportResult = jsonDecode(stdoutText.trim());
        if (transportResult is! Map<String, Object?> ||
            transportResult['body'] is! String) {
          throw StateError('Deno ingest response is invalid');
        }
        final responseBody = transportResult['body']! as String;
        final decoded = jsonDecode(responseBody);
        if (decoded is! Map<String, Object?>) {
          throw StateError('Schedule ingest response is not a JSON object');
        }
        final result = decoded['result'];
        if (result is! Map<String, Object?>) {
          throw StateError('Schedule ingest response has no result object');
        }
        final skipped = result['items_skipped'];
        if (skipped is int && skipped > 0) {
          throw StateError('Schedule ingest skipped $skipped items');
        }
        stdout.writeln('Ingested batch size=$targetCount: $responseBody');
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

class _PreparedTarget {
  const _PreparedTarget({
    required this.target,
    this.normalized,
    this.error,
    this.stackTrace,
  });

  final _ScheduleTarget target;
  final Map<String, Object?>? normalized;
  final Object? error;
  final StackTrace? stackTrace;
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

bool _isRetryableStatus(int statusCode) {
  return statusCode == HttpStatus.tooManyRequests || statusCode >= 500;
}
