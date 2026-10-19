import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_label_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppBadgeParser extends StacParser<KitModel> {
  const StacAppBadgeParser();

  @override
  String get type => 'appBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppBadge(
    label: stringOf(model, 'label'),
    tone: appBadgeToneOf(stringOrNullOf(model, 'tone')),
    dot: boolOf(model, 'dot'),
    icon: iconOf(model, 'icon'),
  );
}
