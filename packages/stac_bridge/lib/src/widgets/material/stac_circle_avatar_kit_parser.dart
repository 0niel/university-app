import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacCircleAvatarKitParser extends StacParser<KitModel> {
  const StacCircleAvatarKitParser();

  @override
  String get type => 'circleAvatar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppAvatar(
    name: labelOf(model['child']),
    size: doubleOr(model, 'radius', 20) * 2,
    color: colorOf(context, model, 'backgroundColor'),
    imageUrl:
        stringOrNullOf(model, 'backgroundImage') ??
        stringOrNullOf(model, 'foregroundImage'),
  );
}
