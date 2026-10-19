import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppDividerParser extends StacParser<KitModel> {
  const StacAppDividerParser();

  @override
  String get type => 'appDivider';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final color = colorOf(context, model, 'color');
    if (boolOf(model, 'vertical')) {
      return AppVerticalDivider(
        height: doubleOf(model, 'height'),
        color: color,
      );
    }
    if (boolOf(model, 'inset')) return AppDivider.inset(color: color);
    return AppDivider(
      indent: doubleOr(model, 'indent', 0),
      endIndent: doubleOr(model, 'endIndent', 0),
      color: color,
    );
  }
}
