import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppProgressBarParser extends StacParser<KitModel> {
  const StacAppProgressBarParser();

  @override
  String get type => 'appProgressBar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => NinjaProgressBar(
    value: doubleOr(model, 'value', 0).clamp(0, 1),
    height: doubleOr(model, 'height', 6),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
    indeterminate: boolOf(model, 'indeterminate'),
  );
}
