import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/widgets/reactive_mini_app_node.dart';

class StacReactiveNodeParser extends StacParser<Map<String, Object?>> {
  const StacReactiveNodeParser();

  @override
  String get type => 'appReactiveNode';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Widget parse(BuildContext context, Map<String, Object?> model) {
    final node = model['node'];
    if (node is! Map<Object?, Object?>) return const SizedBox.shrink();
    final bindings = model['bindings'];
    return ReactiveMiniAppNode(
      node: Map.from(node),
      bindings: bindings is Map<Object?, Object?>
          ? Map.from(bindings)
          : const {},
    );
  }
}
