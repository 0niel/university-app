import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac_bridge/src/widgets/json_value_converters.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/src/widgets/stac_app_line_icon.dart';
import 'package:stac_framework/stac_framework.dart';

part 'stac_app_icon_button.freezed.dart';
part 'stac_app_icon_button.g.dart';

String _ghostWhenNotString(Object? value) {
  return value is String ? value : 'ghost';
}

String _mediumWhenNotString(Object? value) {
  return value is String ? value : 'medium';
}

@freezed
abstract class StacAppIconButton with _$StacAppIconButton {
  const factory StacAppIconButton({
    @JsonKey(fromJson: stringOrEmpty) required String icon,
    @JsonKey(fromJson: _ghostWhenNotString) @Default('ghost') String variant,
    @JsonKey(fromJson: _mediumWhenNotString) @Default('medium') String size,
    @JsonKey(fromJson: stringOrNull) String? tooltip,
    @JsonKey(name: 'onPressed') Object? actionJson,
  }) = _StacAppIconButton;

  factory StacAppIconButton.fromJson(Map<String, dynamic> json) =>
      _$StacAppIconButtonFromJson(json);
}

class StacAppIconButtonParser extends StacParser<StacAppIconButton> {
  const StacAppIconButtonParser();

  @override
  String get type => 'appIconButton';

  @override
  StacAppIconButton getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppIconButton model) {
    final icon = appLineIconByName(model.icon);
    if (icon == null) return const SizedBox.shrink();
    return AppIconButton(
      icon: AppLineIconWidget(icon),
      tooltip: model.tooltip,
      tone: switch (model.variant) {
        'primary' => AppIconButtonTone.primary,
        'tonal' => AppIconButtonTone.tonal,
        'danger' || 'destructive' => AppIconButtonTone.danger,
        'secondary' || 'outline' => AppIconButtonTone.secondary,
        _ => AppIconButtonTone.plain,
      },
      size: switch (model.size) {
        'small' => AppIconButtonSize.small,
        'compact' => AppIconButtonSize.compact,
        _ => AppIconButtonSize.regular,
      },
      onPressed: actionCallback(context, model.actionJson),
    );
  }
}
