import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
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
    if (loadingKey.isNotEmpty) store?.set(loadingKey, true);

    final response = await MiniAppSessionStack.current?.host.fetch(
      path: path.startsWith('/') ? path : '/$path',
      method: stringOf(model, 'method', 'GET').toUpperCase(),
      query: _stringMap(model['query']),
      body: model['body'],
    );

    if (loadingKey.isNotEmpty) store?.set(loadingKey, false);
    if (!context.mounted) return null;

    final values = response == null
        ? null
        : <String, Object?>{
            stringOf(model, 'saveAs', 'data'): digJson(
              response,
              stringOf(model, 'pick'),
            ),
          };
    return writeStateAndFollowUp(
      context,
      values: values,
      onSuccess: model['onResult'],
      onFailure: model['onError'],
    );
  }
}

Map<String, Object?>? _stringMap(Object? value) {
  return value is Map<Object?, Object?> ? .from(value) : null;
}
