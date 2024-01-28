// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Info> _$infoSerializer = _$InfoSerializer();

class _$InfoSerializer implements StructuredSerializer<Info> {
  @override
  final Iterable<Type> types = const [Info, _$Info];
  @override
  final String wireName = 'Info';

  @override
  Iterable<Object?> serialize(Serializers serializers, Info object, {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'title',
      serializers.serialize(object.title, specifiedType: const FullType(String)),
      'version',
      serializers.serialize(object.version, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.license;
    if (value != null) {
      result
        ..add('license')
        ..add(serializers.serialize(value, specifiedType: const FullType(License)));
    }
    value = object.contact;
    if (value != null) {
      result
        ..add('contact')
        ..add(serializers.serialize(value, specifiedType: const FullType(Contact)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.termsOfService;
    if (value != null) {
      result
        ..add('termsOfService')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.summary;
    if (value != null) {
      result
        ..add('summary')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Info deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = InfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'version':
          result.version = serializers.deserialize(value, specifiedType: const FullType(String))! as String;
          break;
        case 'license':
          result.license.replace(serializers.deserialize(value, specifiedType: const FullType(License))! as License);
          break;
        case 'contact':
          result.contact.replace(serializers.deserialize(value, specifiedType: const FullType(Contact))! as Contact);
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'termsOfService':
          result.termsOfService = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'summary':
          result.summary = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Info extends Info {
  @override
  final String title;
  @override
  final String version;
  @override
  final License? license;
  @override
  final Contact? contact;
  @override
  final String? description;
  @override
  final String? termsOfService;
  @override
  final String? summary;

  factory _$Info([void Function(InfoBuilder)? updates]) => (InfoBuilder()..update(updates))._build();

  _$Info._(
      {required this.title,
      required this.version,
      this.license,
      this.contact,
      this.description,
      this.termsOfService,
      this.summary})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(title, r'Info', 'title');
    BuiltValueNullFieldError.checkNotNull(version, r'Info', 'version');
  }

  @override
  Info rebuild(void Function(InfoBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  InfoBuilder toBuilder() => InfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Info &&
        version == other.version &&
        license == other.license &&
        contact == other.contact &&
        termsOfService == other.termsOfService &&
        summary == other.summary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, license.hashCode);
    _$hash = $jc(_$hash, contact.hashCode);
    _$hash = $jc(_$hash, termsOfService.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Info')
          ..add('title', title)
          ..add('version', version)
          ..add('license', license)
          ..add('contact', contact)
          ..add('description', description)
          ..add('termsOfService', termsOfService)
          ..add('summary', summary))
        .toString();
  }
}

class InfoBuilder implements Builder<Info, InfoBuilder> {
  _$Info? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  LicenseBuilder? _license;
  LicenseBuilder get license => _$this._license ??= LicenseBuilder();
  set license(LicenseBuilder? license) => _$this._license = license;

  ContactBuilder? _contact;
  ContactBuilder get contact => _$this._contact ??= ContactBuilder();
  set contact(ContactBuilder? contact) => _$this._contact = contact;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _termsOfService;
  String? get termsOfService => _$this._termsOfService;
  set termsOfService(String? termsOfService) => _$this._termsOfService = termsOfService;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  InfoBuilder();

  InfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _version = $v.version;
      _license = $v.license?.toBuilder();
      _contact = $v.contact?.toBuilder();
      _description = $v.description;
      _termsOfService = $v.termsOfService;
      _summary = $v.summary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Info other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Info;
  }

  @override
  void update(void Function(InfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Info build() => _build();

  _$Info _build() {
    _$Info _$result;
    try {
      _$result = _$v ??
          _$Info._(
              title: BuiltValueNullFieldError.checkNotNull(title, r'Info', 'title'),
              version: BuiltValueNullFieldError.checkNotNull(version, r'Info', 'version'),
              license: _license?.build(),
              contact: _contact?.build(),
              description: description,
              termsOfService: termsOfService,
              summary: summary);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'license';
        _license?.build();
        _$failedField = 'contact';
        _contact?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Info', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
