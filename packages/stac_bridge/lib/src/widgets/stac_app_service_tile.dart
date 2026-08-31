import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_service_tile.freezed.dart';
part 'stac_app_service_tile.g.dart';

@freezed
abstract class StacAppServiceTile with _$StacAppServiceTile {
  const factory StacAppServiceTile({
    @JsonKey(fromJson: stringOrEmpty) required String emoji,
    String? label,
    String? color,
    @JsonKey(fromJson: boolOrFalse) @Default(false) bool solid,
    @JsonKey(name: 'onTap') Object? actionJson,
  }) = _StacAppServiceTile;

  factory StacAppServiceTile.fromJson(Map<String, dynamic> json) =>
      _$StacAppServiceTileFromJson(json);
}

class StacAppServiceTileParser extends StacParser<StacAppServiceTile> {
  const StacAppServiceTileParser();

  @override
  String get type => 'appServiceTile';

  @override
  StacAppServiceTile getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppServiceTile model) {
    return AppServiceTile(
      emoji: model.emoji,
      color: parseHexColor(model.color) ?? context.colors.primary,
      label: model.label,
      solid: model.solid,
      onTap: actionCallback(context, model.actionJson),
    );
  }
}
