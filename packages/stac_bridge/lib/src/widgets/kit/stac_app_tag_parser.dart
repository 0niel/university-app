import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTagParser extends StacParser<KitModel> {
  const StacAppTagParser();

  @override
  String get type => 'appTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    return AppTag(
      label: stringOf(model, 'label'),
      tone: enumByName(
        AppTagTone.values,
        stringOrNullOf(model, 'tone'),
        AppTagTone.mute,
      ),
      leading: boolOf(model, 'withDot')
          ? AppLiveDot(color: colorOf(context, model, 'dotColor'))
          : icon == null
          ? null
          : AppLineIconWidget(icon, size: 12),
    );
  }
}
