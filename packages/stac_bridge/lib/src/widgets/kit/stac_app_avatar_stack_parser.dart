import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

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
