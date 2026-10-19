import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppIconTileParser extends StacParser<KitModel> {
  const StacAppIconTileParser();

  @override
  String get type => 'appIconTile';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final emoji = stringOrNullOf(model, 'emoji');
    final tone = colorOf(context, model, 'color');
    return AppIconTile(
      icon: iconOf(model, 'icon'),
      size: doubleOr(model, 'size', 36),
      radius: doubleOr(model, 'radius', AppRadius.tile),
      background:
          colorOf(context, model, 'background') ??
          (tone == null ? null : context.colors.tintOf(tone)),
      foreground: colorOf(context, model, 'foreground') ?? tone,
      child: emoji == null
          ? childWidget(context, model['child'])
          : Text(emoji, style: AppText.headline),
    );
  }
}
