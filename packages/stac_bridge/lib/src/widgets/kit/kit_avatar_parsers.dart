import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppAvatarParser extends StacParser<KitModel> {
  const StacAppAvatarParser();

  @override
  String get type => 'appAvatar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppAvatar(
    name: stringOf(model, 'name'),
    size: doubleOr(model, 'size', 36),
    color: colorOf(context, model, 'color'),
    imageUrl: stringOrNullOf(model, 'imageUrl'),
    levelBadge: intOf(model, 'levelBadge'),
    online: model.containsKey('online') ? boolOf(model, 'online') : null,
  );
}

class StacAppAvatarStackParser extends StacParser<KitModel> {
  const StacAppAvatarStackParser();

  @override
  String get type => 'appAvatarStack';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppAvatarStack(
    names: stringListOf(model, 'names'),
    size: doubleOr(model, 'size', 36),
    maxVisible: intOf(model, 'maxVisible'),
    extra: intOf(model, 'extra') ?? 0,
  );
}

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
