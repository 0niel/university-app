import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/expression/tree_resolver.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_store.dart';

final _executionKey = Object();
final _bindingsKey = Object();
final _resolver = MiniAppTreeResolver(
  defaultMiniAppExpressionEngine,
  deferActions: true,
);

class _Execution {
  _Execution(this.store, this.form, this.context);

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
  final inherited = Zone.current[_executionKey] as _Execution?;
  if (inherited == null && !context.mounted) return null;
  final execution =
      inherited ??
      _Execution(
        MiniAppStateScope.of(context),
        context.getInheritedWidgetOfExactType<StacFormScope>(),
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
              ? Map<String, Object?>.from(captured)
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

class StacRunActionParser implements StacActionParser<Map<String, Object?>> {
  const StacRunActionParser();

  @override
  String get actionType => 'appRunAction';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Future<Object?> onCall(BuildContext context, Map<String, Object?> model) =>
      runMiniAppAction(context, model);
}

class StacMultiActionKitParser
    implements StacActionParser<Map<String, Object?>> {
  const StacMultiActionKitParser();

  @override
  String get actionType => 'multiAction';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Future<Object?> onCall(
    BuildContext context,
    Map<String, Object?> model,
  ) async {
    final actions = model['actions'];
    if (actions is! List<Object?>) return null;
    if (actions.length > 128) throw StateError('Too many actions');
    if (model['sync'] == false) {
      return Future.wait([
        for (final action in actions) runMiniAppAction(context, action),
      ]);
    }
    Object? result;
    for (final action in actions) {
      if (!context.mounted) break;
      result = await runMiniAppAction(context, action);
    }
    return result;
  }
}

class StacTryActionParser implements StacActionParser<Map<String, Object?>> {
  const StacTryActionParser();

  @override
  String get actionType => 'tryAction';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Future<Object?> onCall(
    BuildContext context,
    Map<String, Object?> model,
  ) async {
    try {
      return await runMiniAppAction(context, model['do']);
    } on Exception {
      final result = await runMiniAppAction(context, model['onError']);
      return result;
    } finally {
      if (context.mounted) {
        await runMiniAppAction(context, model['onFinally']);
      }
    }
  }
}
