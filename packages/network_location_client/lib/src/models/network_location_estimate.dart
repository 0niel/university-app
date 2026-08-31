import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_location_estimate.freezed.dart';

/// Оценка позиции, восстановленная по Wi-Fi окружению.
@freezed
abstract class NetworkLocationEstimate with _$NetworkLocationEstimate {
  /// Creates a Wi-Fi location estimate.
  const factory NetworkLocationEstimate({
    required double latitude,
    required double longitude,
    required double accuracyM,
  }) = _NetworkLocationEstimate;
}
