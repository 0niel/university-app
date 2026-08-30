import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_line_icon.freezed.dart';
part 'stac_app_line_icon.g.dart';

double _iconSizeFromJson(Object? value) => value is num ? value.toDouble() : 22;

AppLineIcon? appLineIconByName(String? name) {
  for (final icon in AppLineIcon.values) {
    if (icon.name == name) return icon;
  }
  return null;
}

@freezed
abstract class StacAppLineIcon with _$StacAppLineIcon {
  const factory StacAppLineIcon({
    @JsonKey(fromJson: stringOrEmpty) required String icon,
    @JsonKey(fromJson: _iconSizeFromJson) @Default(22) double size,
    @JsonKey(fromJson: stringOrNull) String? color,
  }) = _StacAppLineIcon;

  factory StacAppLineIcon.fromJson(Map<String, dynamic> json) =>
      _$StacAppLineIconFromJson(json);
}

class StacAppLineIconParser extends StacParser<StacAppLineIcon> {
  const StacAppLineIconParser();

  @override
  String get type => 'appLineIcon';

  @override
  StacAppLineIcon getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppLineIcon model) {
    final icon = appLineIconByName(model.icon);
    if (icon == null) return const SizedBox.shrink();
    return AppLineIconWidget(
      icon,
      size: model.size,
      color: parseHexColor(model.color),
    );
  }
}
