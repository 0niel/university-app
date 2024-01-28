// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:built_value/serializer.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:test/test.dart';

void main() {
  final serializers = (Serializers().toBuilder()..add(DynamiteDoubleSerializer())).build();

  group('double with known specifiedType', () {
    const data = 3.141592653589793;
    const serialized = data;
    const specifiedType = FullType(double);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('double with unknown specifiedType', () {
    const data = 3.141592653589793;
    final serialized = json.decode(json.encode(['double', data])) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('integer with known specifiedType', () {
    const data = 3;
    const serialized = data;
    const specifiedType = FullType(double);

    test('can not be deserialized', () {
      expect(
        () => serializers.deserialize(serialized, specifiedType: specifiedType),
        throwsA(isA<DeserializationError>()),
      );
    });
  });

  group('double with NaN value', () {
    const data = double.nan;
    const serialized = 'NaN';
    const specifiedType = FullType(double);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      // Compare using toString as NaN != NaN.
      expect(serializers.deserialize(serialized, specifiedType: specifiedType).toString(), data.toString());
    });
  });

  group('double with -INF value', () {
    const data = double.negativeInfinity;
    const serialized = '-INF';
    const specifiedType = FullType(double);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('double with INF value', () {
    const data = double.infinity;
    const serialized = 'INF';
    const specifiedType = FullType(double);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });
}
