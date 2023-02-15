// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_pass_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NfcPassEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String code, String studentId, String deviceId, String deviceName)
        connectNfcPass,
    required TResult Function(String code, String studentId, String deviceId)
        getNfcPasses,
    required TResult Function() fetchNfcCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult? Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult? Function()? fetchNfcCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult Function()? fetchNfcCode,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ConnectNfcPass value) connectNfcPass,
    required TResult Function(_GetNfcPasses value) getNfcPasses,
    required TResult Function(_FetchNfcCode value) fetchNfcCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ConnectNfcPass value)? connectNfcPass,
    TResult? Function(_GetNfcPasses value)? getNfcPasses,
    TResult? Function(_FetchNfcCode value)? fetchNfcCode,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ConnectNfcPass value)? connectNfcPass,
    TResult Function(_GetNfcPasses value)? getNfcPasses,
    TResult Function(_FetchNfcCode value)? fetchNfcCode,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NfcPassEventCopyWith<$Res> {
  factory $NfcPassEventCopyWith(
          NfcPassEvent value, $Res Function(NfcPassEvent) then) =
      _$NfcPassEventCopyWithImpl<$Res, NfcPassEvent>;
}

/// @nodoc
class _$NfcPassEventCopyWithImpl<$Res, $Val extends NfcPassEvent>
    implements $NfcPassEventCopyWith<$Res> {
  _$NfcPassEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_StartedCopyWith<$Res> {
  factory _$$_StartedCopyWith(
          _$_Started value, $Res Function(_$_Started) then) =
      __$$_StartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_StartedCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$_Started>
    implements _$$_StartedCopyWith<$Res> {
  __$$_StartedCopyWithImpl(_$_Started _value, $Res Function(_$_Started) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Started with DiagnosticableTreeMixin implements _Started {
  const _$_Started();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassEvent.started()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassEvent.started'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String code, String studentId, String deviceId, String deviceName)
        connectNfcPass,
    required TResult Function(String code, String studentId, String deviceId)
        getNfcPasses,
    required TResult Function() fetchNfcCode,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult? Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult? Function()? fetchNfcCode,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult Function()? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ConnectNfcPass value) connectNfcPass,
    required TResult Function(_GetNfcPasses value) getNfcPasses,
    required TResult Function(_FetchNfcCode value) fetchNfcCode,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ConnectNfcPass value)? connectNfcPass,
    TResult? Function(_GetNfcPasses value)? getNfcPasses,
    TResult? Function(_FetchNfcCode value)? fetchNfcCode,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ConnectNfcPass value)? connectNfcPass,
    TResult Function(_GetNfcPasses value)? getNfcPasses,
    TResult Function(_FetchNfcCode value)? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements NfcPassEvent {
  const factory _Started() = _$_Started;
}

/// @nodoc
abstract class _$$_ConnectNfcPassCopyWith<$Res> {
  factory _$$_ConnectNfcPassCopyWith(
          _$_ConnectNfcPass value, $Res Function(_$_ConnectNfcPass) then) =
      __$$_ConnectNfcPassCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String code, String studentId, String deviceId, String deviceName});
}

