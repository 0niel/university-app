import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/material/material_button_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacOutlinedButtonKitParser extends StacParser<KitModel> {
  const StacOutlinedButtonKitParser();

  @override
  String get type => 'outlinedButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      kitButtonFromMaterial(context, model, .secondary);
}
