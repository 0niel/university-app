import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';

typedef FlowControlActionModel = Map<String, Object?>;

final flowControlTreeResolver = MiniAppTreeResolver(
  defaultMiniAppExpressionEngine,
  deferActions: true,
);

Map<String, Object?> flowControlStateContext(BuildContext context) =>
    actionBindings(context);

FutureOr<Object?> dispatchFlowControlAction(
  BuildContext context,
  Object? action,
) {
  if (action is Map<Object?, Object?>) {
    return runMiniAppAction(context, action);
  }
  return null;
}
