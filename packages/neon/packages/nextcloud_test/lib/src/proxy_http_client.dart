// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:universal_io/io.dart';

/// Gets a mocked [HttpClient] that proxies the request to a real [HttpClient].
/// For every requests it calls [onRequest] which contains the formatted request.
BaseClient getProxyHttpClient({
  required void Function(String fixture) onRequest,
}) {
  final realClient = Client();
  return MockClient.streaming((baseRequest, bytesStream) async {
    final bodyBytes = await bytesStream.toBytes();
    final fixture = _formatHttpRequest(baseRequest, bodyBytes);
    onRequest(fixture);

    final request = Request(baseRequest.method, baseRequest.url)
      ..persistentConnection = baseRequest.persistentConnection
      ..followRedirects = baseRequest.followRedirects
      ..maxRedirects = baseRequest.maxRedirects
      ..headers.addAll(baseRequest.headers)
      ..bodyBytes = bodyBytes;

    return realClient.send(request);
  });
}

String _formatHttpRequest(BaseRequest request, Uint8List body) {
  final buffer = StringBuffer('${request.method.toUpperCase()} ${request.url.replace(port: 80)}');

  final headers = <String>[];
  for (final header in request.headers.entries) {
    final name = header.key.toLowerCase();
    var value = header.value;

    if (name == HttpHeaders.hostHeader) {
      continue;
    } else if (name == HttpHeaders.cookieHeader) {
      continue;
    } else if (name == HttpHeaders.authorizationHeader) {
      value = '${value.split(' ').first} mock';
    } else if (name == 'destination') {
      value = Uri.parse(value).replace(port: 80).toString();
    }

    headers.add('\n$name: $value');
  }

  headers.sort();
  buffer.writeAll(headers);

  if (body.isNotEmpty) {
    try {
      buffer.write('\n${utf8.decode(body)}');
    } catch (_) {
      buffer.write('\n${base64.encode(body)}');
    }
  }

  return buffer.toString();
}
