import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacListTileKitParser extends StacParser<KitModel> {
  const StacListTileKitParser();

  @override
  String get type => 'listTile';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final subtitle = labelOf(model['subtitle']);
    return AppListRow(
      title: labelOf(model['title']),
      subtitle: subtitle.isEmpty ? null : subtitle,
      dense: boolOf(model, 'dense'),
      isFirst: true,
      leading: childWidget(context, model['leading']),
      trailing: childWidget(context, model['trailing']),
      onTap: boolOf(model, 'enabled', fallback: true)
          ? actionCallback(context, model['onTap'])
          : null,
    );
  }
}
