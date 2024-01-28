import 'package:dynamite_end_to_end_test/all_of.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('ObjectAllOf', () {
    final object = ObjectAllOf(
      (b) => b
        ..attribute1AllOf = 'attribute1AllOfValue'
        ..attribute2AllOf = 'attribute2AllOfValue',
    );

    final json = {
      'attribute1-allOf': 'attribute1AllOfValue',
      'attribute2-allOf': 'attribute2AllOfValue',
    };

    expect(object.toJson(), equals(json));
    expect(ObjectAllOf.fromJson(json), equals(object));
  });

  test('OneObjectAllOf', () {
    final object = OneObjectAllOf(
      (b) => b..attributeAllOf = 'attributeAllOfValue',
    );

    final json = {
      'attribute-allOf': 'attributeAllOfValue',
    };

    expect(object.toJson(), equals(json));
    expect(OneObjectAllOf.fromJson(json), equals(object));
  });

  test('PrimitiveAllOf', () {
    final object = PrimitiveAllOf(
      (b) => b
        ..string = 'stringValue'
        ..$int = 62,
    );

    final json = {
      'String': 'stringValue',
      'int': 62,
    };

    expect(object.toJson(), equals(json));
    expect(PrimitiveAllOf.fromJson(json), equals(object));
  });

  test('MixedAllOf', () {
    final object = MixedAllOf(
      (b) => b
        ..string = 'stringValue'
        ..attributeAllOf = 'attributeAllOfValue',
    );

    final json = {
      'String': 'stringValue',
      'attribute-allOf': 'attributeAllOfValue',
    };

    expect(object.toJson(), equals(json));
    expect(MixedAllOf.fromJson(json), equals(object));
  });

  test('OneValueAllOf', () {
    final object = OneValueAllOf(
      (b) => b..string = 'stringValue',
    );

    final json = {
      'String': 'stringValue',
    };

    expect(object.toJson(), equals(json));
    expect(OneValueAllOf.fromJson(json), equals(object));
  });
}
