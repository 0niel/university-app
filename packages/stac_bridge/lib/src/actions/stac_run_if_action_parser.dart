import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/flow_control_action_support.dart';
import 'package:stac_bridge/src/expression/condition.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';

class StacRunIfActionParser
    implements StacActionParser<FlowControlActionModel> {
  const StacRunIfActionParser();

  @override
  String get actionType => 'runIf';

  @override
  FlowControlActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    FlowControlActionModel model,
  ) {
    final condition = model['condition'];
    final pass = condition is String
        ? isTruthy(
            defaultMiniAppExpressionEngine.evaluate(
              stripExpressionBraces(condition),
              flowControlStateContext(context),
            ),
          )
        : isTruthy(condition);
    return dispatchFlowControlAction(
      context,
      pass ? model['then'] : model['else'],
    );
  }
}
