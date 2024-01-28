import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite_end_to_end_test/types.openapi.dart';
import 'package:test/test.dart';

void main() {
  test(Base, () {
    final object = Base(
      (b) => b
        ..$bool = true
        ..integer = 350
        ..$double = 0.7617818016335848
        ..$num = 0.6538342555284606
        ..string = 'StringValue'
        ..contentString.update((b) => b..content = 98)
        ..stringBinary = utf8.encode('StringValue')
        ..list.update(
          (b) => b
            ..addAll([
              JsonObject('value'),
              JsonObject(188),
              JsonObject(0.45151780411979836),
              JsonObject(false),
            ]),
        )
        ..listNever = ListBuilder<Never>()
        ..listString.update(
          (b) => b
            ..addAll([
              'value1',
              'value2',
              'value3',
              'value4',
            ]),
        ),
    );

    final json = <String, dynamic>{
      'bool': true,
      'integer': 350,
      'double': 0.7617818016335848,
      'num': 0.6538342555284606,
      'string': 'StringValue',
      'content-string': '98',
      'string-binary': 'U3RyaW5nVmFsdWU=',
      'list': ['value', 188, 0.45151780411979836, false],
      // ignore: inference_failure_on_collection_literal
      'list-never': [],
      'list-string': ['value1', 'value2', 'value3', 'value4'],
    };
    final revived = Base.fromJson(json);

    expect(object.toJson(), equals(json));

    expect(revived.$bool, equals(object.$bool));
    expect(revived.integer, equals(object.integer));
    expect(revived.$double, equals(object.$double));
    expect(revived.$num, equals(object.$num));
    expect(revived.string, equals(object.string));
    expect(revived.contentString, equals(object.contentString));
    expect(revived.stringBinary, equals(object.stringBinary));
    expect(revived.list, equals(object.list));
    expect(revived.listNever, equals(object.listNever));
    expect(revived.listString, equals(object.listString));
  });

  test(BuiltList<Never>, () {
    final object = Base(
      (b) => b..listNever = ListBuilder<Never>(),
    );

    var json = <String, dynamic>{
      // ignore: inference_failure_on_collection_literal
      'list-never': [],
    };

    final revived = Base.fromJson(json);
    expect(object.toJson(), equals(json));
    expect(revived.listNever, equals(object.listNever));

    json = {
      'list-never': ['SomeValue'],
    };

    expect(() => Base.fromJson(json), throwsA(isA<DeserializationError>()));
  });
}
