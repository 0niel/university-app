import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/helpers/dart_helpers.dart';
import 'package:dynamite/src/helpers/docs.dart';
import 'package:dynamite/src/models/exceptions.dart';
import 'package:dynamite/src/models/openapi/media_type.dart';
import 'package:dynamite/src/models/openapi/schema.dart';
import 'package:meta/meta.dart';

part 'parameter.g.dart';

abstract class Parameter implements Built<Parameter, ParameterBuilder> {
  factory Parameter([void Function(ParameterBuilder) updates]) = _$Parameter;

  const Parameter._();

  static Serializer<Parameter> get serializer => _$parameterSerializer;

  String get name;

  @BuiltValueField(wireName: 'in')
  ParameterType get $in;

  @BuiltValueField(compare: false)
  String? get description;

  bool get required;

  @protected
  @BuiltValueField(wireName: 'schema')
  Schema? get $schema;

  BuiltMap<String, MediaType>? get content;

  bool get explode;

  bool get allowReserved;

  ParameterStyle get style;

  Schema? get schema {
    if ($schema != null) {
      return $schema;
    }

    if (content != null && content!.isNotEmpty) {
      if (content!.length > 1) {
        print('Can not work with multiple mime types right now. Using the first supported.');
      }
      return Schema(
        (b) => b
          ..type = SchemaType.string
          ..contentMediaType = content!.entries.first.key
          ..contentSchema = content!.entries.first.value.schema!.toBuilder(),
      );
    }

    return null;
  }

  /// Builds the uri template value for this parameter.
  ///
  /// When the parameter is in a collection of parameters the prefix can be different.
  /// Specify [isFirst] according to this. When [withPrefix] is `false` the prefix will be dropped entirely.
  ///
  /// Returns `null` if the parameter does not support a uri template.
  String? uriTemplate({
    bool isFirst = true,
    bool withPrefix = true,
  }) {
    final buffer = StringBuffer();

    final prefix = switch (style) {
      ParameterStyle.simple => null,
      ParameterStyle.label => '.',
      ParameterStyle.matrix => ';',
      ParameterStyle.form => isFirst ? '?' : '&',
      ParameterStyle.spaceDelimited || ParameterStyle.pipeDelimited || ParameterStyle.deepObject || _ => null,
    };

    if (prefix == null && style != ParameterStyle.simple) {
      return null;
    }

    if (prefix != null && withPrefix) {
      buffer.write(prefix);
    }

    if (allowReserved) {
      buffer.write('+');
    }

    buffer.write(pctEncodedName);

    if (explode) {
      buffer.write('*');
    }

    return buffer.toString();
  }

  /// The pct encoded name of this parameter.
  String get pctEncodedName => Uri.encodeQueryComponent(name);

