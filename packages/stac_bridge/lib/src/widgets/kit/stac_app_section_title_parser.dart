import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppSectionTitleParser extends StacParser<KitModel> {
  const StacAppSectionTitleParser();

  @override
  String get type => 'appSectionTitle';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => AppSectionTitle(
    title: stringOf(model, 'title'),
    subtitle: stringOrNullOf(model, 'subtitle'),
    action: stringOrNullOf(model, 'action'),
    meta: stringOrNullOf(model, 'meta'),
    topMargin: doubleOr(model, 'topMargin', 26),
    bottomPadding: doubleOr(model, 'bottomPadding', 12),
    onActionTap: actionOf(context, model, const ['onActionTap', 'onAction']),
  );
}
