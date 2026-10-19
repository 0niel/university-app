import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppMetaPillParser extends StacParser<KitModel> {
  const StacAppMetaPillParser();

  @override
  String get type => 'appMetaPill';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    return AppMetaPill(
      text: stringOf(model, 'text'),
      strong: boolOf(model, 'strong'),
      icon: icon == null ? null : AppLineIconWidget(icon, size: 14),
      iconColor: colorOf(context, model, 'iconColor'),
    );
  }
}