/// @nodoc
class __$$_ConnectNfcPassCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$_ConnectNfcPass>
    implements _$$_ConnectNfcPassCopyWith<$Res> {
  __$$_ConnectNfcPassCopyWithImpl(
      _$_ConnectNfcPass _value, $Res Function(_$_ConnectNfcPass) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? studentId = null,
    Object? deviceId = null,
    Object? deviceName = null,
  }) {
    return _then(_$_ConnectNfcPass(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ConnectNfcPass
    with DiagnosticableTreeMixin
    implements _ConnectNfcPass {
  const _$_ConnectNfcPass(
      this.code, this.studentId, this.deviceId, this.deviceName);

  @override
  final String code;
  @override
  final String studentId;
  @override
  final String deviceId;
  @override
  final String deviceName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassEvent.connectNfcPass(code: $code, studentId: $studentId, deviceId: $deviceId, deviceName: $deviceName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NfcPassEvent.connectNfcPass'))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('studentId', studentId))
      ..add(DiagnosticsProperty('deviceId', deviceId))
      ..add(DiagnosticsProperty('deviceName', deviceName));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectNfcPass &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, code, studentId, deviceId, deviceName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConnectNfcPassCopyWith<_$_ConnectNfcPass> get copyWith =>
      __$$_ConnectNfcPassCopyWithImpl<_$_ConnectNfcPass>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String code, String studentId, String deviceId, String deviceName)
        connectNfcPass,
    required TResult Function(String code, String studentId, String deviceId)
        getNfcPasses,
    required TResult Function() fetchNfcCode,
  }) {
    return connectNfcPass(code, studentId, deviceId, deviceName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult? Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult? Function()? fetchNfcCode,
  }) {
    return connectNfcPass?.call(code, studentId, deviceId, deviceName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult Function()? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (connectNfcPass != null) {
      return connectNfcPass(code, studentId, deviceId, deviceName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ConnectNfcPass value) connectNfcPass,
    required TResult Function(_GetNfcPasses value) getNfcPasses,
    required TResult Function(_FetchNfcCode value) fetchNfcCode,
  }) {
    return connectNfcPass(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ConnectNfcPass value)? connectNfcPass,
    TResult? Function(_GetNfcPasses value)? getNfcPasses,
    TResult? Function(_FetchNfcCode value)? fetchNfcCode,
  }) {
    return connectNfcPass?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ConnectNfcPass value)? connectNfcPass,
    TResult Function(_GetNfcPasses value)? getNfcPasses,
    TResult Function(_FetchNfcCode value)? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (connectNfcPass != null) {
      return connectNfcPass(this);
    }
    return orElse();
  }
}

abstract class _ConnectNfcPass implements NfcPassEvent {
  const factory _ConnectNfcPass(final String code, final String studentId,
      final String deviceId, final String deviceName) = _$_ConnectNfcPass;

  String get code;
  String get studentId;
  String get deviceId;
  String get deviceName;
  @JsonKey(ignore: true)
  _$$_ConnectNfcPassCopyWith<_$_ConnectNfcPass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_GetNfcPassesCopyWith<$Res> {
  factory _$$_GetNfcPassesCopyWith(
          _$_GetNfcPasses value, $Res Function(_$_GetNfcPasses) then) =
      __$$_GetNfcPassesCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String studentId, String deviceId});
}

