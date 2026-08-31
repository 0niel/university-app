import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_smart_chip.freezed.dart';
part 'stac_app_smart_chip.g.dart';

@freezed
abstract class StacAppSmartChip with _$StacAppSmartChip {
  const factory StacAppSmartChip({
    @JsonKey(fromJson: stringOrEmpty) required String emoji,
    @JsonKey(fromJson: stringOrEmpty) required String label,
    @JsonKey(fromJson: stringOrEmpty) required String value,
    String? tone,
  }) = _StacAppSmartChip;

  factory StacAppSmartChip.fromJson(Map<String, dynamic> json) =>
      _$StacAppSmartChipFromJson(json);
}

class StacAppSmartChipParser extends StacParser<StacAppSmartChip> {
  const StacAppSmartChipParser();

  @override
  String get type => 'appSmartChip';

  @override
  StacAppSmartChip getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppSmartChip model) {
    return AppSmartChip(
      emoji: model.emoji,
      label: model.label,
      value: model.value,
      tone: parseHexColor(model.tone) ?? context.colors.primary,
    );
  }
}
