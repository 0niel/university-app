import 'package:built_value/serializer.dart';
import 'package:dynamite_end_to_end_test/enum.openapi.dart';
import 'package:test/test.dart';

void main() {
  group('String', () {
    test('serialize', () {
      const results = {
        EnumString.test: 'test',
        EnumString.$default: 'default',
        EnumString.dollar: r'$dollar$',
      };

      for (final result in results.entries) {
        final serialized = $serializers.serialize(
          result.key,
          specifiedType: const FullType(EnumString),
        );

        expect(serialized, result.value);

        final deserialized = $serializers.deserialize(
          result.value,
          specifiedType: const FullType(EnumString),
        );
        expect(deserialized, result.key);
      }
    });

    test('value', () {
      expect(EnumString.test.value, 'test');
      expect(EnumString.$default.value, 'default');
      expect(EnumString.dollar.value, r'$dollar$');
    });
  });

  group('int', () {
    test('serialize', () {
      const results = {
        EnumInt.$0: 0,
        EnumInt.$1: 1,
        EnumInt.$2: 2,
      };

      for (final result in results.entries) {
        final serialized = $serializers.serialize(
          result.key,
          specifiedType: const FullType(EnumInt),
        );

        expect(serialized, result.value);

        final deserialized = $serializers.deserialize(
          result.value,
          specifiedType: const FullType(EnumInt),
        );
        expect(deserialized, result.key);
      }
    });

    test('value', () {
      expect(EnumInt.$0.value, 0);
      expect(EnumInt.$1.value, 1);
      expect(EnumInt.$2.value, 2);
    });
  });

  group('dynamic', () {
    test('serialize', () {
      const results = {
        EnumDynamic.$0: 0,
        EnumDynamic.string: 'string',
        EnumDynamic.$false: false,
      };

      for (final result in results.entries) {
        final serialized = $serializers.serialize(
          result.key,
          specifiedType: const FullType(EnumDynamic),
        );

        expect(serialized, equals(result.value));

        final deserialized = $serializers.deserialize(
          result.value,
          specifiedType: const FullType(EnumDynamic),
        );
        expect(deserialized, equals(result.key));
      }
    });

    test('value', () {
      expect(EnumDynamic.$0.value, 0);
      expect(EnumDynamic.string.value, 'string');
      expect(EnumDynamic.$false.value, false);
    });
  });

  group('wrapped', () {
    test('serialize', () {
      final object = WrappedEnum(
        (b) => b
          ..string = WrappedEnum_$String.$default
          ..integer = WrappedEnum_Integer.$2,
      );

      const json = {
        'String': 'default',
        'integer': 2,
      };

      expect(object.toJson(), equals(json));
      expect(WrappedEnum.fromJson(json), equals(object));
    });
  });

  test('EnumReference', () {
    final object = EnumReference(
      (b) => b..string = EnumString.$default,
    );

    const json = {
      'string': 'default',
    };

    expect(object.toJson(), equals(json));
    expect(EnumReference.fromJson(json), equals(object));
  });
}
