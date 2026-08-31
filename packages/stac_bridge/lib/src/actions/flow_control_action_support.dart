import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';

typedef FlowControlActionModel = Map<String, Object?>;

final flowControlTreeResolver = MiniAppTreeResolver(
  defaultMiniAppExpressionEngine,
);

Map<String, Object?> flowControlStateContext(BuildContext context) => {
  'state': MiniAppStateScope.of(context)?.snapshot() ?? const {},
};

FutureOr<Object?> dispatchFlowControlAction(
  BuildContext context,
  Object? action,
) {
  if (action is Map<Object?, Object?>) {
    return Stac.onCallFromJson(Map<String, Object?>.from(action), context);
  }
  return null;
}
