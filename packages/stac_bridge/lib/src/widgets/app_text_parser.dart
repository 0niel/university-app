import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTextParser extends StacParser<Map<String, dynamic>> {
  const StacAppTextParser();

  @override
  String get type => 'appText';

  @override
  Map<String, dynamic> getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, Map<String, dynamic> model) {
    final style = switch (model['variant']) {
      'caption' => AppText.caption,
      'title' => AppText.sectionLarge,
      'label' => AppText.label,
      _ => AppText.body,
    };
    return Text(
      stringOf(model, 'data'),
      style: style.copyWith(
        color:
            parseAppColor(context, model['color'] as String?) ??
            context.colors.ink,
      ),
    );
  }
}
