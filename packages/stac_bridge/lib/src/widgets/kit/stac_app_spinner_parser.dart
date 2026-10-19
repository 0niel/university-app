import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppSpinnerParser extends StacParser<KitModel> {
  const StacAppSpinnerParser();

  @override
  String get type => 'appSpinner';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaSpinner(
    size: doubleOr(model, 'size', 28),
    strokeWidth: doubleOr(model, 'strokeWidth', 3),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
  );
}
