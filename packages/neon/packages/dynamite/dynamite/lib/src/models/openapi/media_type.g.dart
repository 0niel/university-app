// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MediaType> _$mediaTypeSerializer = _$MediaTypeSerializer();

class _$MediaTypeSerializer implements StructuredSerializer<MediaType> {
  @override
  final Iterable<Type> types = const [MediaType, _$MediaType];
  @override
  final String wireName = 'MediaType';

  @override
  Iterable<Object?> serialize(Serializers serializers, MediaType object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.schema;
    if (value != null) {
      result
        ..add('schema')
        ..add(serializers.serialize(value, specifiedType: const FullType(Schema)));
    }
    return result;
  }

  @override
  MediaType deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = MediaTypeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'schema':
          result.schema.replace(serializers.deserialize(value, specifiedType: const FullType(Schema))! as Schema);
          break;
      }
    }

    return result.build();
  }
}

class _$MediaType extends MediaType {
  @override
  final Schema? schema;

  factory _$MediaType([void Function(MediaTypeBuilder)? updates]) => (MediaTypeBuilder()..update(updates))._build();

  _$MediaType._({this.schema}) : super._();

  @override
  MediaType rebuild(void Function(MediaTypeBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  MediaTypeBuilder toBuilder() => MediaTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaType && schema == other.schema;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, schema.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaType')..add('schema', schema)).toString();
  }
}

class MediaTypeBuilder implements Builder<MediaType, MediaTypeBuilder> {
  _$MediaType? _$v;

  SchemaBuilder? _schema;
  SchemaBuilder get schema => _$this._schema ??= SchemaBuilder();
  set schema(SchemaBuilder? schema) => _$this._schema = schema;

  MediaTypeBuilder();

  MediaTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _schema = $v.schema?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaType other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MediaType;
  }

  @override
  void update(void Function(MediaTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaType build() => _build();

  _$MediaType _build() {
    _$MediaType _$result;
    try {
      _$result = _$v ?? _$MediaType._(schema: _schema?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schema';
        _schema?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'MediaType', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
