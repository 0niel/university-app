// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharebymail.openapi.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop>
    _$capabilities0FilesSharingSharebymailUploadFilesDropSerializer =
    _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDropSerializer();
Serializer<Capabilities0_FilesSharing_Sharebymail_Password> _$capabilities0FilesSharingSharebymailPasswordSerializer =
    _$Capabilities0_FilesSharing_Sharebymail_PasswordSerializer();
Serializer<Capabilities0_FilesSharing_Sharebymail_ExpireDate>
    _$capabilities0FilesSharingSharebymailExpireDateSerializer =
    _$Capabilities0_FilesSharing_Sharebymail_ExpireDateSerializer();
Serializer<Capabilities0_FilesSharing_Sharebymail> _$capabilities0FilesSharingSharebymailSerializer =
    _$Capabilities0_FilesSharing_SharebymailSerializer();
Serializer<Capabilities0_FilesSharing> _$capabilities0FilesSharingSerializer = _$Capabilities0_FilesSharingSerializer();
Serializer<Capabilities0> _$capabilities0Serializer = _$Capabilities0Serializer();

class _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDropSerializer
    implements StructuredSerializer<Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop> {
  @override
  final Iterable<Type> types = const [
    Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop,
    _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop
  ];
  @override
  final String wireName = 'Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities0_FilesSharing_Sharebymail_PasswordSerializer
    implements StructuredSerializer<Capabilities0_FilesSharing_Sharebymail_Password> {
  @override
  final Iterable<Type> types = const [
    Capabilities0_FilesSharing_Sharebymail_Password,
    _$Capabilities0_FilesSharing_Sharebymail_Password
  ];
  @override
  final String wireName = 'Capabilities0_FilesSharing_Sharebymail_Password';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0_FilesSharing_Sharebymail_Password object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'enforced',
      serializers.serialize(object.enforced, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_Password deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0_FilesSharing_Sharebymail_PasswordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforced':
          result.enforced = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities0_FilesSharing_Sharebymail_ExpireDateSerializer
    implements StructuredSerializer<Capabilities0_FilesSharing_Sharebymail_ExpireDate> {
  @override
  final Iterable<Type> types = const [
    Capabilities0_FilesSharing_Sharebymail_ExpireDate,
    _$Capabilities0_FilesSharing_Sharebymail_ExpireDate
  ];
  @override
  final String wireName = 'Capabilities0_FilesSharing_Sharebymail_ExpireDate';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0_FilesSharing_Sharebymail_ExpireDate object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'enforced',
      serializers.serialize(object.enforced, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_ExpireDate deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'enforced':
          result.enforced = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities0_FilesSharing_SharebymailSerializer
    implements StructuredSerializer<Capabilities0_FilesSharing_Sharebymail> {
  @override
  final Iterable<Type> types = const [Capabilities0_FilesSharing_Sharebymail, _$Capabilities0_FilesSharing_Sharebymail];
  @override
  final String wireName = 'Capabilities0_FilesSharing_Sharebymail';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0_FilesSharing_Sharebymail object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'enabled',
      serializers.serialize(object.enabled, specifiedType: const FullType(bool)),
      'send_password_by_mail',
      serializers.serialize(object.sendPasswordByMail, specifiedType: const FullType(bool)),
      'upload_files_drop',
      serializers.serialize(object.uploadFilesDrop,
          specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop)),
      'password',
      serializers.serialize(object.password,
          specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_Password)),
      'expire_date',
      serializers.serialize(object.expireDate,
          specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_ExpireDate)),
    ];

    return result;
  }

  @override
  Capabilities0_FilesSharing_Sharebymail deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0_FilesSharing_SharebymailBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enabled':
          result.enabled = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'send_password_by_mail':
          result.sendPasswordByMail = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'upload_files_drop':
          result.uploadFilesDrop.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop))!
              as Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop);
          break;
        case 'password':
          result.password.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_Password))!
              as Capabilities0_FilesSharing_Sharebymail_Password);
          break;
        case 'expire_date':
          result.expireDate.replace(serializers.deserialize(value,
                  specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail_ExpireDate))!
              as Capabilities0_FilesSharing_Sharebymail_ExpireDate);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities0_FilesSharingSerializer implements StructuredSerializer<Capabilities0_FilesSharing> {
  @override
  final Iterable<Type> types = const [Capabilities0_FilesSharing, _$Capabilities0_FilesSharing];
  @override
  final String wireName = 'Capabilities0_FilesSharing';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0_FilesSharing object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'sharebymail',
      serializers.serialize(object.sharebymail, specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail)),
    ];

    return result;
  }

  @override
  Capabilities0_FilesSharing deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0_FilesSharingBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'sharebymail':
          result.sharebymail.replace(
              serializers.deserialize(value, specifiedType: const FullType(Capabilities0_FilesSharing_Sharebymail))!
                  as Capabilities0_FilesSharing_Sharebymail);
          break;
      }
    }

    return result.build();
  }
}

