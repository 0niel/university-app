import 'dart:async';

import 'package:dio/dio.dart';
import 'package:stac_bridge/src/mini_app_host.dart';
import 'package:stac_bridge/src/stac_bridge.dart';

class MiniAppProxyInterceptor extends Interceptor {
  const MiniAppProxyInterceptor({required this.config});

  final StacBridgeConfig config;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = MiniAppSessionStack.current;
    if (session == null) {
      return handler.reject(_error(options, 'No mini app session is active'));
    }
    final path = options.path;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return handler.reject(
        _error(options, 'Mini apps must use relative paths, got: $path'),
      );
    }
    final token = await config.onAccessTokenRequested();
    if (token == null || token.isEmpty) {
      return handler.reject(_error(options, 'Not authenticated'));
    }
    final query = options.queryParameters.map(
      (key, value) => MapEntry(key, value.toString()),
    );
    handler.next(
      options.copyWith(
        method: 'POST',
        path: config.proxyUrl,
        queryParameters: const {},
        data: {
          'organizationId': config.organizationId,
          'slug': session.slug,
          'kind': 'api',
          'path': path.startsWith('/') ? path : '/$path',
          'method': options.method.toUpperCase(),
          if (query.isNotEmpty) 'query': query,
          'body': ?options.data,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  DioException _error(RequestOptions options, String message) => .new(
    requestOptions: options,
    type: .badResponse,
    message: message,
  );
}
