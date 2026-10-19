import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacLinearProgressKitParser extends StacParser<KitModel> {
  const StacLinearProgressKitParser();

  @override
  String get type => 'linearProgressIndicator';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final value = doubleOf(model, 'value');
    return NinjaProgressBar(
      value: (value ?? 0).clamp(0, 1),
      indeterminate: value == null,
      height: doubleOr(model, 'minHeight', 6),
      color: colorOf(context, model, 'color'),
      trackColor: colorOf(context, model, 'backgroundColor'),
    );
  }
}
