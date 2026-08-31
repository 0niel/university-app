import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';

part 'stac_app_empty_state.freezed.dart';
part 'stac_app_empty_state.g.dart';

String _sparklesWhenNotString(Object? value) {
  return value is String ? value : '✨';
}

@freezed
abstract class StacAppEmptyState with _$StacAppEmptyState {
  const factory StacAppEmptyState({
    @JsonKey(fromJson: _sparklesWhenNotString) required String emoji,
    @JsonKey(fromJson: stringOrEmpty) required String title,
    String? subtitle,
    Object? child,
  }) = _StacAppEmptyState;

  factory StacAppEmptyState.fromJson(Map<String, dynamic> json) =>
      _$StacAppEmptyStateFromJson(json);
}
