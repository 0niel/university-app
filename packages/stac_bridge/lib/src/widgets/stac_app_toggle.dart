import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_toggle.freezed.dart';
part 'stac_app_toggle.g.dart';

@freezed
abstract class StacAppToggle with _$StacAppToggle {
  const factory StacAppToggle({
    @JsonKey(fromJson: boolOrFalse) @Default(false) bool value,
    @JsonKey(name: 'onChange') Object? actionJson,
  }) = _StacAppToggle;

  factory StacAppToggle.fromJson(Map<String, dynamic> json) =>
      _$StacAppToggleFromJson(json);
}

class StacAppToggleParser extends StacParser<StacAppToggle> {
  const StacAppToggleParser();

  @override
  String get type => 'appToggle';

  @override
  StacAppToggle getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppToggle model) {
    final action = actionCallback(context, model.actionJson);
    return AppToggle(
      value: model.value,
      onChanged: action == null ? null : (_) => action(),
    );
  }
}
