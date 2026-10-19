import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';

export 'stac_multi_action_kit_parser.dart';
export 'stac_run_action_parser.dart';
export 'stac_try_action_parser.dart';

final _executionKey = Object();
final _bindingsKey = Object();
final _resolver = MiniAppTreeResolver(
  defaultMiniAppExpressionEngine,
  deferActions: true,
);

class _ActionExecution {
  _ActionExecution(this.store, this.form, this.context);

  final MiniAppStateStore? store;
  final StacFormScope? form;
  final BuildContext context;
  int steps = 0;
}

Map<String, Object?> actionBindings(BuildContext context) => {
  ...?Zone.current[_bindingsKey] as Map<String, Object?>?,
  'state': MiniAppStateScope.of(context)?.snapshot() ?? const {},
};

Future<Object?> runMiniAppAction(
  BuildContext context,
  Object? action, {
  Map<String, Object?> bindings = const {},
}) async {
  if (action is! Map<Object?, Object?>) return null;
  final inherited = Zone.current[_executionKey] as _ActionExecution?;
  if (inherited == null && !context.mounted) return null;
  final execution =
      inherited ??
      _ActionExecution(
        MiniAppStateScope.of(context),
        context.getInheritedWidgetOfExactType(),
        context,
      );
  final stableContext = execution.store?.actionContext ?? execution.context;
  if (!stableContext.mounted || execution.store?.isDisposed == true) {
    return null;
  }
  if (++execution.steps > 512) {
    throw StateError('Mini app action limit exceeded');
  }
  final json = Map<String, Object?>.from(action);
  final locals = <String, Object?>{
    ...?Zone.current[_bindingsKey] as Map<String, Object?>?,
    ...bindings,
  };
  return MiniAppSessionStack.runWith(
    MiniAppSessionStack.current,
    () => runZoned(() async {
      if (json['actionType'] == 'appRunAction') {
        final captured = json['bindings'];
        return runMiniAppAction(
          stableContext,
          json['action'],
          bindings: captured is Map<Object?, Object?>
              ? Map.from(captured)
              : const {},
        );
      }
      final resolved = _resolver.resolveAction(json, {
        ...locals,
        'state': execution.store?.snapshot() ?? const {},
      });
      if (json['actionType'] == 'getFormValue') {
        return execution.form?.formData[resolved['id']];
      }
      if (json['actionType'] == 'validateForm') {
        final valid = execution.form?.formKey.currentState?.validate() ?? false;
        return runMiniAppAction(
          stableContext,
          resolved[valid ? 'isValid' : 'isNotValid'],
        );
      }
      return Stac.onCallFromJson(resolved, stableContext);
    }, zoneValues: {_executionKey: execution, _bindingsKey: locals}),
  );
}