class _$Capabilities0Serializer implements StructuredSerializer<Capabilities0> {
  @override
  final Iterable<Type> types = const [Capabilities0, _$Capabilities0];
  @override
  final String wireName = 'Capabilities0';

  @override
  Iterable<Object?> serialize(Serializers serializers, Capabilities0 object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'files_sharing',
      serializers.serialize(object.filesSharing, specifiedType: const FullType(Capabilities0_FilesSharing)),
    ];

    return result;
  }

  @override
  Capabilities0 deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = Capabilities0Builder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'files_sharing':
          result.filesSharing.replace(serializers.deserialize(value,
              specifiedType: const FullType(Capabilities0_FilesSharing))! as Capabilities0_FilesSharing);
          break;
      }
    }

    return result.build();
  }
}

abstract mixin class $Capabilities0_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder {
  void replace($Capabilities0_FilesSharing_Sharebymail_UploadFilesDropInterface other);
  void update(void Function($Capabilities0_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);
}

class _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop
    extends Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop {
  @override
  final bool enabled;

  factory _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop(
          [void Function(Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder)? updates]) =>
      (Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder()..update(updates))._build();

  _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop._({required this.enabled}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        enabled, r'Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop', 'enabled');
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop rebuild(
          void Function(Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder toBuilder() =>
      Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop && enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop')
          ..add('enabled', enabled))
        .toString();
  }
}

class Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder
    implements
        Builder<Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop,
            Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder>,
        $Capabilities0_FilesSharing_Sharebymail_UploadFilesDropInterfaceBuilder {
  _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder();

  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop;
  }

  @override
  void update(void Function(Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop build() => _build();

  _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop _build() {
    final _$result = _$v ??
        _$Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop', 'enabled'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities0_FilesSharing_Sharebymail_PasswordInterfaceBuilder {
  void replace($Capabilities0_FilesSharing_Sharebymail_PasswordInterface other);
  void update(void Function($Capabilities0_FilesSharing_Sharebymail_PasswordInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get enforced;
  set enforced(bool? enforced);
}

class _$Capabilities0_FilesSharing_Sharebymail_Password extends Capabilities0_FilesSharing_Sharebymail_Password {
  @override
  final bool enabled;
  @override
  final bool enforced;

  factory _$Capabilities0_FilesSharing_Sharebymail_Password(
          [void Function(Capabilities0_FilesSharing_Sharebymail_PasswordBuilder)? updates]) =>
      (Capabilities0_FilesSharing_Sharebymail_PasswordBuilder()..update(updates))._build();

  _$Capabilities0_FilesSharing_Sharebymail_Password._({required this.enabled, required this.enforced}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities0_FilesSharing_Sharebymail_Password', 'enabled');
    BuiltValueNullFieldError.checkNotNull(enforced, r'Capabilities0_FilesSharing_Sharebymail_Password', 'enforced');
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_Password rebuild(
          void Function(Capabilities0_FilesSharing_Sharebymail_PasswordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder toBuilder() =>
      Capabilities0_FilesSharing_Sharebymail_PasswordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0_FilesSharing_Sharebymail_Password &&
        enabled == other.enabled &&
        enforced == other.enforced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, enforced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0_FilesSharing_Sharebymail_Password')
          ..add('enabled', enabled)
          ..add('enforced', enforced))
        .toString();
  }
}

class Capabilities0_FilesSharing_Sharebymail_PasswordBuilder
    implements
        Builder<Capabilities0_FilesSharing_Sharebymail_Password,
            Capabilities0_FilesSharing_Sharebymail_PasswordBuilder>,
        $Capabilities0_FilesSharing_Sharebymail_PasswordInterfaceBuilder {
  _$Capabilities0_FilesSharing_Sharebymail_Password? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _enforced;
  bool? get enforced => _$this._enforced;
  set enforced(covariant bool? enforced) => _$this._enforced = enforced;

  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder();

  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _enforced = $v.enforced;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0_FilesSharing_Sharebymail_Password other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0_FilesSharing_Sharebymail_Password;
  }

  @override
  void update(void Function(Capabilities0_FilesSharing_Sharebymail_PasswordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_Password build() => _build();

  _$Capabilities0_FilesSharing_Sharebymail_Password _build() {
    final _$result = _$v ??
        _$Capabilities0_FilesSharing_Sharebymail_Password._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'Capabilities0_FilesSharing_Sharebymail_Password', 'enabled'),
            enforced: BuiltValueNullFieldError.checkNotNull(
                enforced, r'Capabilities0_FilesSharing_Sharebymail_Password', 'enforced'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities0_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder {
  void replace($Capabilities0_FilesSharing_Sharebymail_ExpireDateInterface other);
  void update(void Function($Capabilities0_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get enforced;
  set enforced(bool? enforced);
}

class _$Capabilities0_FilesSharing_Sharebymail_ExpireDate extends Capabilities0_FilesSharing_Sharebymail_ExpireDate {
  @override
  final bool enabled;
  @override
  final bool enforced;

  factory _$Capabilities0_FilesSharing_Sharebymail_ExpireDate(
          [void Function(Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder)? updates]) =>
      (Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder()..update(updates))._build();

  _$Capabilities0_FilesSharing_Sharebymail_ExpireDate._({required this.enabled, required this.enforced}) : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities0_FilesSharing_Sharebymail_ExpireDate', 'enabled');
    BuiltValueNullFieldError.checkNotNull(enforced, r'Capabilities0_FilesSharing_Sharebymail_ExpireDate', 'enforced');
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_ExpireDate rebuild(
          void Function(Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder toBuilder() =>
      Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0_FilesSharing_Sharebymail_ExpireDate &&
        enabled == other.enabled &&
        enforced == other.enforced;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, enforced.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0_FilesSharing_Sharebymail_ExpireDate')
          ..add('enabled', enabled)
          ..add('enforced', enforced))
        .toString();
  }
}

class Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder
    implements
        Builder<Capabilities0_FilesSharing_Sharebymail_ExpireDate,
            Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder>,
        $Capabilities0_FilesSharing_Sharebymail_ExpireDateInterfaceBuilder {
  _$Capabilities0_FilesSharing_Sharebymail_ExpireDate? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _enforced;
  bool? get enforced => _$this._enforced;
  set enforced(covariant bool? enforced) => _$this._enforced = enforced;

  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder();

  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _enforced = $v.enforced;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0_FilesSharing_Sharebymail_ExpireDate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0_FilesSharing_Sharebymail_ExpireDate;
  }

  @override
  void update(void Function(Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0_FilesSharing_Sharebymail_ExpireDate build() => _build();

  _$Capabilities0_FilesSharing_Sharebymail_ExpireDate _build() {
    final _$result = _$v ??
        _$Capabilities0_FilesSharing_Sharebymail_ExpireDate._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'Capabilities0_FilesSharing_Sharebymail_ExpireDate', 'enabled'),
            enforced: BuiltValueNullFieldError.checkNotNull(
                enforced, r'Capabilities0_FilesSharing_Sharebymail_ExpireDate', 'enforced'));
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities0_FilesSharing_SharebymailInterfaceBuilder {
  void replace($Capabilities0_FilesSharing_SharebymailInterface other);
  void update(void Function($Capabilities0_FilesSharing_SharebymailInterfaceBuilder) updates);
  bool? get enabled;
  set enabled(bool? enabled);

  bool? get sendPasswordByMail;
  set sendPasswordByMail(bool? sendPasswordByMail);

  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder get uploadFilesDrop;
  set uploadFilesDrop(Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder? uploadFilesDrop);

  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder get password;
  set password(Capabilities0_FilesSharing_Sharebymail_PasswordBuilder? password);

  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder get expireDate;
  set expireDate(Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder? expireDate);
}

class _$Capabilities0_FilesSharing_Sharebymail extends Capabilities0_FilesSharing_Sharebymail {
  @override
  final bool enabled;
  @override
  final bool sendPasswordByMail;
  @override
  final Capabilities0_FilesSharing_Sharebymail_UploadFilesDrop uploadFilesDrop;
  @override
  final Capabilities0_FilesSharing_Sharebymail_Password password;
  @override
  final Capabilities0_FilesSharing_Sharebymail_ExpireDate expireDate;

  factory _$Capabilities0_FilesSharing_Sharebymail(
          [void Function(Capabilities0_FilesSharing_SharebymailBuilder)? updates]) =>
      (Capabilities0_FilesSharing_SharebymailBuilder()..update(updates))._build();

  _$Capabilities0_FilesSharing_Sharebymail._(
      {required this.enabled,
      required this.sendPasswordByMail,
      required this.uploadFilesDrop,
      required this.password,
      required this.expireDate})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities0_FilesSharing_Sharebymail', 'enabled');
    BuiltValueNullFieldError.checkNotNull(
        sendPasswordByMail, r'Capabilities0_FilesSharing_Sharebymail', 'sendPasswordByMail');
    BuiltValueNullFieldError.checkNotNull(
        uploadFilesDrop, r'Capabilities0_FilesSharing_Sharebymail', 'uploadFilesDrop');
    BuiltValueNullFieldError.checkNotNull(password, r'Capabilities0_FilesSharing_Sharebymail', 'password');
    BuiltValueNullFieldError.checkNotNull(expireDate, r'Capabilities0_FilesSharing_Sharebymail', 'expireDate');
  }

  @override
  Capabilities0_FilesSharing_Sharebymail rebuild(
          void Function(Capabilities0_FilesSharing_SharebymailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities0_FilesSharing_SharebymailBuilder toBuilder() =>
      Capabilities0_FilesSharing_SharebymailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0_FilesSharing_Sharebymail &&
        enabled == other.enabled &&
        sendPasswordByMail == other.sendPasswordByMail &&
        uploadFilesDrop == other.uploadFilesDrop &&
        password == other.password &&
        expireDate == other.expireDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, sendPasswordByMail.hashCode);
    _$hash = $jc(_$hash, uploadFilesDrop.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, expireDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0_FilesSharing_Sharebymail')
          ..add('enabled', enabled)
          ..add('sendPasswordByMail', sendPasswordByMail)
          ..add('uploadFilesDrop', uploadFilesDrop)
          ..add('password', password)
          ..add('expireDate', expireDate))
        .toString();
  }
}

class Capabilities0_FilesSharing_SharebymailBuilder
    implements
        Builder<Capabilities0_FilesSharing_Sharebymail, Capabilities0_FilesSharing_SharebymailBuilder>,
        $Capabilities0_FilesSharing_SharebymailInterfaceBuilder {
  _$Capabilities0_FilesSharing_Sharebymail? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(covariant bool? enabled) => _$this._enabled = enabled;

  bool? _sendPasswordByMail;
  bool? get sendPasswordByMail => _$this._sendPasswordByMail;
  set sendPasswordByMail(covariant bool? sendPasswordByMail) => _$this._sendPasswordByMail = sendPasswordByMail;

  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder? _uploadFilesDrop;
  Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder get uploadFilesDrop =>
      _$this._uploadFilesDrop ??= Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder();
  set uploadFilesDrop(covariant Capabilities0_FilesSharing_Sharebymail_UploadFilesDropBuilder? uploadFilesDrop) =>
      _$this._uploadFilesDrop = uploadFilesDrop;

  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder? _password;
  Capabilities0_FilesSharing_Sharebymail_PasswordBuilder get password =>
      _$this._password ??= Capabilities0_FilesSharing_Sharebymail_PasswordBuilder();
  set password(covariant Capabilities0_FilesSharing_Sharebymail_PasswordBuilder? password) =>
      _$this._password = password;

  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder? _expireDate;
  Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder get expireDate =>
      _$this._expireDate ??= Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder();
  set expireDate(covariant Capabilities0_FilesSharing_Sharebymail_ExpireDateBuilder? expireDate) =>
      _$this._expireDate = expireDate;

  Capabilities0_FilesSharing_SharebymailBuilder();

  Capabilities0_FilesSharing_SharebymailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _sendPasswordByMail = $v.sendPasswordByMail;
      _uploadFilesDrop = $v.uploadFilesDrop.toBuilder();
      _password = $v.password.toBuilder();
      _expireDate = $v.expireDate.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0_FilesSharing_Sharebymail other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0_FilesSharing_Sharebymail;
  }

  @override
  void update(void Function(Capabilities0_FilesSharing_SharebymailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0_FilesSharing_Sharebymail build() => _build();

  _$Capabilities0_FilesSharing_Sharebymail _build() {
    _$Capabilities0_FilesSharing_Sharebymail _$result;
    try {
      _$result = _$v ??
          _$Capabilities0_FilesSharing_Sharebymail._(
              enabled:
                  BuiltValueNullFieldError.checkNotNull(enabled, r'Capabilities0_FilesSharing_Sharebymail', 'enabled'),
              sendPasswordByMail: BuiltValueNullFieldError.checkNotNull(
                  sendPasswordByMail, r'Capabilities0_FilesSharing_Sharebymail', 'sendPasswordByMail'),
              uploadFilesDrop: uploadFilesDrop.build(),
              password: password.build(),
              expireDate: expireDate.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'uploadFilesDrop';
        uploadFilesDrop.build();
        _$failedField = 'password';
        password.build();
        _$failedField = 'expireDate';
        expireDate.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities0_FilesSharing_Sharebymail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities0_FilesSharingInterfaceBuilder {
  void replace($Capabilities0_FilesSharingInterface other);
  void update(void Function($Capabilities0_FilesSharingInterfaceBuilder) updates);
  Capabilities0_FilesSharing_SharebymailBuilder get sharebymail;
  set sharebymail(Capabilities0_FilesSharing_SharebymailBuilder? sharebymail);
}

class _$Capabilities0_FilesSharing extends Capabilities0_FilesSharing {
  @override
  final Capabilities0_FilesSharing_Sharebymail sharebymail;

  factory _$Capabilities0_FilesSharing([void Function(Capabilities0_FilesSharingBuilder)? updates]) =>
      (Capabilities0_FilesSharingBuilder()..update(updates))._build();

  _$Capabilities0_FilesSharing._({required this.sharebymail}) : super._() {
    BuiltValueNullFieldError.checkNotNull(sharebymail, r'Capabilities0_FilesSharing', 'sharebymail');
  }

  @override
  Capabilities0_FilesSharing rebuild(void Function(Capabilities0_FilesSharingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  Capabilities0_FilesSharingBuilder toBuilder() => Capabilities0_FilesSharingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0_FilesSharing && sharebymail == other.sharebymail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sharebymail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0_FilesSharing')..add('sharebymail', sharebymail)).toString();
  }
}

class Capabilities0_FilesSharingBuilder
    implements
        Builder<Capabilities0_FilesSharing, Capabilities0_FilesSharingBuilder>,
        $Capabilities0_FilesSharingInterfaceBuilder {
  _$Capabilities0_FilesSharing? _$v;

  Capabilities0_FilesSharing_SharebymailBuilder? _sharebymail;
  Capabilities0_FilesSharing_SharebymailBuilder get sharebymail =>
      _$this._sharebymail ??= Capabilities0_FilesSharing_SharebymailBuilder();
  set sharebymail(covariant Capabilities0_FilesSharing_SharebymailBuilder? sharebymail) =>
      _$this._sharebymail = sharebymail;

  Capabilities0_FilesSharingBuilder();

  Capabilities0_FilesSharingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sharebymail = $v.sharebymail.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0_FilesSharing other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0_FilesSharing;
  }

  @override
  void update(void Function(Capabilities0_FilesSharingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0_FilesSharing build() => _build();

  _$Capabilities0_FilesSharing _build() {
    _$Capabilities0_FilesSharing _$result;
    try {
      _$result = _$v ?? _$Capabilities0_FilesSharing._(sharebymail: sharebymail.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sharebymail';
        sharebymail.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities0_FilesSharing', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

abstract mixin class $Capabilities0InterfaceBuilder {
  void replace($Capabilities0Interface other);
  void update(void Function($Capabilities0InterfaceBuilder) updates);
  Capabilities0_FilesSharingBuilder get filesSharing;
  set filesSharing(Capabilities0_FilesSharingBuilder? filesSharing);
}

class _$Capabilities0 extends Capabilities0 {
  @override
  final Capabilities0_FilesSharing filesSharing;

  factory _$Capabilities0([void Function(Capabilities0Builder)? updates]) =>
      (Capabilities0Builder()..update(updates))._build();

  _$Capabilities0._({required this.filesSharing}) : super._() {
    BuiltValueNullFieldError.checkNotNull(filesSharing, r'Capabilities0', 'filesSharing');
  }

  @override
  Capabilities0 rebuild(void Function(Capabilities0Builder) updates) => (toBuilder()..update(updates)).build();

  @override
  Capabilities0Builder toBuilder() => Capabilities0Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities0 && filesSharing == other.filesSharing;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, filesSharing.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities0')..add('filesSharing', filesSharing)).toString();
  }
}

class Capabilities0Builder implements Builder<Capabilities0, Capabilities0Builder>, $Capabilities0InterfaceBuilder {
  _$Capabilities0? _$v;

  Capabilities0_FilesSharingBuilder? _filesSharing;
  Capabilities0_FilesSharingBuilder get filesSharing => _$this._filesSharing ??= Capabilities0_FilesSharingBuilder();
  set filesSharing(covariant Capabilities0_FilesSharingBuilder? filesSharing) => _$this._filesSharing = filesSharing;

  Capabilities0Builder();

  Capabilities0Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _filesSharing = $v.filesSharing.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant Capabilities0 other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Capabilities0;
  }

  @override
  void update(void Function(Capabilities0Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities0 build() => _build();

  _$Capabilities0 _build() {
    _$Capabilities0 _$result;
    try {
      _$result = _$v ?? _$Capabilities0._(filesSharing: filesSharing.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filesSharing';
        filesSharing.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Capabilities0', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
