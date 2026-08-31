import 'package:freezed_annotation/freezed_annotation.dart';

part 'stac_app_button.freezed.dart';
part 'stac_app_button.g.dart';

String _emptyWhenNotString(Object? value) => value is String ? value : '';

String _primaryWhenNotString(Object? value) {
  return value is String ? value : 'primary';
}

String _mediumWhenNotString(Object? value) {
  return value is String ? value : 'medium';
}

bool _falseWhenNotBool(Object? value) => value is bool && value;

@freezed
abstract class StacAppButton with _$StacAppButton {
  const factory StacAppButton({
    @JsonKey(fromJson: _emptyWhenNotString) required String label,
    @JsonKey(fromJson: _primaryWhenNotString)
    @Default('primary')
    String variant,
    @JsonKey(fromJson: _mediumWhenNotString) @Default('medium') String size,
    @JsonKey(fromJson: _falseWhenNotBool) @Default(false) bool expanded,
    @JsonKey(name: 'onPressed') Object? actionJson,
  }) = _StacAppButton;

  factory StacAppButton.fromJson(Map<String, dynamic> json) =>
      _$StacAppButtonFromJson(json);
}
