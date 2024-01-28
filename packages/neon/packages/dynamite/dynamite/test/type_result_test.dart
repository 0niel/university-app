import 'package:built_collection/built_collection.dart';
import 'package:dynamite/src/models/type_result.dart';
import 'package:test/test.dart';

void main() {
  group(TypeResultList, () {
    test('name', () {
      final subType = TypeResultBase('String');
      final type = TypeResultList('BuiltList', subType);

      expect(type.name, 'BuiltList<String>');
      expect(type.fullType, 'const FullType(BuiltList, [FullType(String)])');
      expect(
        type.serializers.toList(),
        const ['..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)'],
      );
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(String)]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(BuiltList, [FullType(String)]))! as BuiltList<String>',
      );
    });

    test('Nested list', () {
      final subType = TypeResultBase('String');
      var type = TypeResultList('BuiltList', subType);
      type = TypeResultList('BuiltList', type);

      expect(type.name, 'BuiltList<BuiltList<String>>');
      expect(type.fullType, 'const FullType(BuiltList, [FullType(BuiltList, [FullType(String)])])');
      expect(
        type.serializers.toList(),
        const [
          '..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)',
          '..addBuilderFactory(const FullType(BuiltList, [FullType(BuiltList, [FullType(String)])]), ListBuilder<BuiltList<String>>.new)',
        ],
      );
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(BuiltList, [FullType(String)])]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(BuiltList, [FullType(BuiltList, [FullType(String)])]))! as BuiltList<BuiltList<String>>',
      );
    });

    test('equality', () {
      final subType1 = TypeResultBase('String');
      final type1 = TypeResultList('BuiltList', subType1);

      final subType2 = TypeResultBase('String');
      final type2 = TypeResultList('BuiltList', subType2);

      expect(type1, equals(type2));
      expect(type1.hashCode, type2.hashCode);
    });
  });

  group(TypeResultMap, () {
    test('name', () {
      final subType = TypeResultBase('int');
      final type = TypeResultMap('BuiltMap', subType);

      expect(type.name, 'BuiltMap<String, int>');
      expect(type.fullType, 'const FullType(BuiltMap, [FullType(String), FullType(int)])');
      expect(
        type.serializers.toList(),
        const [
          '..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(int)]), MapBuilder<String, int>.new)',
        ],
      );
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]))! as BuiltMap<String, int>',
      );
    });

    test('Nested map', () {
      final subType = TypeResultBase('int');
      var type = TypeResultMap('BuiltMap', subType);
      type = TypeResultMap('BuiltMap', type);

      expect(type.name, 'BuiltMap<String, BuiltMap<String, int>>');
      expect(
        type.fullType,
        'const FullType(BuiltMap, [FullType(String), FullType(BuiltMap, [FullType(String), FullType(int)])])',
      );
      expect(
        type.serializers.toList(),
        const [
          '..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(int)]), MapBuilder<String, int>.new)',
          '..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(BuiltMap, [FullType(String), FullType(int)])]), MapBuilder<String, BuiltMap<String, int>>.new)',
        ],
      );
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltMap, [FullType(String), FullType(int)])]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(BuiltMap, [FullType(String), FullType(BuiltMap, [FullType(String), FullType(int)])]))! as BuiltMap<String, BuiltMap<String, int>>',
      );
    });

    test('equality', () {
      final subType1 = TypeResultBase('String');
      final type1 = TypeResultMap('BuiltList', subType1);

      final subType2 = TypeResultBase('String');
      final type2 = TypeResultMap('BuiltList', subType2);

      expect(type1, equals(type2));
      expect(type1.hashCode, type2.hashCode);
    });
  });

  group(TypeResultObject, () {
    test('name', () {
      final subType = TypeResultBase('String');
      final type = TypeResultObject('CustomType', generics: BuiltList([subType]));

      expect(type.name, 'CustomType<String>');
      expect(type.fullType, 'const FullType(CustomType, [FullType(String)])');
      expect(
        type.serializers.toList(),
        const [
          '..addBuilderFactory(const FullType(CustomType, [FullType(String)]), CustomTypeBuilder<String>.new)',
          '..add(CustomType.serializer)',
        ],
      );
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(CustomType, [FullType(String)]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(CustomType, [FullType(String)]))! as CustomType<String>',
      );
    });

    test('ContentString', () {
      final subType = TypeResultBase('int');
      final type = TypeResultObject('ContentString', generics: BuiltList([subType]));

      expect(type.name, 'ContentString<int>');
      expect(type.fullType, 'const FullType(ContentString, [FullType(int)])');
      expect(type.serializers.toList(), const [
        '..addBuilderFactory(const FullType(ContentString, [FullType(int)]), ContentStringBuilder<int>.new)',
        '..add(ContentString.serializer)',
      ]);
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(ContentString, [FullType(int)]))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(ContentString, [FullType(int)]))! as ContentString<int>',
      );
    });

    test('equality', () {
      final subType1 = TypeResultBase('String');
      final type1 = TypeResultObject('CustomType', generics: BuiltList([subType1]));

      final subType2 = TypeResultBase('String');
      final type2 = TypeResultObject('CustomType', generics: BuiltList([subType2]));

      expect(type1, equals(type2));
      expect(type1.hashCode, type2.hashCode);
    });
  });

  group(TypeResultBase, () {
    test('name', () {
      final type = TypeResultBase('String');

      expect(type.name, 'String');
      expect(type.fullType, 'const FullType(String)');
      expect(type.serializers.toList(), const <String>[]);
      expect(
        type.serialize('value'),
        r'_$jsonSerializers.serialize(value, specifiedType: const FullType(String))',
      );
      expect(
        type.deserialize('value'),
        r'_$jsonSerializers.deserialize(value, specifiedType: const FullType(String))! as String',
      );
    });

    test('equality', () {
      final type1 = TypeResultBase('String');

      final type2 = TypeResultBase('String');

      expect(type1, equals(type2));
      expect(type1.hashCode, type2.hashCode);
    });
  });
}
