// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RequestBody> _$requestBodySerializer = _$RequestBodySerializer();

class _$RequestBodySerializer implements StructuredSerializer<RequestBody> {
  @override
  final Iterable<Type> types = const [RequestBody, _$RequestBody];
  @override
  final String wireName = 'RequestBody';

  @override
  Iterable<Object?> serialize(Serializers serializers, RequestBody object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'required',
      serializers.serialize(object.required, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.content;
    if (value != null) {
      result
        ..add('content')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)])));
    }
    return result;
  }

  @override
  RequestBody deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = RequestBodyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'content':
          result.content.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(MediaType)]))!);
          break;
        case 'required':
          result.required = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$RequestBody extends RequestBody {
  @override
  final String? description;
  @override
  final BuiltMap<String, MediaType>? content;
  @override
  final bool required;

  factory _$RequestBody([void Function(RequestBodyBuilder)? updates]) =>
      (RequestBodyBuilder()..update(updates))._build();

  _$RequestBody._({this.description, this.content, required this.required}) : super._() {
    BuiltValueNullFieldError.checkNotNull(required, r'RequestBody', 'required');
  }

  @override
  RequestBody rebuild(void Function(RequestBodyBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  RequestBodyBuilder toBuilder() => RequestBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RequestBody && content == other.content && required == other.required;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, required.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RequestBody')
          ..add('description', description)
          ..add('content', content)
          ..add('required', required))
        .toString();
  }
}

class RequestBodyBuilder implements Builder<RequestBody, RequestBodyBuilder> {
  _$RequestBody? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  MapBuilder<String, MediaType>? _content;
  MapBuilder<String, MediaType> get content => _$this._content ??= MapBuilder<String, MediaType>();
  set content(MapBuilder<String, MediaType>? content) => _$this._content = content;

  bool? _required;
  bool? get required => _$this._required;
  set required(bool? required) => _$this._required = required;

  RequestBodyBuilder();

  RequestBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _content = $v.content?.toBuilder();
      _required = $v.required;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RequestBody other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RequestBody;
  }

  @override
  void update(void Function(RequestBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RequestBody build() => _build();

  _$RequestBody _build() {
    RequestBody._defaults(this);
    _$RequestBody _$result;
    try {
      _$result = _$v ??
          _$RequestBody._(
              description: description,
              content: _content?.build(),
              required: BuiltValueNullFieldError.checkNotNull(required, r'RequestBody', 'required'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'content';
        _content?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'RequestBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
