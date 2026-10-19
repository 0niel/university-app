import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppCountBadgeParser extends StacParser<KitModel> {
  const StacAppCountBadgeParser();

  @override
  String get type => 'appCountBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppCountBadge(intOf(model, 'count') ?? 0, max: intOf(model, 'max') ?? 99);
}
