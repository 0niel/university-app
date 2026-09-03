import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_progress_ring.freezed.dart';
part 'stac_app_progress_ring.g.dart';

double _zeroWhenNotNumber(Object? value) => value is num ? value.toDouble() : 0;

double _ringSizeFromJson(Object? value) => value is num ? value.toDouble() : 56;

double _strokeWidthFromJson(Object? value) {
  return value is num ? value.toDouble() : 5;
}

@freezed
abstract class StacAppProgressRing with _$StacAppProgressRing {
  const factory StacAppProgressRing({
    @JsonKey(fromJson: _zeroWhenNotNumber) required double value,
    @JsonKey(fromJson: _ringSizeFromJson) @Default(56) double size,
    @JsonKey(fromJson: _strokeWidthFromJson) @Default(5) double strokeWidth,
    @JsonKey(fromJson: stringOrNull) String? color,
    @JsonKey(fromJson: stringOrNull) String? label,
    @JsonKey(fromJson: stringOrNull) String? sublabel,
  }) = _StacAppProgressRing;

  factory StacAppProgressRing.fromJson(Map<String, dynamic> json) =>
      _$StacAppProgressRingFromJson(json);
}

class StacAppProgressRingParser extends StacParser<StacAppProgressRing> {
  const StacAppProgressRingParser();

  @override
  String get type => 'appProgressRing';

  @override
  StacAppProgressRing getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppProgressRing model) {
    return AppProgressRing(
      value: model.value,
      size: model.size,
      strokeWidth: model.strokeWidth,
      color: parseAppColor(context, model.color),
      label: model.label,
      sublabel: model.sublabel,
    );
  }
}
