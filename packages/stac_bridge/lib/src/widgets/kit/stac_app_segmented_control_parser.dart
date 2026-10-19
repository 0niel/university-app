import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/widgets/kit/kit_segment_parsers.dart';
import 'package:stac_bridge/src/widgets/kit_state_binding.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';
import 'package:stac_framework/stac_framework.dart';

class StacAppSegmentedControlParser extends StacParser<KitModel> {
  const StacAppSegmentedControlParser();

  @override
  String get type => 'appSegmentedControl';

  @override
  KitModel getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, KitModel model) {
    final options = mapListOf(model, 'options');
    if (options.isEmpty) return const SizedBox.shrink();
    return KitIndexedControlView(
      model: model,
      options: options,
      kind: .segmented,
      initial: intStateOf(context, model, 'selectedIndex', 0),
    );
  }
}
