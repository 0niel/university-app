import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppSmartChipParser extends StacParser<KitModel> {
  const StacAppSmartChipParser();

  @override
  String get type => 'appSmartChip';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final tone = colorOf(context, model, 'tone') ?? context.colors.accent;
    final icon = iconOf(model, 'icon');
    final label = stringOf(model, 'label');
    final value = stringOf(model, 'value');
    if (icon != null) {
      return AppSmartChip.icon(
        icon: AppLineIconWidget(icon, size: 18, color: tone),
        label: label,
        value: value,
        tone: tone,
      );
    }
    return AppSmartChip(
      emoji: stringOf(model, 'emoji'),
      label: label,
      value: value,
      tone: tone,
    );
  }
}
