import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacDividerKitParser extends StacParser<KitModel> {
  const StacDividerKitParser();

  @override
  String get type => 'divider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppDivider(
    indent: doubleOr(model, 'indent', 0),
    endIndent: doubleOr(model, 'endIndent', 0),
    color: colorOf(context, model, 'color'),
  );
}