/// @nodoc
class __$$_GetNfcPassesCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$_GetNfcPasses>
    implements _$$_GetNfcPassesCopyWith<$Res> {
  __$$_GetNfcPassesCopyWithImpl(
      _$_GetNfcPasses _value, $Res Function(_$_GetNfcPasses) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? studentId = null,
    Object? deviceId = null,
  }) {
    return _then(_$_GetNfcPasses(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GetNfcPasses with DiagnosticableTreeMixin implements _GetNfcPasses {
  const _$_GetNfcPasses(this.code, this.studentId, this.deviceId);

  @override
  final String code;
  @override
  final String studentId;
  @override
  final String deviceId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassEvent.getNfcPasses(code: $code, studentId: $studentId, deviceId: $deviceId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NfcPassEvent.getNfcPasses'))
      ..add(DiagnosticsProperty('code', code))
      ..add(DiagnosticsProperty('studentId', studentId))
      ..add(DiagnosticsProperty('deviceId', deviceId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetNfcPasses &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, studentId, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GetNfcPassesCopyWith<_$_GetNfcPasses> get copyWith =>
      __$$_GetNfcPassesCopyWithImpl<_$_GetNfcPasses>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String code, String studentId, String deviceId, String deviceName)
        connectNfcPass,
    required TResult Function(String code, String studentId, String deviceId)
        getNfcPasses,
    required TResult Function() fetchNfcCode,
  }) {
    return getNfcPasses(code, studentId, deviceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult? Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult? Function()? fetchNfcCode,
  }) {
    return getNfcPasses?.call(code, studentId, deviceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult Function()? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (getNfcPasses != null) {
      return getNfcPasses(code, studentId, deviceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ConnectNfcPass value) connectNfcPass,
    required TResult Function(_GetNfcPasses value) getNfcPasses,
    required TResult Function(_FetchNfcCode value) fetchNfcCode,
  }) {
    return getNfcPasses(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ConnectNfcPass value)? connectNfcPass,
    TResult? Function(_GetNfcPasses value)? getNfcPasses,
    TResult? Function(_FetchNfcCode value)? fetchNfcCode,
  }) {
    return getNfcPasses?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ConnectNfcPass value)? connectNfcPass,
    TResult Function(_GetNfcPasses value)? getNfcPasses,
    TResult Function(_FetchNfcCode value)? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (getNfcPasses != null) {
      return getNfcPasses(this);
    }
    return orElse();
  }
}

abstract class _GetNfcPasses implements NfcPassEvent {
  const factory _GetNfcPasses(
          final String code, final String studentId, final String deviceId) =
      _$_GetNfcPasses;

  String get code;
  String get studentId;
  String get deviceId;
  @JsonKey(ignore: true)
  _$$_GetNfcPassesCopyWith<_$_GetNfcPasses> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_FetchNfcCodeCopyWith<$Res> {
  factory _$$_FetchNfcCodeCopyWith(
          _$_FetchNfcCode value, $Res Function(_$_FetchNfcCode) then) =
      __$$_FetchNfcCodeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_FetchNfcCodeCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$_FetchNfcCode>
    implements _$$_FetchNfcCodeCopyWith<$Res> {
  __$$_FetchNfcCodeCopyWithImpl(
      _$_FetchNfcCode _value, $Res Function(_$_FetchNfcCode) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_FetchNfcCode with DiagnosticableTreeMixin implements _FetchNfcCode {
  const _$_FetchNfcCode();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassEvent.fetchNfcCode()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassEvent.fetchNfcCode'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_FetchNfcCode);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String code, String studentId, String deviceId, String deviceName)
        connectNfcPass,
    required TResult Function(String code, String studentId, String deviceId)
        getNfcPasses,
    required TResult Function() fetchNfcCode,
  }) {
    return fetchNfcCode();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult? Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult? Function()? fetchNfcCode,
  }) {
    return fetchNfcCode?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String code, String studentId, String deviceId, String deviceName)?
        connectNfcPass,
    TResult Function(String code, String studentId, String deviceId)?
        getNfcPasses,
    TResult Function()? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (fetchNfcCode != null) {
      return fetchNfcCode();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_ConnectNfcPass value) connectNfcPass,
    required TResult Function(_GetNfcPasses value) getNfcPasses,
    required TResult Function(_FetchNfcCode value) fetchNfcCode,
  }) {
    return fetchNfcCode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_ConnectNfcPass value)? connectNfcPass,
    TResult? Function(_GetNfcPasses value)? getNfcPasses,
    TResult? Function(_FetchNfcCode value)? fetchNfcCode,
  }) {
    return fetchNfcCode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_ConnectNfcPass value)? connectNfcPass,
    TResult Function(_GetNfcPasses value)? getNfcPasses,
    TResult Function(_FetchNfcCode value)? fetchNfcCode,
    required TResult orElse(),
  }) {
    if (fetchNfcCode != null) {
      return fetchNfcCode(this);
    }
    return orElse();
  }
}

abstract class _FetchNfcCode implements NfcPassEvent {
  const factory _FetchNfcCode() = _$_FetchNfcCode;
}

/// @nodoc
mixin _$NfcPassState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NfcPassStateCopyWith<$Res> {
  factory $NfcPassStateCopyWith(
          NfcPassState value, $Res Function(NfcPassState) then) =
      _$NfcPassStateCopyWithImpl<$Res, NfcPassState>;
}

