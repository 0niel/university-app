import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppProgressRingParser extends StacParser<KitModel> {
  const StacAppProgressRingParser();

  @override
  String get type => 'appProgressRing';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppProgressRing(
    value: doubleOr(model, 'value', doubleOr(model, 'progress', 0)),
    size: doubleOr(model, 'size', 56),
    strokeWidth: doubleOr(model, 'strokeWidth', 5),
    color: colorOf(context, model, 'color'),
    trackColor: colorOf(context, model, 'trackColor'),
    label: stringOrNullOf(model, 'label'),
    sublabel: stringOrNullOf(model, 'sublabel'),
  );
}