  @BuiltValueHook(finalizeBuilder: true)
  static void _defaults(ParameterBuilder b) {
    b.required ??= false;
    b._allowReserved ??= false;
    b._explode ??= switch (b.$in!) {
      ParameterType.query || ParameterType.cookie => true,
      ParameterType.path || ParameterType.header => false,
      _ => throw StateError('invalid parameter type'),
    };
    b._style ??= switch (b.$in!) {
      ParameterType.query => ParameterStyle.form,
      ParameterType.path => ParameterStyle.simple,
      ParameterType.header => ParameterStyle.simple,
      ParameterType.cookie => ParameterStyle.form,
      _ => throw StateError('invalid parameter type'),
    };

    switch (b.style) {
      case ParameterStyle.matrix:
        if (b._$in != ParameterType.path) {
          throw OpenAPISpecError('ParameterStyle.matrix can only be used in path parameters.');
        }
      case ParameterStyle.label:
        if (b._$in != ParameterType.path) {
          throw OpenAPISpecError('ParameterStyle.label can only be used in path parameters.');
        }

      case ParameterStyle.form:
        if (b._$in != ParameterType.query && b._$in != ParameterType.cookie) {
          throw OpenAPISpecError('ParameterStyle.form can only be used in query or cookie parameters.');
        }

      case ParameterStyle.simple:
        if (b._$in != ParameterType.path && b._$in != ParameterType.header) {
          throw OpenAPISpecError('ParameterStyle.simple can only be used in path or header parameters.');
        }

      case ParameterStyle.spaceDelimited:
        if (b._$schema?.type != SchemaType.array && b._$schema?.type != SchemaType.object) {
          throw OpenAPISpecError('ParameterStyle.spaceDelimited can only be used with array or object  schemas.');
        }
        if (b._$in != ParameterType.query) {
          throw OpenAPISpecError('ParameterStyle.spaceDelimited can only be used in query parameters.');
        }

      case ParameterStyle.pipeDelimited:
        if (b._$schema?.type != SchemaType.array && b._$schema?.type != SchemaType.object) {
          throw OpenAPISpecError('ParameterStyle.pipeDelimited can only be used with array or object schemas.');
        }
        if (b._$in != ParameterType.query) {
          throw OpenAPISpecError('ParameterStyle.pipeDelimited can only be used in query parameters.');
        }

      case ParameterStyle.deepObject:
        if (b._$schema?.type != SchemaType.object) {
          throw OpenAPISpecError('ParameterStyle.deepObject can only be used with object schemas.');
        }
        if (b._$in != ParameterType.query) {
          throw OpenAPISpecError('ParameterStyle.deepObject can only be used in query parameters.');
        }
    }

    if (b.$in == ParameterType.path && !b.required!) {
      throw OpenAPISpecError('Path parameters must be required but ${b.name} is not.');
    }

    if (b.required! && b._$schema != null && b.$schema.$default != null) {
      print('Required parameters should not specify default values.');
    }

    if (b._$schema != null && b._content != null) {
      throw OpenAPISpecError('Only one of schema or content must be set in parameter ${b.name}.');
    }
  }

  String get formattedDescription {
    final name = toDartName(this.name);

    final buffer = StringBuffer()
      ..write('$docsSeparator   * ')
      ..write('[$name]');

    if (description != null) {
      buffer.write(' $description');
      if (!description!.endsWith('.')) {
        buffer.write('.');
      }
    }

    Object? $default = schema?.$default;
    if ($default != null) {
      if ($default.toString() == '') {
        $default = "''";
      }

      buffer.write(' Defaults to `${$default}`.');
    }

    return buffer.toString();
  }
}

class ParameterType extends EnumClass {
  const ParameterType._(super.name);

  static const ParameterType path = _$parameterTypePath;
  static const ParameterType query = _$parameterTypeQuery;
  static const ParameterType header = _$parameterTypeHeader;
  static const ParameterType cookie = _$parameterTypeCookie;

  static BuiltSet<ParameterType> get values => _$parameterTypeValues;

  static ParameterType valueOf(String name) => _$parameterType(name);

  static Serializer<ParameterType> get serializer => _$parameterTypeSerializer;
}

class ParameterStyle extends EnumClass {
  const ParameterStyle._(super.name);

  static const ParameterStyle matrix = _$parameterStyleMatrix;
  static const ParameterStyle label = _$parameterStyleLabel;
  static const ParameterStyle form = _$parameterStyleForm;
  static const ParameterStyle simple = _$parameterStyleSimple;
  static const ParameterStyle spaceDelimited = _$parameterStyleSpaceDelimited;
  static const ParameterStyle pipeDelimited = _$parameterStylePipeDelimited;
  static const ParameterStyle deepObject = _$parameterStyleDeepObject;

  static BuiltSet<ParameterStyle> get values => _$parameterStyleValues;

  static ParameterStyle valueOf(String name) => _$parameterStyle(name);

  static Serializer<ParameterStyle> get serializer => _$parameterStyleSerializer;
}
