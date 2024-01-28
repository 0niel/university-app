// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_scheme.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SecurityScheme> _$securitySchemeSerializer = _$SecuritySchemeSerializer();

class _$SecuritySchemeSerializer implements StructuredSerializer<SecurityScheme> {
  @override
  final Iterable<Type> types = const [SecurityScheme, _$SecurityScheme];
  @override
  final String wireName = 'SecurityScheme';

  @override
  Iterable<Object?> serialize(Serializers serializers, SecurityScheme object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.scheme;
    if (value != null) {
      result
        ..add('scheme')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.$in;
    if (value != null) {
      result
        ..add('\$in')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SecurityScheme deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = SecuritySchemeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'type':
          result.type = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'scheme':
          result.scheme = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case '\$in':
          result.$in = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$SecurityScheme extends SecurityScheme {
  @override
  final String type;
  @override
  final String? description;
  @override
  final String? scheme;
  @override
  final String? $in;
  @override
  final String? name;

  factory _$SecurityScheme([void Function(SecuritySchemeBuilder)? updates]) =>
      (SecuritySchemeBuilder()..update(updates))._build();

  _$SecurityScheme._({required this.type, this.description, this.scheme, this.$in, this.name}) : super._() {
    BuiltValueNullFieldError.checkNotNull(type, r'SecurityScheme', 'type');
  }

  @override
  SecurityScheme rebuild(void Function(SecuritySchemeBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  SecuritySchemeBuilder toBuilder() => SecuritySchemeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SecurityScheme &&
        type == other.type &&
        scheme == other.scheme &&
        $in == other.$in &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, scheme.hashCode);
    _$hash = $jc(_$hash, $in.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SecurityScheme')
          ..add('type', type)
          ..add('description', description)
          ..add('scheme', scheme)
          ..add('\$in', $in)
          ..add('name', name))
        .toString();
  }
}

class SecuritySchemeBuilder implements Builder<SecurityScheme, SecuritySchemeBuilder> {
  _$SecurityScheme? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _scheme;
  String? get scheme => _$this._scheme;
  set scheme(String? scheme) => _$this._scheme = scheme;

  String? _$in;
  String? get $in => _$this._$in;
  set $in(String? $in) => _$this._$in = $in;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SecuritySchemeBuilder();

  SecuritySchemeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _description = $v.description;
      _scheme = $v.scheme;
      _$in = $v.$in;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SecurityScheme other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SecurityScheme;
  }

  @override
  void update(void Function(SecuritySchemeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SecurityScheme build() => _build();

  _$SecurityScheme _build() {
    final _$result = _$v ??
        _$SecurityScheme._(
            type: BuiltValueNullFieldError.checkNotNull(type, r'SecurityScheme', 'type'),
            description: description,
            scheme: scheme,
            $in: $in,
            name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
