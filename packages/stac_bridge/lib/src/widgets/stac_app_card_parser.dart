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
    final colors = Theme.of(context).colors;
    final radius = BorderRadius.circular(AppRadius.lg);
    return Material(
      color: parseHexColor(model.color) ?? colors.surface,
      borderRadius: radius,
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: actionCallback(context, model.actionJson),
        child: Padding(
          padding: .all(model.padding),
          child: childWidget(context, model.child) ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
