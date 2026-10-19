import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCheckBoxKitParser extends StacParser<KitModel> {
  const StacCheckBoxKitParser();

  @override
  String get type => 'checkBox';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: .checkbox,
    initial: boolOf(model, 'value'),
  );
}
