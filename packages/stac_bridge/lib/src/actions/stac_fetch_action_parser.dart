import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/actions/state_capture.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/widgets/app_state_parsers.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

typedef FetchActionModel = Map<String, Object?>;

class StacFetchActionParser implements StacActionParser<FetchActionModel> {
  const StacFetchActionParser();

  @override
  String get actionType => 'fetch';

  @override
  FetchActionModel getModel(Map<String, dynamic> json) => .from(json);

  @override
  FutureOr<Object?> onCall(
    BuildContext context,
    FetchActionModel model,
  ) async {
    final path = stringOf(model, 'path');
    if (path.isEmpty) return null;

    final store = MiniAppStateScope.of(context);
    final loadingKey = stringOf(model, 'loadingKey');
    final errorKey = stringOf(model, 'errorKey');
    final saveAs = stringOf(model, 'saveAs', 'data');
    final requestKey = stringOf(model, 'requestKey', 'fetch:$saveAs');
    final requestId = store?.beginRequest(requestKey);
    bool isCurrent() =>
        context.mounted &&
        (requestId == null || store!.isCurrentRequest(requestKey, requestId));
    store?.setAll({
      if (loadingKey.isNotEmpty) loadingKey: true,
      if (errorKey.isNotEmpty) errorKey: null,
    });
    try {
      final response = await MiniAppSessionStack.current?.host.fetch(
        path: path.startsWith('/') ? path : '/$path',
        method: stringOf(model, 'method', 'GET').toUpperCase(),
        query: _stringMap(model['query']),
        body: model['body'],
      );
      if (!context.mounted || !isCurrent()) return null;
      if (response == null && errorKey.isNotEmpty) {
        store?.set(errorKey, 'request_failed');
      }
      final values = response == null
          ? null
          : <String, Object?>{
              saveAs: digJson(
                response,
                stringOf(model, 'pick'),
              ),
            };
      return await writeStateAndFollowUp(
        context,
        values: values,
        onSuccess: model['onResult'],
        onFailure: model['onError'],
      );
    } on Exception {
      if (!context.mounted || !isCurrent()) return null;
      if (errorKey.isNotEmpty) store?.set(errorKey, 'request_failed');
      return await runMiniAppAction(context, model['onError']);
    } finally {
      if (context.mounted && isCurrent()) {
        if (loadingKey.isNotEmpty) store?.set(loadingKey, false);
        if (requestId != null) store?.finishRequest(requestKey, requestId);
        await runMiniAppAction(context, model['onFinally']);
      }
    }
  }
}

Map<String, Object?>? _stringMap(Object? value) {
  return value is Map<Object?, Object?> ? .from(value) : null;
}
