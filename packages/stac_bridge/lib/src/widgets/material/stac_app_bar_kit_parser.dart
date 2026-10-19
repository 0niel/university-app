import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/material/material_shell_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacAppBarKitParser extends StacParser<KitModel> {
  const StacAppBarKitParser();

  @override
  String get type => 'appBar';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) => KitAppBar(
    title: labelOf(model['title']),
    leading: childWidget(context, model['leading']),
    actions: childrenWidgets(context, model['actions']),
  );
}
