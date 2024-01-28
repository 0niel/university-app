import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dynamite_end_to_end_test/one_of.openapi.dart';
import 'package:test/test.dart';

void main() {
  test('ObjectOneOf', () {
    ObjectOneOf object = (
      objectOneOf0: ObjectOneOf0((b) => b..attribute1OneOf = 'attribute1OneOf'),
      objectOneOf1: null,
    );

    Object? json = {'attribute1-oneOf': 'attribute1OneOf'};

    expect(object.toJson(), equals(json));
    expect($ObjectOneOfExtension.fromJson(json), equals(object));

    object = (
      objectOneOf0: null,
      objectOneOf1: ObjectOneOf1((b) => b..attribute2OneOf = 'attribute2OneOf'),
    );

    json = {'attribute2-oneOf': 'attribute2OneOf'};

    expect(object.toJson(), equals(json));
    expect($ObjectOneOfExtension.fromJson(json), equals(object));
  });

  test('MixedOneOf', () {
    MixedOneOf object = (
      mixedOneOf1: MixedOneOf1((b) => b..attributeOneOf = 'attributeOneOf'),
      string: null,
    );

    Object? json = {'attribute-oneOf': 'attributeOneOf'};

    expect(object.toJson(), equals(json));
    expect($MixedOneOfExtension.fromJson(json), equals(object));

    object = (
      mixedOneOf1: null,
      string: 'string',
    );

    json = 'string';

    expect(object.toJson(), equals(json));
    expect($MixedOneOfExtension.fromJson(json), equals(object));
  });

  test('OneObjectOneOf', () {
    final object = OneObjectOneOf0((b) => b..attributeOneOf = 'attributeOneOf');

    final json = {'attribute-oneOf': 'attributeOneOf'};

    expect(object.toJson(), equals(json));
    expect(OneObjectOneOf0.fromJson(json), equals(object));
    expect(object, isA<OneObjectOneOf>());
  });

  test('OneValueOneOf', () {
    const object = 'string';
    expect(object, isA<OneValueOneOf>());
  });

  test('OneOfIntDouble', () {
    Object? object = 0.5971645863260784;

    expect(object, isA<OneOfIntDouble>());

    object = 361;
    expect(object, isA<OneOfIntDouble>());
  });

  test('OneOfIntDoubleNum', () {
    Object? object = 0.6748612915546136;

    expect(object, isA<OneOfIntDoubleNum>());

    object = 769;
    expect(object, isA<OneOfIntDoubleNum>());
  });

  test('OneOfIntDoubleOther', () {
    OneOfIntDoubleOther object = (
      $num: 0.5971645863260784,
      string: null,
    );

    Object? json = 0.5971645863260784;

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = (
      $num: 361,
      string: null,
    );

    json = 361;

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));

    object = (
      $num: null,
      string: 'string',
    );

    json = 'string';

    expect(object.toJson(), equals(json));
    expect($OneOfIntDoubleOtherExtension.fromJson(json), equals(object));
  });

  test('OneOfUnspecifiedArray', () {
    OneOfUnspecifiedArray object = (
      builtListJsonObject: BuiltList([]),
      oneOfUnspecifiedArray0: null,
    );

    Object? json = [];

    expect(object.toJson(), equals(json));
    expect($OneOfUnspecifiedArrayExtension.fromJson(json), equals(object));

    object = (
      builtListJsonObject: BuiltList([JsonObject('value1'), JsonObject('value2'), JsonObject('value3')]),
      oneOfUnspecifiedArray0: null,
    );

    json = ['value1', 'value2', 'value3'];

    expect(object.toJson(), equals(json));
    expect($OneOfUnspecifiedArrayExtension.fromJson(json), equals(object));
  });

  test('OneOfStringArray', () {
    OneOfStringArray object = (
      builtListString: BuiltList<String>(),
      oneOfStringArray0: null,
    );

    Object? json = [];

    expect(object.toJson(), equals(json));
    expect($OneOfStringArrayExtension.fromJson(json), equals(object));

    object = (
      builtListString: BuiltList<String>(['value1', 'value2', 'value3']),
      oneOfStringArray0: null,
    );

    json = ['value1', 'value2', 'value3'];

    expect(object.toJson(), equals(json));
    expect($OneOfStringArrayExtension.fromJson(json), equals(object));
  });
}
