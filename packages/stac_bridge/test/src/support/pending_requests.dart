import 'dart:async';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class PendingRequests implements HttpClientAdapter {
  final responses = <Completer<ResponseBody>>[];
  Completer<void> _arrival = Completer<void>();

  Future<void> waitFor(int count) async {
    while (responses.length < count) {
      await _arrival.future;
    }
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    final response = Completer<ResponseBody>();
    responses.add(response);
    _arrival.complete();
    _arrival = Completer<void>();
    return response.future;
  }

  @override
  void close({bool force = false}) => ();
}
