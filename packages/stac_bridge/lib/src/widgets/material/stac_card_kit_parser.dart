import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCardKitParser extends StacParser<KitModel> {
  const StacCardKitParser();

  @override
  String get type => 'card';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppCard(
    color: colorOf(context, model, 'color'),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    padding: EdgeInsets.zero,
    child: childWidget(context, model['child']) ?? const SizedBox.shrink(),
  );
}
