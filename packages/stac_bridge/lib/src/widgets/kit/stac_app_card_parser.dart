import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppCardParser extends StacParser<KitModel> {
  const StacAppCardParser();

  @override
  String get type => 'appCard';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppCard(
    color: colorOf(context, model, 'color'),
    tinted: boolOf(model, 'tinted'),
    radius: doubleOr(model, 'radius', AppRadius.card),
    padding: insetsOf(model, 'padding', 16),
    margin: model.containsKey('margin') ? insetsOf(model, 'margin', 0) : null,
    width: doubleOf(model, 'width'),
    height: doubleOf(model, 'height'),
    semanticsLabel: stringOrNullOf(model, 'semanticsLabel'),
    onTap: actionOf(context, model, const ['onTap', 'onPressed']),
    onLongPress: actionOf(context, model, const ['onLongPress']),
    child: childWidget(context, model['child']) ?? const SizedBox.shrink(),
  );
}
