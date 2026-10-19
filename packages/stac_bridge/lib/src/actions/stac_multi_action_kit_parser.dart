import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';

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
