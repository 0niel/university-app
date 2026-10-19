import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';

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
