import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTypeTagParser extends StacParser<KitModel> {
  const StacAppTypeTagParser();

  @override
  String get type => 'appTypeTag';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppTypeTag(
    stringOf(model, 'label'),
    color: colorOf(context, model, 'color'),
  );
}
