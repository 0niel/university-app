import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_input_parsers.dart';
import 'package:stac_bridge/src/widgets/material/material_form_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacTextFieldKitParser extends StacParser<KitModel> {
  const StacTextFieldKitParser();

  @override
  String get type => 'textField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      KitInputField(model: normalizeMaterialField(model));
}
