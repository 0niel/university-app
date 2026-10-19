import 'package:http/http.dart' as http;
import 'package:schedule_fetcher/schedule_source_selection.dart';
import 'package:schedule_fetcher/source_probe.dart';
import 'package:schedule_fetcher/source_probe_failure.dart';
import 'package:schedule_fetcher/source_transport.dart';

export 'package:schedule_fetcher/schedule_source_selection.dart';

Future<ScheduleSourceSelection> selectScheduleSource({
  required http.Client httpClient,
  Uri? relayBaseUrl,
  String? relayAuthorization,
  Duration timeout = const Duration(seconds: 10),
  Duration relayWarmupTimeout = const Duration(seconds: 90),
  RetryDelay? delay,
  RetryLog? log,
  UtcClock? clock,
}) async {
  if (timeout <= Duration.zero || relayWarmupTimeout <= Duration.zero) {
    throw ArgumentError('Schedule probe timeouts must be positive');
  }
  final wait = delay ?? Future<void>.delayed;
  final now = clock ?? (() => DateTime.now().toUtc());
  final probe = ScheduleSourceProbe(
    httpClient: httpClient,
    timeout: timeout,
    clock: now,
  );
  final ScheduleProbeFailure officialFailure;
  try {
    await probe.check(officialScheduleUri, null);
    return ScheduleSourceSelection(
      baseUrl: officialScheduleUri,
      usesRelay: false,
    );
  } on ScheduleProbeFailure catch (failure, stackTrace) {
    officialFailure = failure;
    log?.call(
      'Schedule probe ${failure.describe(ScheduleProbeSource.official)}',
    );
    if (relayBaseUrl == null || relayBaseUrl.host == officialScheduleUri.host) {
      Error.throwWithStackTrace(
        StateError(
          'Official schedule source is unavailable; no relay configured; '
          '${failure.describe(ScheduleProbeSource.official)}',
        ),
        stackTrace,
      );
    }
  }

  final deadline = now().add(relayWarmupTimeout);
  for (var attempt = 1; ; attempt++) {
    try {
      await probe.check(relayBaseUrl, relayAuthorization, deadline: deadline);
      return ScheduleSourceSelection(baseUrl: relayBaseUrl, usesRelay: true);
    } on ScheduleProbeFailure catch (failure, stackTrace) {
      log?.call(
        'Schedule probe ${failure.describe(ScheduleProbeSource.relay)} '
        'attempt=$attempt',
      );
      const retryDelay = Duration(seconds: 5);
      if (!failure.retryable || deadline.difference(now()) <= retryDelay) {
        Error.throwWithStackTrace(
          StateError(
            'Neither official schedule source nor relay passed health checks; '
            '${officialFailure.describe(ScheduleProbeSource.official)}; '
            '${failure.describe(ScheduleProbeSource.relay)}',
          ),
          stackTrace,
        );
      }
      await wait(retryDelay);
    }
  }
}
