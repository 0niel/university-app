import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppFabParser extends StacParser<KitModel> {
  const StacAppFabParser();

  @override
  String get type => 'appFab';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon') ?? .plus;
    final label = stringOf(model, 'label');
    final enabled = boolOf(model, 'enabled', fallback: true);
    final onPressed = enabled
        ? actionOf(context, model, const ['onPressed', 'onTap'])
        : null;
    final tooltip = stringOrNullOf(model, 'tooltip');
    if (label.isEmpty) {
      return AppFab(icon: icon, onPressed: onPressed, tooltip: tooltip);
    }
    return AppFab.extended(
      icon: icon,
      label: label,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
