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
