// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Response> _$responseSerializer = _$ResponseSerializer();

class _$ResponseSerializer implements StructuredSerializer<Response> {
  @override
  final Iterable<Type> types = const [Response, _$Response];
  @override
  final String wireName = 'Response';

  @override
  Iterable<Object?> serialize(Serializers serializers, Response object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'description',
      serializers.serialize(object.description, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.content;
    if (value != null) {
      result
        ..add('content')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)])));
    }
    value = object.headers;
    if (value != null) {
      result
        ..add('headers')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Header)])));
    }
    return result;
  }

  @override
  Response deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ResponseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'content':
          result.content.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)]))!);
          break;
        case 'headers':
          result.headers.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Header)]))!);
          break;
      }
    }

    return result.build();
  }
}

class _$Response extends Response {
  @override
  final String description;
  @override
  final BuiltMap<String, MediaType>? content;
  @override
  final BuiltMap<String, Header>? headers;

  factory _$Response([void Function(ResponseBuilder)? updates]) => (ResponseBuilder()..update(updates))._build();

  _$Response._({required this.description, this.content, this.headers}) : super._() {
    BuiltValueNullFieldError.checkNotNull(description, r'Response', 'description');
  }

  @override
  Response rebuild(void Function(ResponseBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ResponseBuilder toBuilder() => ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Response && content == other.content && headers == other.headers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, headers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Response')
          ..add('description', description)
          ..add('content', content)
          ..add('headers', headers))
        .toString();
  }
}

class ResponseBuilder implements Builder<Response, ResponseBuilder> {
  _$Response? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MapBuilder<String, MediaType>? _content;
  MapBuilder<String, MediaType> get content => _$this._content ??= MapBuilder<String, MediaType>();
  set content(MapBuilder<String, MediaType>? content) => _$this._content = content;

  MapBuilder<String, Header>? _headers;
  MapBuilder<String, Header> get headers => _$this._headers ??= MapBuilder<String, Header>();
  set headers(MapBuilder<String, Header>? headers) => _$this._headers = headers;

  ResponseBuilder();

  ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _content = $v.content?.toBuilder();
      _headers = $v.headers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Response;
  }

  @override
  void update(void Function(ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Response build() => _build();

  _$Response _build() {
    _$Response _$result;
    try {
      _$result = _$v ??
          _$Response._(
              description: BuiltValueNullFieldError.checkNotNull(description, r'Response', 'description'),
              content: _content?.build(),
              headers: _headers?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'content';
        _content?.build();
        _$failedField = 'headers';
        _headers?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
