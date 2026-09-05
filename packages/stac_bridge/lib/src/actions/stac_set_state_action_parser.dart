import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/expression/expression_engine.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

typedef StateActionModel = Map<String, Object?>;

class StacSetStateActionParser implements StacActionParser<StateActionModel> {
  const StacSetStateActionParser();

  @override
  String get actionType => 'setState';

  @override
  StateActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    StateActionModel model,
  ) {
    final key = stringOf(model, 'key');
    final store = MiniAppStateScope.of(context);
    if (store == null) return null;
    final values = model['values'];
    if (values is Map<Object?, Object?>) {
      store.setAll(Map<String, Object?>.from(values));
      return runMiniAppAction(context, model['action']);
    }
    if (key.isEmpty) return null;

    final delta = model['add'];
    final expression = model['expression'];
    if (model['toggle'] == true) {
      store.set(key, store.get(key) != true);
    } else if (delta is num) {
      store.add(key, delta);
    } else if (expression is String) {
      store.set(
        key,
        defaultMiniAppExpressionEngine.evaluate(
          expression,
          actionBindings(context),
        ),
      );
    } else {
      store.set(key, model['value']);
    }

    final followUp = model['action'];
    if (followUp is Map<Object?, Object?>) {
      return runMiniAppAction(context, followUp);
    }
    return null;
  }
}
