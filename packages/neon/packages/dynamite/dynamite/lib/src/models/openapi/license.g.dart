// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<License> _$licenseSerializer = _$LicenseSerializer();

class _$LicenseSerializer implements StructuredSerializer<License> {
  @override
  final Iterable<Type> types = const [License, _$License];
  @override
  final String wireName = 'License';

  @override
  Iterable<Object?> serialize(Serializers serializers, License object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.identifier;
    if (value != null) {
      result
        ..add('identifier')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  License deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = LicenseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'identifier':
          result.identifier = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'url':
          result.url = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$License extends License {
  @override
  final String name;
  @override
  final String? identifier;
  @override
  final String? url;

  factory _$License([void Function(LicenseBuilder)? updates]) => (LicenseBuilder()..update(updates))._build();

  _$License._({required this.name, this.identifier, this.url}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'License', 'name');
  }

  @override
  License rebuild(void Function(LicenseBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  LicenseBuilder toBuilder() => LicenseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is License && name == other.name && identifier == other.identifier && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, identifier.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'License')
          ..add('name', name)
          ..add('identifier', identifier)
          ..add('url', url))
        .toString();
  }
}

class LicenseBuilder implements Builder<License, LicenseBuilder> {
  _$License? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _identifier;
  String? get identifier => _$this._identifier;
  set identifier(String? identifier) => _$this._identifier = identifier;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  LicenseBuilder();

  LicenseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _identifier = $v.identifier;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(License other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$License;
  }

  @override
  void update(void Function(LicenseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  License build() => _build();

  _$License _build() {
    final _$result = _$v ??
        _$License._(
            name: BuiltValueNullFieldError.checkNotNull(name, r'License', 'name'), identifier: identifier, url: url);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
