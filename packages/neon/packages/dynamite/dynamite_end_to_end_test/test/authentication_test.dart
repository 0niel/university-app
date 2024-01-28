import 'package:dynamite_end_to_end_test/authentication.openapi.dart';
import 'package:dynamite_runtime/http_client.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final uri = Uri.parse('example.com');

  const basicAuth = DynamiteHttpBasicAuthentication(
    username: 'bearer-username',
    password: 'bearer-password',
  );

  const bearerAuth = DynamiteHttpBearerAuthentication(
    token: 'bearer-token',
  );

  test('No Authentication', () async {
    // no registered authentications
    var client = $Client(
      uri,
      authentications: [],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    await client.noAuthentication();

    // registered basic authentication
    client = $Client(
      uri,
      authentications: const [basicAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    await client.noAuthentication();

    // registered bearer authentication
    client = $Client(
      uri,
      authentications: const [bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    await client.noAuthentication();

    // multiple registered authentication
    client = $Client(
      uri,
      authentications: const [basicAuth, bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    await client.noAuthentication();
  });

  test('Basic authentication', () async {
    // no registered authentications
    var client = $Client(
      uri,
      authentications: [],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    expect(() => client.basicAuthentication(), throwsA(isA<Exception>()));

    // registered basic authentication
    client = $Client(
      uri,
      authentications: const [basicAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Basic YmVhcmVyLXVzZXJuYW1lOmJlYXJlci1wYXNzd29yZA==',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.basicAuthentication();

    // registered bearer authentication
    client = $Client(
      uri,
      authentications: const [bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    expect(() => client.basicAuthentication(), throwsA(isA<Exception>()));

    // multiple registered authentication
    client = $Client(
      uri,
      authentications: const [basicAuth, bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Basic YmVhcmVyLXVzZXJuYW1lOmJlYXJlci1wYXNzd29yZA==',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.basicAuthentication();
  });

  test('Bearer authentication', () async {
    // no registered authentications
    var client = $Client(
      uri,
      authentications: [],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    expect(() => client.bearerAuthentication(), throwsA(isA<Exception>()));

    // registered basic authentication
    client = $Client(
      uri,
      authentications: const [basicAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    expect(() => client.bearerAuthentication(), throwsA(isA<Exception>()));

    // registered bearer authentication
    client = $Client(
      uri,
      authentications: const [bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Bearer bearer-token',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.bearerAuthentication();

    // multiple registered authentication
    client = $Client(
      uri,
      authentications: const [basicAuth, bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Bearer bearer-token',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.bearerAuthentication();
  });

  test('Multiple authentications', () async {
    // no registered authentications
    var client = $Client(
      uri,
      authentications: [],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(request.headers, equals({'Accept': 'application/json'}));

        return Response('{}', 200);
      }),
    );
    expect(() => client.multipleAuthentications(), throwsA(isA<Exception>()));

    // registered basic authentication
    client = $Client(
      uri,
      authentications: const [basicAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Basic YmVhcmVyLXVzZXJuYW1lOmJlYXJlci1wYXNzd29yZA==',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.multipleAuthentications();

    // registered bearer authentication
    client = $Client(
      uri,
      authentications: const [bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Bearer bearer-token',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.multipleAuthentications();

    // multiple registered authentication
    client = $Client(
      uri,
      authentications: const [basicAuth, bearerAuth],
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            'Authorization': 'Basic YmVhcmVyLXVzZXJuYW1lOmJlYXJlci1wYXNzd29yZA==',
          }),
        );

        return Response('{}', 200);
      }),
    );
    await client.multipleAuthentications();
  });
}
