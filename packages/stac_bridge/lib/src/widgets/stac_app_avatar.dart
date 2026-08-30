import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_avatar.freezed.dart';
part 'stac_app_avatar.g.dart';

double _avatarSizeFromJson(Object? value) =>
    value is num ? value.toDouble() : 36;

@freezed
abstract class StacAppAvatar with _$StacAppAvatar {
  const factory StacAppAvatar({
    @JsonKey(fromJson: stringOrEmpty) required String name,
    @JsonKey(fromJson: _avatarSizeFromJson) @Default(36) double size,
    @JsonKey(fromJson: stringOrNull) String? color,
  }) = _StacAppAvatar;

  factory StacAppAvatar.fromJson(Map<String, dynamic> json) =>
      _$StacAppAvatarFromJson(json);
}

class StacAppAvatarParser extends StacParser<StacAppAvatar> {
  const StacAppAvatarParser();

  @override
  String get type => 'appAvatar';

  @override
  StacAppAvatar getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppAvatar model) {
    return AppAvatar(
      name: model.name,
      size: model.size,
      color: parseHexColor(model.color),
    );
  }
}
