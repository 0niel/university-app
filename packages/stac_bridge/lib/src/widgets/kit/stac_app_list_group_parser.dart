import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppListGroupParser extends StacParser<KitModel> {
  const StacAppListGroupParser();

  @override
  String get type => 'appListGroup';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppListGroup(
    radius: doubleOr(model, 'radius', AppRadius.card),
    color: colorOf(context, model, 'color'),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    dividerIndent: doubleOr(model, 'dividerIndent', 0),
    showDividers: boolOf(model, 'showDividers', fallback: true),
    children: childrenWidgets(context, model['children']),
  );
}
