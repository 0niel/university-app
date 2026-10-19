import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/kit/kit_choice_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppToggleParser extends StacParser<KitModel> {
  const StacAppToggleParser();

  @override
  String get type => 'appToggle';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitBoolControlView(
    model: model,
    kind: .toggle,
    initial: boolStateOf(context, model, 'value'),
  );
}
