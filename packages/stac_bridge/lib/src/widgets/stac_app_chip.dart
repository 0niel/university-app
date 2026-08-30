import 'package:freezed_annotation/freezed_annotation.dart';

part 'stac_app_chip.freezed.dart';
part 'stac_app_chip.g.dart';

String _emptyWhenNotString(Object? value) => value is String ? value : '';

bool _falseWhenNotBool(Object? value) => value is bool && value;

@freezed
abstract class StacAppChip with _$StacAppChip {
  const factory StacAppChip({
    @JsonKey(fromJson: _emptyWhenNotString) required String label,
    @JsonKey(fromJson: _falseWhenNotBool) @Default(false) bool selected,
    @JsonKey(fromJson: _falseWhenNotBool) @Default(false) bool small,
    String? color,
    @JsonKey(name: 'onTap') Object? actionJson,
  }) = _StacAppChip;

  factory StacAppChip.fromJson(Map<String, dynamic> json) =>
      _$StacAppChipFromJson(json);
}
