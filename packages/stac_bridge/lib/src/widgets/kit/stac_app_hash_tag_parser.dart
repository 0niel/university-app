import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppHashTagParser extends StacParser<KitModel> {
  const StacAppHashTagParser();

  @override
  String get type => 'appHashTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppHashTag(
    label: stringOf(model, 'label'),
    color: colorOf(context, model, 'color'),
    onTap: actionOf(context, model, const ['onTap', 'onPressed']),
  );
}
