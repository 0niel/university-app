import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_avatar_stack.freezed.dart';
part 'stac_app_avatar_stack.g.dart';

double _avatarStackSizeFromJson(Object? value) {
  return value is num ? value.toDouble() : 36;
}

@freezed
abstract class StacAppAvatarStack with _$StacAppAvatarStack {
  const factory StacAppAvatarStack({
    @JsonKey(fromJson: stringListOrEmpty) required List<String> names,
    @JsonKey(fromJson: _avatarStackSizeFromJson) @Default(36) double size,
  }) = _StacAppAvatarStack;

  factory StacAppAvatarStack.fromJson(Map<String, dynamic> json) =>
      _$StacAppAvatarStackFromJson(json);
}

class StacAppAvatarStackParser extends StacParser<StacAppAvatarStack> {
  const StacAppAvatarStackParser();

  @override
  String get type => 'appAvatarStack';

  @override
  StacAppAvatarStack getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppAvatarStack model) {
    return AppAvatarStack(names: model.names, size: model.size);
  }
}
