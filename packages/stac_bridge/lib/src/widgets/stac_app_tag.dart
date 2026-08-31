import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_tag.freezed.dart';
part 'stac_app_tag.g.dart';

String _muteWhenNotString(Object? value) {
  return value is String ? value : 'mute';
}

@freezed
abstract class StacAppTag with _$StacAppTag {
  const factory StacAppTag({
    @JsonKey(fromJson: stringOrEmpty) required String label,
    @JsonKey(fromJson: _muteWhenNotString) @Default('mute') String tone,
    @JsonKey(fromJson: boolOrFalse) @Default(false) bool withDot,
  }) = _StacAppTag;

  factory StacAppTag.fromJson(Map<String, dynamic> json) =>
      _$StacAppTagFromJson(json);
}

class StacAppTagParser extends StacParser<StacAppTag> {
  const StacAppTagParser();

  @override
  String get type => 'appTag';

  @override
  StacAppTag getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppTag model) {
    return AppTag(
      label: model.label,
      tone: AppTagTone.values.firstWhere(
        (tone) => tone.name == model.tone,
        orElse: () => AppTagTone.mute,
      ),
      leading: model.withDot ? const AppLiveDot() : null,
    );
  }
}
