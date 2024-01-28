import 'dart:convert';

import 'package:dynamite_end_to_end_test/request_body.openapi.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() async {
  test('Request Uint8List body', () async {
    // No body
    var client = $Client(
      Uri.parse('example.com'),
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        return Response('{}', 200);
      }),
    );
    await client.$get();

    // with body
    final data = utf8.encode('value');
    client = $Client(
      Uri.parse('example.com'),
      httpClient: MockClient((request) async {
        expect(request.bodyBytes, equals(data));
        return Response('{}', 200);
      }),
    );
    await client.$get(uint8List: data);
  });

  test('Request String body', () async {
    // No body
    var client = $Client(
      Uri.parse('example.com'),
      httpClient: MockClient((request) async {
        expect(request.body, isEmpty);
        return Response('{}', 200);
      }),
    );
    await client.post();

    // with body
    client = $Client(
      Uri.parse('example.com'),
      httpClient: MockClient((request) async {
        expect(request.bodyBytes, utf8.encode('value'));
        return Response('{}', 200);
      }),
    );
    await client.post(string: 'value');
  });
}
