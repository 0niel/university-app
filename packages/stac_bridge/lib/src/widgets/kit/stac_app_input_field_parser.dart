import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_input_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppInputFieldParser extends StacParser<KitModel> {
  const StacAppInputFieldParser();

  @override
  String get type => 'appInputField';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      KitInputField(model: model);
}
