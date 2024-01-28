// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Header<Object?>> _$headerSerializer = _$HeaderSerializer();

class _$HeaderSerializer implements StructuredSerializer<Header<Object?>> {
  @override
  final Iterable<Type> types = const [Header, _$Header];
  @override
  final String wireName = 'Header';

  @override
  Iterable<Object?> serialize(Serializers serializers, Header<Object?> object,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified = specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT = isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = <Object?>[
      'content',
      serializers.serialize(object.content, specifiedType: parameterT),
    ];

    return result;
  }

  @override
  Header<Object?> deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified = specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT = isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result =
        isUnderspecified ? HeaderBuilder<Object?>() : serializers.newBuilder(specifiedType) as HeaderBuilder<Object?>;

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'content':
          result.content = serializers.deserialize(value, specifiedType: parameterT);
          break;
      }
    }

    return result.build();
  }
}

class _$Header<T> extends Header<T> {
  @override
  final T content;

  factory _$Header([void Function(HeaderBuilder<T>)? updates]) => (HeaderBuilder<T>()..update(updates))._build();

  _$Header._({required this.content}) : super._() {
    BuiltValueNullFieldError.checkNotNull(content, r'Header', 'content');
    if (T == dynamic) {
      throw BuiltValueMissingGenericsError(r'Header', 'T');
    }
  }

  @override
  Header<T> rebuild(void Function(HeaderBuilder<T>) updates) => (toBuilder()..update(updates)).build();

  @override
  HeaderBuilder<T> toBuilder() => HeaderBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Header && content == other.content;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Header')..add('content', content)).toString();
  }
}

class HeaderBuilder<T> implements Builder<Header<T>, HeaderBuilder<T>> {
  _$Header<T>? _$v;

  T? _content;
  T? get content => _$this._content;
  set content(T? content) => _$this._content = content;

  HeaderBuilder();

  HeaderBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Header<T> other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Header<T>;
  }

  @override
  void update(void Function(HeaderBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Header<T> build() => _build();

  _$Header<T> _build() {
    final _$result =
        _$v ?? _$Header<T>._(content: BuiltValueNullFieldError.checkNotNull(content, r'Header', 'content'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
