import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_control_action_support.dart';
import 'package:stac_bridge/src/expression/condition.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacForEachActionParser
    implements StacActionParser<FlowControlActionModel> {
  const StacForEachActionParser();

  @override
  String get actionType => 'forEachAction';

  @override
  FlowControlActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    FlowControlActionModel model,
  ) async {
    final template = model['do'];
    if (template == null) return null;

    final stateContext = flowControlStateContext(context);
    final source = model['items'];
    final items = source is String
        ? defaultMiniAppExpressionEngine.evaluate(
            stripExpressionBraces(source),
            stateContext,
          )
        : source;
    if (items is! List<Object?>) return null;

    final itemVar = stringOf(model, 'itemVar', 'item');
    final indexVar = stringOf(model, 'indexVar', 'index');
    for (var i = 0; i < items.length; i++) {
      final scoped = {...stateContext, itemVar: items[i], indexVar: i};
      await dispatchFlowControlAction(
        context,
        flowControlTreeResolver.resolveNode(template, scoped),
      );
      if (!context.mounted) return null;
    }
    return null;
  }
}
