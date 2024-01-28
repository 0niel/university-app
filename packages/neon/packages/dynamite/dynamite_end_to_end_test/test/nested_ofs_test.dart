import 'package:dynamite_end_to_end_test/nested_ofs.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('BaseNestedAllOf', () {
    final object = BaseNestedAllOf(
      (b) => b
        ..string = 'attributeValue'
        ..attributeAllOf = 'attributeAllOfValue'
        ..attributeNestedAllOf = 'attributeNestedAllOf'
        ..baseAnyOf = (
          $int: null,
          baseAnyOf1: BaseAnyOf1((b) => b..attributeAnyOf = 'baseAnyOfAttributeAnyOfValue'),
        )
        ..baseOneOf = (
          $double: null,
          baseOneOf1: BaseOneOf1((b) => b..attributeOneOf = 'baseAnyOfAttributeOneOfValue'),
        ),
    );

    final json = {
      'String': 'attributeValue',
      'attribute-allOf': 'attributeAllOfValue',
      'BaseOneOf': {'attribute-oneOf': 'baseAnyOfAttributeOneOfValue'},
      'BaseAnyOf': {'attribute-anyOf': 'baseAnyOfAttributeAnyOfValue'},
      'attribute-nested-allOf': 'attributeNestedAllOf',
    };

    expect(object.toJson(), equals(json));
    expect(BaseNestedAllOf.fromJson(json), equals(object));
  });

  test('BaseNestedOneOf', () {
    BaseNestedOneOf object = (
      baseAllOf: BaseAllOf(
        (b) => b
          ..string = 'BaseAllOfAttributeValue'
          ..attributeAllOf = 'BaseAllOfAttributeAllOfValue',
      ),
      $double: null,
      baseOneOf1: null,
      baseAnyOf: null,
      baseNestedOneOf3: null,
    );

    Object? json = {
      'String': 'BaseAllOfAttributeValue',
      'attribute-allOf': 'BaseAllOfAttributeAllOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      $double: null,
      baseOneOf1: BaseOneOf1((b) => b..attributeOneOf = 'baseOneOfAttributeOneOfValue'),
      baseAnyOf: null,
      baseNestedOneOf3: null,
    );

    json = {
      'attribute-oneOf': 'baseOneOfAttributeOneOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      $double: 0.368966614163742,
      baseOneOf1: null,
      baseAnyOf: null,
      baseNestedOneOf3: null,
    );

    json = 0.368966614163742;

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      $double: null,
      baseOneOf1: null,
      baseAnyOf: (
        $int: null,
        baseAnyOf1: BaseAnyOf1((b) => b..attributeAnyOf = 'baseOneOfAttributeAnyOfValue'),
      ),
      baseNestedOneOf3: null,
    );

    json = {
      'attribute-anyOf': 'baseOneOfAttributeAnyOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      $double: null,
      baseOneOf1: null,
      baseAnyOf: (
        $int: 838,
        baseAnyOf1: null,
      ),
      baseNestedOneOf3: null,
    );

    json = 838;

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      $double: null,
      baseOneOf1: null,
      baseAnyOf: null,
      baseNestedOneOf3: BaseNestedOneOf3(
        (b) => b..attributeNestedOneOf = 'BaseNestedOneOf3AttributeNestedOneOfValue',
      ),
    );

    json = {
      'attribute-nested-oneOf': 'BaseNestedOneOf3AttributeNestedOneOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedOneOfExtension.fromJson(json), equals(object));
  });

  test('BaseNestedAnyOf', () {
    BaseNestedAnyOf object = (
      baseAllOf: BaseAllOf(
        (b) => b
          ..string = 'BaseAllOfAttributeValue'
          ..attributeAllOf = 'BaseAllOfAttributeAllOfValue',
      ),
      baseOneOf: null,
      baseAnyOf1: null,
      $int: null,
      baseNestedAnyOf3: null,
    );

    Object? json = {
      'String': 'BaseAllOfAttributeValue',
      'attribute-allOf': 'BaseAllOfAttributeAllOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      baseOneOf: (
        $double: null,
        baseOneOf1: BaseOneOf1((b) => b..attributeOneOf = 'baseOneOfAttributeOneOfValue'),
      ),
      $int: null,
      baseAnyOf1: null,
      baseNestedAnyOf3: null,
    );

    json = {
      'attribute-oneOf': 'baseOneOfAttributeOneOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      baseOneOf: (
        $double: 0.6945631603643333,
        baseOneOf1: null,
      ),
      $int: null,
      baseAnyOf1: null,
      baseNestedAnyOf3: null,
    );

    json = 0.6945631603643333;

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      baseOneOf: null,
      $int: null,
      baseAnyOf1: BaseAnyOf1((b) => b..attributeAnyOf = 'baseOneOfAttributeAnyOfValue'),
      baseNestedAnyOf3: null,
    );

    json = {
      'attribute-anyOf': 'baseOneOfAttributeAnyOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      baseOneOf: null,
      $int: 659,
      baseAnyOf1: null,
      baseNestedAnyOf3: null,
    );

    json = 659;

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));

    object = (
      baseAllOf: null,
      baseOneOf: null,
      $int: null,
      baseAnyOf1: null,
      baseNestedAnyOf3: BaseNestedAnyOf3(
        (b) => b..attributeNestedAnyOf = 'BaseNestedOneOf3AttributeNestedAnyOfValue',
      ),
    );

    json = {
      'attribute-nested-anyOf': 'BaseNestedOneOf3AttributeNestedAnyOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($BaseNestedAnyOfExtension.fromJson(json), equals(object));
  });

  test('NestedOptimizedOneOf', () {
    NestedOptimizedOneOf object = (
      $num: 770,
      baseOneOf1: null,
    );

    Object? json = 770;

    expect(object.toJson(), equals(json));
    expect($NestedOptimizedOneOfExtension.fromJson(json), equals(object));

    object = (
      $num: 0.8345761329689448,
      baseOneOf1: null,
    );

    json = 0.8345761329689448;

    expect(object.toJson(), equals(json));
    expect($NestedOptimizedOneOfExtension.fromJson(json), equals(object));

    object = (
      $num: null,
      baseOneOf1: BaseOneOf1(
        (b) => b..attributeOneOf = 'NestedOptimizedOneOfBaseOneOf1AttributeOneOfValue',
      ),
    );

    json = {
      'attribute-oneOf': 'NestedOptimizedOneOfBaseOneOf1AttributeOneOfValue',
    };

    expect(object.toJson(), equals(json));
    expect($NestedOptimizedOneOfExtension.fromJson(json), equals(object));
  });
}
