import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dynamite_end_to_end_test/parameters.openapi.dart';
import 'package:dynamite_runtime/models.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final uri = Uri.parse('example.com');

  group(r'$get', () {
    test('no parameters', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));

          return Response('{}', 200);
        }),
      );
      await client.$get();
    });

    test('with contentString', () async {
      final contentString = ContentString<BuiltMap<String, JsonObject>>(
        (b) => b..content = BuiltMap<String, JsonObject>({'key': JsonObject('value')}),
      );
      final queryComponent = Uri.encodeQueryComponent(json.encode({'key': 'value'}));

      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?content_string=$queryComponent')));

          return Response('{}', 200);
        }),
      );
      await client.$get(contentString: contentString);
    });

    test('with contentParameter', () async {
      final contentParameter = ContentString<BuiltMap<String, JsonObject>>(
        (b) => b..content = BuiltMap<String, JsonObject>({'key': JsonObject('value')}),
      );
      final queryComponent = Uri.encodeQueryComponent(json.encode({'key': 'value'}));

      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?content_parameter=$queryComponent')));

          return Response('{}', 200);
        }),
      );
      await client.$get(contentParameter: contentParameter);
    });

    test('with empty string', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?string=')));

          return Response('{}', 200);
        }),
      );

      await client.$get(string: '');
    });

    test('with multiple query parameters', () async {
      final contentString = ContentString<BuiltMap<String, JsonObject>>(
        (b) => b..content = BuiltMap<String, JsonObject>({'key': JsonObject('value')}),
      );
      final queryComponent = Uri.encodeQueryComponent(json.encode({'key': 'value'}));

      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(
            request.url,
            equals(Uri.parse('example.com/?content_string=$queryComponent&content_parameter=$queryComponent')),
          );

          return Response('{}', 200);
        }),
      );
      await client.$get(contentString: contentString, contentParameter: contentString);
    });

    test('oneOf', () async {
      var client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?oneOf=true')));

          return Response('{}', 200);
        }),
      );
      await client.$get(oneOf: ($bool: true, string: null));

      client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?oneOf=value')));

          return Response('{}', 200);
        }),
      );
      await client.$get(oneOf: ($bool: null, string: 'value'));
    });

    test('anyOf', () async {
      var client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?anyOf=true')));

          return Response('{}', 200);
        }),
      );
      await client.$get(anyOf: ($bool: true, string: null));

      client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?anyOf=value')));

          return Response('{}', 200);
        }),
      );
      await client.$get(anyOf: ($bool: null, string: 'value'));

      client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/?anyOf=true')));

          return Response('{}', 200);
        }),
      );
      await client.$get(anyOf: ($bool: true, string: 'value'));
    });
  });

  group('getHeaders', () {
    test('no parameters', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(
            request.url,
            equals(Uri.parse('example.com/headers')),
          );

          return Response('{}', 200);
        }),
      );
      await client.getHeaders();
    });

    test('all parameters', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(
            request.headers,
            equals({
              'Accept': 'application/json',
              'content_string': '{"key":"value"}',
              'content_parameter': '{"key":"value"}',
              'array': r'107,0.20416125852587397,false,Value$',
              'array_string': r'Value1,Value2,Value$',
              'bool': 'false',
              'string': r'$String',
              'string_binary': 'U3RyaW5nVmFsdWU=',
              'int': '126',
              'double': '0.5370671089544252',
              'num': '107',
              'object': '0.20416125852587397',
              'oneOf': r'$String',
              'anyOf': 'false',
              'enum_pattern': 'a',
            }),
          );
          expect(request.method, equalsIgnoringCase('get'));
          expect(
            request.url,
            equals(Uri.parse('example.com/headers')),
          );

          return Response('{}', 200);
        }),
      );

      await client.getHeaders(
        contentString: ContentString<BuiltMap<String, JsonObject>>(
          (b) => b..content = BuiltMap<String, JsonObject>({'key': JsonObject('value')}),
        ),
        contentParameter: ContentString<BuiltMap<String, JsonObject>>(
          (b) => b..content = BuiltMap<String, JsonObject>({'key': JsonObject('value')}),
        ),
        array: BuiltList<JsonObject>([
          JsonObject(107),
          JsonObject(0.20416125852587397),
          JsonObject(false),
          JsonObject(r'Value$'),
        ]),
        arrayString: BuiltList<String>([
          'Value1',
          'Value2',
          r'Value$',
        ]),
        $bool: false,
        string: r'$String',
        stringBinary: utf8.encode('StringValue'),
        $int: 126,
        $double: 0.5370671089544252,
        $num: 107,
        object: JsonObject(0.20416125852587397),
        oneOf: ($bool: null, string: r'$String'),
        anyOf: ($bool: false, string: r'$String'),
        enumPattern: GetHeadersEnumPattern.a,
      );
    });
  });

  group('getPathParameter', () {
    test('empty path', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));
          expect(request.url, equals(Uri.parse('example.com/parameter')));

          return Response('{}', 200);
        }),
      );
      await client.getPathParameter(pathParameter: 'parameter');
    });
  });

  group('PatternCheck', () {
    test('enum', () async {
      final client = $Client(
        uri,
        httpClient: MockClient((request) async {
          expect(request.bodyBytes.length, 0);
          expect(request.headers, equals({'Accept': 'application/json'}));
          expect(request.method, equalsIgnoringCase('get'));

          return Response('{}', 200);
        }),
      );
      expect(() => client.$get(enumPattern: GetEnumPattern.$0), throwsA(isA<FormatException>()));
      expect(() => client.getHeaders(enumPattern: GetHeadersEnumPattern.$0), throwsA(isA<FormatException>()));
    });
  });

  test('Naming Collisions', () async {
    final client = $Client(
      uri,
      httpClient: MockClient((request) async {
        expect(request.bodyBytes.length, 0);
        expect(
          request.headers,
          equals({
            'Accept': 'application/json',
            '%24serializers': r'serializers$ value',
            '_body': r'$body value',
            '_parameters': r'parameters value$$$',
            '_headers': r'headers$',
          }),
        );
        expect(request.method, equalsIgnoringCase('get'));
        expect(
          request.url,
          equals(Uri.parse('example.com/naming_collisions?%24jsonSerializers=jsonSerializers%20value%24')),
        );

        return Response('{}', 200);
      }),
    );

    await client.getNamingCollisions(
      jsonSerializers: r'jsonSerializers value$',
      serializers: r'serializers$ value',
      body: r'$body value',
      parameters: r'parameters value$$$',
      headers: r'headers$',
    );
  });
}
