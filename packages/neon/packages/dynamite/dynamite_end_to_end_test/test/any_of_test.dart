import 'package:dynamite_end_to_end_test/any_of.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('ObjectAnyOf', () {
    ObjectAnyOf object = (
      objectAnyOf0: ObjectAnyOf0((b) => b..attribute1AnyOf = 'attribute1AnyOf'),
      objectAnyOf1: null,
    );

    Object? json = {'attribute1-anyOf': 'attribute1AnyOf'};

    expect(object.toJson(), equals(json));
    expect($ObjectAnyOfExtension.fromJson(json), equals(object));

    object = (
      objectAnyOf0: null,
      objectAnyOf1: ObjectAnyOf1((b) => b..attribute2AnyOf = 'attribute2AnyOf'),
    );

    json = {'attribute2-anyOf': 'attribute2AnyOf'};

    expect(object.toJson(), equals(json));
    expect($ObjectAnyOfExtension.fromJson(json), equals(object));
  });

  test('MixedAnyOf', () {
    MixedAnyOf object = (
      mixedAnyOf1: MixedAnyOf1((b) => b..attributeAnyOf = 'attributeAnyOf'),
      string: null,
    );

    Object? json = {'attribute-anyOf': 'attributeAnyOf'};

    expect(object.toJson(), equals(json));
    expect($MixedAnyOfExtension.fromJson(json), equals(object));

    object = (
      mixedAnyOf1: null,
      string: 'string',
    );

    json = 'string';

    expect(object.toJson(), equals(json));
    expect($MixedAnyOfExtension.fromJson(json), equals(object));
  });

  test('OneObjectAnyOf', () {
    final object = OneObjectAnyOf((b) => b..attributeAnyOf = 'attributeAnyOf');

    final json = {'attribute-anyOf': 'attributeAnyOf'};

    expect(object.toJson(), equals(json));
    expect(OneObjectAnyOf.fromJson(json), equals(object));
    expect(object, isA<OneObjectAnyOf>());
  });

  test('OneValueAnyOf', () {
    const object = 'string';
    expect(object, isA<OneValueAnyOf>());
  });

  test('AnyOfIntDouble', () {
    Object? object = 0.5971645863260784;
    expect(object, isA<AnyOfIntDouble>());

    object = 361;
    expect(object, isA<AnyOfIntDouble>());
  });

  test('AnyOfIntDoubleNum', () {
    Object? object = 0.5213515036646204;
    expect(object, isA<AnyOfIntDoubleNum>());

    object = 620;
    expect(object, isA<AnyOfIntDoubleNum>());
  });

  test('AnyOfIntDoubleOther', () {
    AnyOfIntDoubleOther object = (
      $num: 0.5971645863260784,
      string: null,
    );

    Object? json = 0.5971645863260784;

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = (
      $num: 361,
      string: null,
    );

    json = 361;

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json)..validateAnyOf(), equals(object));

    object = (
      $num: null,
      string: 'string',
    );

    json = 'string';

    expect(object.toJson(), equals(json));
    expect($AnyOfIntDoubleOtherExtension.fromJson(json), equals(object));
  });
}
