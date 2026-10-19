import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/material/material_icon_names.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacFloatingActionButtonKitParser extends StacParser<KitModel> {
  const StacFloatingActionButtonKitParser();

  @override
  String get type => 'floatingActionButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon =
        lineIconOfNode(model['icon']) ??
        lineIconOfNode(model['child']) ??
        .plus;
    final label = labelOf(model['child']);
    final onPressed = actionCallback(context, model['onPressed']);
    final tooltip = stringOrNullOf(model, 'tooltip');
    if (stringOf(model, 'buttonType') == 'extended' && label.isNotEmpty) {
      return AppFab.extended(
        icon: icon,
        label: label,
        onPressed: onPressed,
        tooltip: tooltip,
      );
    }
    return AppFab(icon: icon, onPressed: onPressed, tooltip: tooltip);
  }
}
