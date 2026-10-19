import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacTooltipKitParser extends StacParser<KitModel> {
  const StacTooltipKitParser();

  @override
  String get type => 'tooltip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final child = childWidget(context, model['child']);
    if (child == null) return const SizedBox.shrink();
    return AppTooltipAnchor(message: stringOf(model, 'message'), child: child);
  }
}
