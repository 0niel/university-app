import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_segment_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppTabsParser extends StacParser<KitModel> {
  const StacAppTabsParser();

  @override
  String get type => 'appTabs';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final tabs = mapListOf(model, 'tabs');
    if (tabs.isEmpty) return const SizedBox.shrink();
    return KitIndexedControlView(
      model: model,
      options: tabs,
      kind: .tabs,
      initial: intStateOf(context, model, 'selectedIndex', 0),
    );
  }
}
