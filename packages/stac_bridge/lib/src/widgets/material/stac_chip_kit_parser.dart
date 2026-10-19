import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacChipKitParser extends StacParser<KitModel> {
  const StacChipKitParser();

  @override
  String get type => 'chip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppChip(
    label: labelOf(model['label']),
    leading: childWidget(context, model['avatar']),
    color:
        colorOf(context, model, 'backgroundColor') ??
        colorOf(context, model, 'color'),
    onRemove: actionCallback(context, model['onDeleted']),
    removeSemanticLabel: stringOrNullOf(model, 'deleteButtonTooltipMessage'),
  );
}
