// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_string.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ContentString<Object?>> _$contentStringSerializer = _$ContentStringSerializer();

class _$ContentStringSerializer implements StructuredSerializer<ContentString<Object?>> {
  @override
  final Iterable<Type> types = const [ContentString, _$ContentString];
  @override
  final String wireName = 'ContentString';

  @override
  Iterable<Object?> serialize(Serializers serializers, ContentString<Object?> object,
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
  ContentString<Object?> deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final isUnderspecified = specifiedType.isUnspecified || specifiedType.parameters.isEmpty;
    if (!isUnderspecified) serializers.expectBuilder(specifiedType);
    final parameterT = isUnderspecified ? FullType.object : specifiedType.parameters[0];

    final result = isUnderspecified
        ? ContentStringBuilder<Object?>()
        : serializers.newBuilder(specifiedType) as ContentStringBuilder<Object?>;

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

class _$ContentString<T> extends ContentString<T> {
  @override
  final T content;

  factory _$ContentString([void Function(ContentStringBuilder<T>)? updates]) =>
      (ContentStringBuilder<T>()..update(updates))._build();

  _$ContentString._({required this.content}) : super._() {
    BuiltValueNullFieldError.checkNotNull(content, r'ContentString', 'content');
    if (T == dynamic) {
      throw BuiltValueMissingGenericsError(r'ContentString', 'T');
    }
  }

  @override
  ContentString<T> rebuild(void Function(ContentStringBuilder<T>) updates) => (toBuilder()..update(updates)).build();

  @override
  ContentStringBuilder<T> toBuilder() => ContentStringBuilder<T>()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContentString && content == other.content;
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
    return (newBuiltValueToStringHelper(r'ContentString')..add('content', content)).toString();
  }
}

class ContentStringBuilder<T> implements Builder<ContentString<T>, ContentStringBuilder<T>> {
  _$ContentString<T>? _$v;

  T? _content;
  T? get content => _$this._content;
  set content(T? content) => _$this._content = content;

  ContentStringBuilder();

  ContentStringBuilder<T> get _$this {
    final $v = _$v;
    if ($v != null) {
      _content = $v.content;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContentString<T> other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ContentString<T>;
  }

  @override
  void update(void Function(ContentStringBuilder<T>)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContentString<T> build() => _build();

  _$ContentString<T> _build() {
    final _$result = _$v ??
        _$ContentString<T>._(content: BuiltValueNullFieldError.checkNotNull(content, r'ContentString', 'content'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
