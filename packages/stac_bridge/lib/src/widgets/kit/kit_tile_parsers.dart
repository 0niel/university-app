import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppServiceTileParser extends StacParser<KitModel> {
  const StacAppServiceTileParser();

  @override
  String get type => 'appServiceTile';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final color = colorOf(context, model, 'color') ?? context.colors.accent;
    final label = stringOrNullOf(model, 'label');
    final solid = boolOf(model, 'solid');
    final size = doubleOr(model, 'size', 56);
    final onTap = actionOf(context, model, const ['onTap', 'onPressed']);
    final icon = iconOf(model, 'icon');
    if (icon != null) {
      return AppServiceTile.icon(
        icon: AppLineIconWidget(icon, size: size * 0.42),
        color: color,
        label: label,
        solid: solid,
        size: size,
        onTap: onTap,
      );
    }
    return AppServiceTile(
      emoji: stringOf(model, 'emoji'),
      color: color,
      label: label,
      solid: solid,
      size: size,
      onTap: onTap,
    );
  }
}

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
