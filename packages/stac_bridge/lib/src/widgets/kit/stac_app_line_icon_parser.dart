import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppLineIconParser extends StacParser<KitModel> {
  const StacAppLineIconParser();

  @override
  String get type => 'appLineIcon';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final icon = iconOf(model, 'icon');
    if (icon == null) return const SizedBox.shrink();
    return AppLineIconWidget(
      icon,
      size: doubleOr(model, 'size', 22),
      color: colorOf(context, model, 'color'),
      strokeWidth: doubleOr(model, 'strokeWidth', 2),
    );
  }
}
