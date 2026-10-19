import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/material/material_icon_names.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacIconButtonKitParser extends StacParser<KitModel> {
  const StacIconButtonKitParser();

  @override
  String get type => 'iconButton';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final lineIcon = lineIconOfNode(model['icon']);
    final icon = lineIcon != null
        ? AppLineIconWidget(lineIcon)
        : childWidget(context, model['icon']);
    if (icon == null) return const SizedBox.shrink();
    return AppIconButton(
      icon: icon,
      tone: .plain,
      tooltip: stringOrNullOf(model, 'tooltip'),
      foregroundColor: colorOf(context, model, 'color'),
      onPressed: actionCallback(context, model['onPressed']),
    );
  }
}
