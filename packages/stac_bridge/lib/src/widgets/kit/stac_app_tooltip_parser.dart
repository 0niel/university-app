import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTooltipParser extends StacParser<KitModel> {
  const StacAppTooltipParser();

  @override
  String get type => 'appTooltip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final message =
        stringOrNullOf(model, 'message') ?? stringOf(model, 'label');
    final child = childWidget(context, model['child']);
    if (child != null) return AppTooltipAnchor(message: message, child: child);
    return AppTooltip(
      label: message,
      arrow: stringOf(model, 'arrow') == 'up' ? .up : .down,
    );
  }
}
