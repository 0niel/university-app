import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacCircularProgressKitParser extends StacParser<KitModel> {
  const StacCircularProgressKitParser();

  @override
  String get type => 'circularProgressIndicator';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaSpinner(
    strokeWidth: doubleOr(model, 'strokeWidth', 3),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'backgroundColor'),
  );
}