/// @nodoc
class _$NfcPassStateCopyWithImpl<$Res, $Val extends NfcPassState>
    implements $NfcPassStateCopyWith<$Res> {
  _$NfcPassStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Initial with DiagnosticableTreeMixin implements _Initial {
  const _$_Initial();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassState.initial'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements NfcPassState {
  const factory _Initial() = _$_Initial;
}

/// @nodoc
abstract class _$$_LoadingCopyWith<$Res> {
  factory _$$_LoadingCopyWith(
          _$_Loading value, $Res Function(_$_Loading) then) =
      __$$_LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LoadingCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_Loading>
    implements _$$_LoadingCopyWith<$Res> {
  __$$_LoadingCopyWithImpl(_$_Loading _value, $Res Function(_$_Loading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Loading with DiagnosticableTreeMixin implements _Loading {
  const _$_Loading();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassState.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements NfcPassState {
  const factory _Loading() = _$_Loading;
}

/// @nodoc
abstract class _$$_LoadedCopyWith<$Res> {
  factory _$$_LoadedCopyWith(_$_Loaded value, $Res Function(_$_Loaded) then) =
      __$$_LoadedCopyWithImpl<$Res>;
  @useResult
  $Res call({List<NfcPass> nfcPasses});
}

/// @nodoc
class __$$_LoadedCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_Loaded>
    implements _$$_LoadedCopyWith<$Res> {
  __$$_LoadedCopyWithImpl(_$_Loaded _value, $Res Function(_$_Loaded) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nfcPasses = null,
  }) {
    return _then(_$_Loaded(
      null == nfcPasses
          ? _value._nfcPasses
          : nfcPasses // ignore: cast_nullable_to_non_nullable
              as List<NfcPass>,
    ));
  }
}

/// @nodoc

class _$_Loaded with DiagnosticableTreeMixin implements _Loaded {
  const _$_Loaded(final List<NfcPass> nfcPasses) : _nfcPasses = nfcPasses;

  final List<NfcPass> _nfcPasses;
  @override
  List<NfcPass> get nfcPasses {
    if (_nfcPasses is EqualUnmodifiableListView) return _nfcPasses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nfcPasses);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.loaded(nfcPasses: $nfcPasses)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NfcPassState.loaded'))
      ..add(DiagnosticsProperty('nfcPasses', nfcPasses));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Loaded &&
            const DeepCollectionEquality()
                .equals(other._nfcPasses, _nfcPasses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_nfcPasses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoadedCopyWith<_$_Loaded> get copyWith =>
      __$$_LoadedCopyWithImpl<_$_Loaded>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return loaded(nfcPasses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return loaded?.call(nfcPasses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(nfcPasses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements NfcPassState {
  const factory _Loaded(final List<NfcPass> nfcPasses) = _$_Loaded;

  List<NfcPass> get nfcPasses;
  @JsonKey(ignore: true)
  _$$_LoadedCopyWith<_$_Loaded> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_NfcNotExistCopyWith<$Res> {
  factory _$$_NfcNotExistCopyWith(
          _$_NfcNotExist value, $Res Function(_$_NfcNotExist) then) =
      __$$_NfcNotExistCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NfcNotExistCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_NfcNotExist>
    implements _$$_NfcNotExistCopyWith<$Res> {
  __$$_NfcNotExistCopyWithImpl(
      _$_NfcNotExist _value, $Res Function(_$_NfcNotExist) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NfcNotExist with DiagnosticableTreeMixin implements _NfcNotExist {
  const _$_NfcNotExist();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.nfcNotExist()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassState.nfcNotExist'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_NfcNotExist);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return nfcNotExist();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return nfcNotExist?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcNotExist != null) {
      return nfcNotExist();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return nfcNotExist(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return nfcNotExist?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcNotExist != null) {
      return nfcNotExist(this);
    }
    return orElse();
  }
}

abstract class _NfcNotExist implements NfcPassState {
  const factory _NfcNotExist() = _$_NfcNotExist;
}

/// @nodoc
abstract class _$$_ErrorCopyWith<$Res> {
  factory _$$_ErrorCopyWith(_$_Error value, $Res Function(_$_Error) then) =
      __$$_ErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({String cause});
}

/// @nodoc
class __$$_ErrorCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_Error>
    implements _$$_ErrorCopyWith<$Res> {
  __$$_ErrorCopyWithImpl(_$_Error _value, $Res Function(_$_Error) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cause = null,
  }) {
    return _then(_$_Error(
      null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Error with DiagnosticableTreeMixin implements _Error {
  const _$_Error(this.cause);

  @override
  final String cause;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.error(cause: $cause)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NfcPassState.error'))
      ..add(DiagnosticsProperty('cause', cause));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Error &&
            (identical(other.cause, cause) || other.cause == cause));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cause);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ErrorCopyWith<_$_Error> get copyWith =>
      __$$_ErrorCopyWithImpl<_$_Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return error(cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return error?.call(cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements NfcPassState {
  const factory _Error(final String cause) = _$_Error;

  String get cause;
  @JsonKey(ignore: true)
  _$$_ErrorCopyWith<_$_Error> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_NfcDisabledCopyWith<$Res> {
  factory _$$_NfcDisabledCopyWith(
          _$_NfcDisabled value, $Res Function(_$_NfcDisabled) then) =
      __$$_NfcDisabledCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NfcDisabledCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_NfcDisabled>
    implements _$$_NfcDisabledCopyWith<$Res> {
  __$$_NfcDisabledCopyWithImpl(
      _$_NfcDisabled _value, $Res Function(_$_NfcDisabled) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NfcDisabled with DiagnosticableTreeMixin implements _NfcDisabled {
  const _$_NfcDisabled();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.nfcDisabled()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassState.nfcDisabled'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_NfcDisabled);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return nfcDisabled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return nfcDisabled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcDisabled != null) {
      return nfcDisabled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return nfcDisabled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return nfcDisabled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcDisabled != null) {
      return nfcDisabled(this);
    }
    return orElse();
  }
}

abstract class _NfcDisabled implements NfcPassState {
  const factory _NfcDisabled() = _$_NfcDisabled;
}

/// @nodoc
abstract class _$$_NfcNotSupportedCopyWith<$Res> {
  factory _$$_NfcNotSupportedCopyWith(
          _$_NfcNotSupported value, $Res Function(_$_NfcNotSupported) then) =
      __$$_NfcNotSupportedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NfcNotSupportedCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$_NfcNotSupported>
    implements _$$_NfcNotSupportedCopyWith<$Res> {
  __$$_NfcNotSupportedCopyWithImpl(
      _$_NfcNotSupported _value, $Res Function(_$_NfcNotSupported) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NfcNotSupported
    with DiagnosticableTreeMixin
    implements _NfcNotSupported {
  const _$_NfcNotSupported();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NfcPassState.nfcNotSupported()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'NfcPassState.nfcNotSupported'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_NfcNotSupported);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<NfcPass> nfcPasses) loaded,
    required TResult Function() nfcNotExist,
    required TResult Function(String cause) error,
    required TResult Function() nfcDisabled,
    required TResult Function() nfcNotSupported,
  }) {
    return nfcNotSupported();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<NfcPass> nfcPasses)? loaded,
    TResult? Function()? nfcNotExist,
    TResult? Function(String cause)? error,
    TResult? Function()? nfcDisabled,
    TResult? Function()? nfcNotSupported,
  }) {
    return nfcNotSupported?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<NfcPass> nfcPasses)? loaded,
    TResult Function()? nfcNotExist,
    TResult Function(String cause)? error,
    TResult Function()? nfcDisabled,
    TResult Function()? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcNotSupported != null) {
      return nfcNotSupported();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_NfcNotExist value) nfcNotExist,
    required TResult Function(_Error value) error,
    required TResult Function(_NfcDisabled value) nfcDisabled,
    required TResult Function(_NfcNotSupported value) nfcNotSupported,
  }) {
    return nfcNotSupported(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_NfcNotExist value)? nfcNotExist,
    TResult? Function(_Error value)? error,
    TResult? Function(_NfcDisabled value)? nfcDisabled,
    TResult? Function(_NfcNotSupported value)? nfcNotSupported,
  }) {
    return nfcNotSupported?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_NfcNotExist value)? nfcNotExist,
    TResult Function(_Error value)? error,
    TResult Function(_NfcDisabled value)? nfcDisabled,
    TResult Function(_NfcNotSupported value)? nfcNotSupported,
    required TResult orElse(),
  }) {
    if (nfcNotSupported != null) {
      return nfcNotSupported(this);
    }
    return orElse();
  }
}

abstract class _NfcNotSupported implements NfcPassState {
  const factory _NfcNotSupported() = _$_NfcNotSupported;
}
