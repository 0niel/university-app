import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:stac/stac.dart';
import 'package:stac_bridge/src/actions/action_execution.dart';
import 'package:stac_bridge/src/widgets/mini_app_state_scope.dart';
import 'package:stac_bridge/src/widgets/parse_utils.dart';

class StacNetworkRequestActionParser
    implements StacActionParser<Map<String, Object?>> {
  const StacNetworkRequestActionParser();

  static late Dio client;

  @override
  String get actionType => 'networkRequest';

  @override
  Map<String, Object?> getModel(Map<String, dynamic> json) => json;

  @override
  Future<Object?> onCall(
    BuildContext context,
    Map<String, Object?> model,
  ) async {
    final store = MiniAppStateScope.of(context);
    final loadingKey = stringOf(model, 'loadingKey');
    final errorKey = stringOf(model, 'errorKey');
    final saveAs = stringOf(model, 'saveAs');
    final requestKey = stringOf(
      model,
      'requestKey',
      saveAs.isNotEmpty
          ? 'network:$saveAs'
          : loadingKey.isNotEmpty
          ? 'network:loading:$loadingKey'
          : '',
    );
    final requestId = requestKey.isEmpty
        ? null
        : store?.beginRequest(requestKey);
    bool isCurrent() =>
        context.mounted &&
        store?.isDisposed != true &&
        (requestId == null || store!.isCurrentRequest(requestKey, requestId));
    store?.setAll({
      if (loadingKey.isNotEmpty) loadingKey: true,
      if (errorKey.isNotEmpty) errorKey: null,
    });
    try {
      final body = await _body(context, model['body']);
      if (!context.mounted || !isCurrent()) return null;
      Response<Object?>? response;
      try {
        response = await client.request<Object?>(
          stringOf(model, 'url'),
          data: body,
          queryParameters: model['queryParameters'] is Map<Object?, Object?>
              ? Map<String, Object?>.from(
                  model['queryParameters']! as Map<Object?, Object?>,
                )
              : null,
          options: Options(
            method: stringOf(model, 'method', 'get').toUpperCase(),
            contentType: 'application/json',
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
      } on DioException catch (error) {
        response = error.response;
      }
      if (!context.mounted || !isCurrent()) return null;
      final status = response?.statusCode;
      final success = status != null && status >= 200 && status < 300;
      store?.setAll({
        if (saveAs.isNotEmpty && success)
          saveAs: digJson(response?.data, stringOf(model, 'pick')),
        if (errorKey.isNotEmpty)
          errorKey: success ? null : (status ?? 'network_error'),
      });
      final results = mapListOf(model, 'results');
      final result = results.where((entry) => entry['statusCode'] == status);
      if (result.isNotEmpty) {
        return await runMiniAppAction(context, result.first['action']);
      }
      if (status == null && model['onError'] == null) {
        final offline = results.where((entry) => entry['statusCode'] == 503);
        if (offline.isNotEmpty) {
          return await runMiniAppAction(context, offline.first['action']);
        }
      }
      final followUp = model[success ? 'onResult' : 'onError'];
      if (!success && followUp == null) {
        throw Exception('Mini app request failed');
      }
      return await runMiniAppAction(context, followUp);
    } finally {
      if (context.mounted && isCurrent()) {
        if (loadingKey.isNotEmpty) store?.set(loadingKey, false);
        if (requestId != null) store?.finishRequest(requestKey, requestId);
        await runMiniAppAction(context, model['onFinally']);
      }
    }
  }

  Future<Object?> _body(BuildContext context, Object? value) async {
    if (value is Map<Object?, Object?>) {
      if (value['actionType'] is String) {
        return runMiniAppAction(context, value);
      }
      final result = <String, Object?>{};
      for (final entry in value.entries) {
        result[entry.key.toString()] = await _body(context, entry.value);
      }
      return result;
    }
    if (value is List<Object?>) {
      return Future.wait(value.map((item) => _body(context, item)));
    }
    return value;
  }
}
