import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/src/widgets/stac_app_chip.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppChipParser extends StacParser<StacAppChip> {
  const StacAppChipParser();

  @override
  String get type => 'appChip';

  @override
  StacAppChip getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppChip model) {
    return AppFilterChip(
      label: model.label,
      isSelected: model.selected,
      color: parseAppColor(context, model.color),
      onTap: actionCallback(context, model.actionJson),
    );
  }
}
