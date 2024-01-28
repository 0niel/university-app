import 'package:dynamite_runtime/http_client.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final uri = Uri.parse('http://example.com');

  group('Cookies', () {
    late CookieJar cookieJar;
    setUp(() {
      cookieJar = CookieJar();
    });

    test('Cookies', () async {
      final mockedClient = MockClient((request) async {
        expect(request.headers['cookie'], equals(Cookie('a', 'b').toString()));

        return Response(
          '',
          200,
          headers: {
            'set-cookie': Cookie('c', 'd').toString(),
          },
        );
      });

      final client = DynamiteClient(
        uri,
        httpClient: mockedClient,
        cookieJar: cookieJar,
      );

      await cookieJar.saveFromResponse(uri, [Cookie('a', 'b')]);
      await client.executeRequest('GET', '');

      final cookies = await cookieJar.loadForRequest(uri);
      expect(cookies, hasLength(2));
      expect(cookies[0].name, 'a');
      expect(cookies[0].value, 'b');
      expect(cookies[1].name, 'c');
      expect(cookies[1].value, 'd');
    });

    test('No cookies', () async {
      final mockedClient = MockClient((request) async {
        expect(request.headers['cookie'], isNull);
        return Response('', 200);
      });

      final client = DynamiteClient(
        uri,
        httpClient: mockedClient,
        cookieJar: cookieJar,
      );

      await client.executeRequest('GET', '');
    });
  });

  group('headers', () {
    test('raw request base headers', () async {
      final mockedClient = MockClient((request) async {
        expect(
          request.headers,
          equals({
            'some-key': 'some-value',
          }),
        );

        return Response(
          '',
          200,
        );
      });

      final client = DynamiteClient(
        uri,
        httpClient: mockedClient,
        baseHeaders: {
          'some-key': 'some-value',
        },
      );

      await client.executeRawRequest('GET', uri);
    });

    test('request overwrites base headers', () async {
      final mockedClient = MockClient((request) async {
        expect(
          request.headers,
          equals({
            'some-key': 'some-other-value',
          }),
        );

        return Response(
          '',
          200,
        );
      });

      final client = DynamiteClient(
        uri,
        httpClient: mockedClient,
        baseHeaders: {
          'some-key': 'some-value',
        },
      );

      await client.executeRawRequest('GET', uri, headers: {'some-key': 'some-other-value'});
    });
  });
}
