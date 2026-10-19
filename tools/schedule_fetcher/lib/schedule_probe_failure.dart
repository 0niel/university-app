import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:schedule_fetcher/source_probe_failure.dart';
import 'package:schedule_fetcher/source_transport.dart';

class ScheduleProbeFailure implements Exception {
  const ScheduleProbeFailure({
    required this.stage,
    required this.category,
    this.status,
  });

  factory ScheduleProbeFailure.fromException(
    Exception error, {
    required ScheduleProbeStage stage,
    int? status,
  }) => ScheduleProbeFailure(
    stage: stage,
    category: switch (error) {
      TimeoutException() => ScheduleProbeCategory.timeout,
      SocketException() ||
      http.ClientException() => ScheduleProbeCategory.network,
      HandshakeException() => ScheduleProbeCategory.tls,
      FormatException() => ScheduleProbeCategory.invalidResponse,
      _ => ScheduleProbeCategory.unexpected,
    },
    status: status,
  );

  final ScheduleProbeStage stage;
  final ScheduleProbeCategory category;
  final int? status;

  bool get retryable => switch (category) {
    ScheduleProbeCategory.http =>
      status != null && isRetryableHttpStatus(status!),
    ScheduleProbeCategory.timeout || ScheduleProbeCategory.network => true,
    ScheduleProbeCategory.tls ||
    ScheduleProbeCategory.invalidResponse ||
    ScheduleProbeCategory.unexpected => false,
  };

  @override
  String toString() =>
      'ScheduleProbeFailure(stage=${stage.name}, category=${category.name}, '
      'status=${status?.toString() ?? 'none'})';

  String describe(ScheduleProbeSource source) {
    final categoryName = category == ScheduleProbeCategory.invalidResponse
        ? 'invalid_response'
        : category.name;
    return 'source=${source.name} stage=${stage.name} category=$categoryName'
        '${status == null ? '' : ' status=$status'}';
  }
}
