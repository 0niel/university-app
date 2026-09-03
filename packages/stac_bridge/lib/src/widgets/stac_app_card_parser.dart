import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_bridge/src/widgets/stac_app_card.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppCardParser extends StacParser<StacAppCard> {
  const StacAppCardParser();

  @override
  String get type => 'appCard';

  @override
  StacAppCard getModel(Map<String, dynamic> json) => .fromJson(json);

  @override
  Widget parse(BuildContext context, StacAppCard model) {
    return AppCard(
      color: parseAppColor(context, model.color),
      onTap: actionCallback(context, model.actionJson),
      padding: .all(model.padding),
      child: childWidget(context, model.child) ?? const SizedBox.shrink(),
    );
  }
}
