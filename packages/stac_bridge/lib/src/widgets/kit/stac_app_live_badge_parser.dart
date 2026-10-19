import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppLiveBadgeParser extends StacParser<KitModel> {
  const StacAppLiveBadgeParser();

  @override
  String get type => 'appLiveBadge';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) =>
      AppLiveBadge(label: stringOf(model, 'label', 'Сейчас'));
}
