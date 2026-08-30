import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
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
    if (key.isEmpty || store == null) return null;

    final delta = model['add'];
    final expression = model['expression'];
    if (delta is num) {
      store.add(key, delta);
    } else if (expression is String) {
      store.set(
        key,
        defaultMiniAppExpressionEngine.evaluate(
          expression,
          {'state': store.snapshot()},
        ),
      );
    } else {
      store.set(key, model['value']);
    }

    final followUp = model['action'];
    if (followUp is Map<Object?, Object?>) {
      return Stac.onCallFromJson(Map<String, Object?>.from(followUp), context);
    }
    return null;
  }
}
