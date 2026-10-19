import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacVerticalDividerKitParser extends StacParser<KitModel> {
  const StacVerticalDividerKitParser();

  @override
  String get type => 'verticalDivider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppVerticalDivider(color: colorOf(context, model, 'color'));
}
