import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppOverlineParser extends StacParser<KitModel> {
  const StacAppOverlineParser();

  @override
  String get type => 'appOverline';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppOverline(
    stringOf(model, 'label', stringOf(model, 'text')),
    topPadding: doubleOr(model, 'topPadding', 22),
    bottomPadding: doubleOr(model, 'bottomPadding', 10),
    color: colorOf(context, model, 'color'),
  );
}
