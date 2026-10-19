import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class RuntimeInteractionAdapter implements HttpClientAdapter {
  RuntimeInteractionAdapter({this.request});
  final response = Completer<ResponseBody>();
  RequestOptions? request;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    request = options;
    return response.future;
  }

  @override
  void close({bool force = false}) => ();
}
