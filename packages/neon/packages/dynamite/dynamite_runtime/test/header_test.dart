// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:dynamite_runtime/built_value.dart';
import 'package:dynamite_runtime/models.dart';
import 'package:test/test.dart';

part 'header_test.g.dart';

@SerializersFor([
  Header,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addPlugin(const HeaderPlugin())
      ..addBuilderFactory(const FullType(Header, [FullType(bool)]), HeaderBuilder<bool>.new)
      ..addBuilderFactory(const FullType(Header, [FullType(double)]), HeaderBuilder<double>.new)
      ..addBuilderFactory(
        const FullType(Header, [
          FullType(BuiltList, [FullType(int)]),
        ]),
        HeaderBuilder<BuiltList<int>>.new,
      )
      ..addBuilderFactory(const FullType(BuiltList, [FullType(int)]), ListBuilder<int>.new)
      ..addBuilderFactory(
        const FullType(Header, [
          FullType(BuiltList, [FullType(String)]),
        ]),
        HeaderBuilder<BuiltList<String>>.new,
      )
      ..addBuilderFactory(const FullType(BuiltList, [FullType(String)]), ListBuilder<String>.new)
      ..addBuilderFactory(
        const FullType(Header, [
          FullType(BuiltMap, [FullType(String), FullType(int)]),
        ]),
        HeaderBuilder<BuiltMap<String, int>>.new,
      )
      ..addBuilderFactory(const FullType(BuiltMap, [FullType(String), FullType(int)]), MapBuilder<String, int>.new)
      ..addBuilderFactory(const FullType(Header, [FullType(int)]), HeaderBuilder<int>.new)
      ..addBuilderFactory(const FullType(Header, [FullType(String)]), HeaderBuilder<String>.new)
      ..addBuilderFactory(
        const FullType(Header, [
          FullType(Header, [FullType(String)]),
        ]),
        HeaderBuilder<Header<String>>.new,
      ))
    .build();

final Serializers invalidSerializers = (_$serializers.toBuilder()
      ..addPlugin(const HeaderPlugin())
      ..addBuilderFactory(const FullType(Header, [FullType(bool)]), HeaderBuilder<bool>.new))
    .build();

void main() {
  group('Header with known specifiedType holding bool', () {
    final data = Header<bool>((b) => b..content = true);
    final serialized = json.encode(true);
    const specifiedType = FullType(Header, [FullType(bool)]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with unknown specifiedType holding bool', () {
    final data = Header((b) => b..content = true);
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {r'$': 'bool', '': true},
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with known specifiedType holding double', () {
    final data = Header<double>((b) => b..content = 42.5);
    final serialized = json.encode(42.5);
    const specifiedType = FullType(Header, [FullType(double)]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with unknown specifiedType holding double', () {
    final data = Header((b) => b..content = 42.5);
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {r'$': 'double', '': 42.5},
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with known specifiedType holding list', () {
    test('integer list', () {
      final Header<BuiltList<Object>> data = Header<BuiltList<int>>((b) => b..content = BuiltList([1, 2, 3]));
      const serialized = '1,2,3';
      const specifiedType = FullType(Header, [
        FullType(BuiltList, [FullType(int)]),
      ]);

      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), equals(data));
    });

    test('string list', () {
      final data = Header<BuiltList<String>>((b) => b..content = BuiltList(['1', '2', '3']));
      const serialized = '1,2,3';
      const specifiedType = FullType(Header, [
        FullType(BuiltList, [FullType(String)]),
      ]);

      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), equals(data));
    });
  });

  group('Header with unknown specifiedType holding list', () {
    final data = Header((b) => b..content = BuiltList<int>([1, 2, 3]));
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {
          r'$': 'list',
          '': [
            {r'$': 'int', '': 1},
            {r'$': 'int', '': 2},
            {r'$': 'int', '': 3},
          ],
        },
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with known specifiedType holding map', () {
    final data = Header<BuiltMap<String, int>>((b) => b..content = BuiltMap({'one': 1, 'two': 2, 'three': 3}));
    const serialized = 'one,1,two,2,three,3';
    const specifiedType = FullType(Header, [
      FullType(BuiltMap, [FullType(String), FullType(int)]),
    ]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with unknown specifiedType holding map', () {
    final data = Header((b) => b..content = BuiltMap<String, int>({'one': 1, 'two': 2, 'three': 3}));
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {
          r'$': 'encoded_map',
          r'{"$":"String","":"one"}': {r'$': 'int', '': 1},
          r'{"$":"String","":"two"}': {r'$': 'int', '': 2},
          r'{"$":"String","":"three"}': {r'$': 'int', '': 3},
        },
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group(
    'Header with known specifiedType holding int',
    () {
      final data = Header<int>((b) => b..content = 42);
      final serialized = json.encode(42);
      const specifiedType = FullType(Header, [FullType(int)]);

      test('can be serialized', () {
        expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
      });

      test('can be deserialized', () {
        expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
      });
    },
  );

  group('Header with unknown specifiedType holding int', () {
    final data = Header((b) => b..content = 42);
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {r'$': 'int', '': 42},
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with known specifiedType holding String', () {
    final data = Header<String>((b) => b..content = 'test');
    const serialized = 'test';
    const specifiedType = FullType(Header, [FullType(String)]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with unknown specifiedType holding String', () {
    final data = Header((b) => b..content = 'test');
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {r'$': 'String', '': 'test'},
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with known specifiedType holding Header', () {
    final data = Header<Header<String>>(
      (b) => b
        ..content = Header<String>(
          (b) => b..content = 'test',
        ),
    );
    const serialized = 'test';
    const specifiedType = FullType(Header, [
      FullType(Header, [FullType(String)]),
    ]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Header with unknown specifiedType holding Header', () {
    final data = Header<Header<String>>(
      (b) => b
        ..content = Header<String>(
          (b) => b..content = 'test',
        ),
    );
    final serialized = json.decode(
      json.encode({
        r'$': 'Header',
        'content': {
          r'$': 'Header',
          'content': {r'$': 'String', '': 'test'},
        },
      }),
    ) as Object;
    const specifiedType = FullType.unspecified;

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });

  group('Serialize without registered StandardJsonPlugin', () {
    final data = Header<bool>((b) => b..content = true);
    const serialized = true;
    const specifiedType = FullType(Header, [FullType(bool)]);

    test('serialization error', () {
      expect(() => invalidSerializers.serialize(data, specifiedType: specifiedType), throwsA(isA<StateError>()));
    });

    test('deserialization error', () {
      expect(
        () => invalidSerializers.deserialize(serialized, specifiedType: specifiedType),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Serialize null value', () {
    const data = null;
    const serialized = null;
    const specifiedType = FullType(Header, [FullType(bool)]);

    test('can be serialized', () {
      expect(serializers.serialize(data, specifiedType: specifiedType), serialized);
    });

    test('can be deserialized', () {
      expect(serializers.deserialize(serialized, specifiedType: specifiedType), data);
    });
  });
}
