import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/src/widgets/stac_app_button.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppButtonParser extends StacParser<StacAppButton> {
  const StacAppButtonParser();

  @override
  String get type => 'appButton';

  @override
  StacAppButton getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppButton model) {
    return AppButton(
      label: model.label,
      variant: _variant(model.variant),
      size: _size(model.size),
      expanded: model.expanded,
      onPressed: actionCallback(context, model.actionJson),
    );
  }

  AppButtonVariant _variant(String name) {
    return AppButtonVariant.values.firstWhere(
      (variant) => variant.name == name,
      orElse: () => AppButtonVariant.primary,
    );
  }

  AppButtonSize _size(String name) {
    return AppButtonSize.values.firstWhere(
      (size) => size.name == name,
      orElse: () => AppButtonSize.medium,
    );
  }
}
