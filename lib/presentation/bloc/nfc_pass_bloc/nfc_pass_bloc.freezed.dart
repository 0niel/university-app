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
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$StartedImpl with DiagnosticableTreeMixin implements _Started {
  const _$StartedImpl();

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
        (other.runtimeType == runtimeType && other is _$StartedImpl);
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
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$ConnectNfcPassImplCopyWith<$Res> {
  factory _$$ConnectNfcPassImplCopyWith(_$ConnectNfcPassImpl value,
          $Res Function(_$ConnectNfcPassImpl) then) =
      __$$ConnectNfcPassImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String code, String studentId, String deviceId, String deviceName});
}

/// @nodoc
class __$$ConnectNfcPassImplCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$ConnectNfcPassImpl>
    implements _$$ConnectNfcPassImplCopyWith<$Res> {
  __$$ConnectNfcPassImplCopyWithImpl(
      _$ConnectNfcPassImpl _value, $Res Function(_$ConnectNfcPassImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? studentId = null,
    Object? deviceId = null,
    Object? deviceName = null,
  }) {
    return _then(_$ConnectNfcPassImpl(
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

class _$ConnectNfcPassImpl
    with DiagnosticableTreeMixin
    implements _ConnectNfcPass {
  const _$ConnectNfcPassImpl(
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
            other is _$ConnectNfcPassImpl &&
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
  _$$ConnectNfcPassImplCopyWith<_$ConnectNfcPassImpl> get copyWith =>
      __$$ConnectNfcPassImplCopyWithImpl<_$ConnectNfcPassImpl>(
          this, _$identity);

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
      final String deviceId, final String deviceName) = _$ConnectNfcPassImpl;

  String get code;
  String get studentId;
  String get deviceId;
  String get deviceName;
  @JsonKey(ignore: true)
  _$$ConnectNfcPassImplCopyWith<_$ConnectNfcPassImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetNfcPassesImplCopyWith<$Res> {
  factory _$$GetNfcPassesImplCopyWith(
          _$GetNfcPassesImpl value, $Res Function(_$GetNfcPassesImpl) then) =
      __$$GetNfcPassesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String studentId, String deviceId});
}

/// @nodoc
class __$$GetNfcPassesImplCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$GetNfcPassesImpl>
    implements _$$GetNfcPassesImplCopyWith<$Res> {
  __$$GetNfcPassesImplCopyWithImpl(
      _$GetNfcPassesImpl _value, $Res Function(_$GetNfcPassesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? studentId = null,
    Object? deviceId = null,
  }) {
    return _then(_$GetNfcPassesImpl(
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

class _$GetNfcPassesImpl with DiagnosticableTreeMixin implements _GetNfcPasses {
  const _$GetNfcPassesImpl(this.code, this.studentId, this.deviceId);

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
            other is _$GetNfcPassesImpl &&
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
  _$$GetNfcPassesImplCopyWith<_$GetNfcPassesImpl> get copyWith =>
      __$$GetNfcPassesImplCopyWithImpl<_$GetNfcPassesImpl>(this, _$identity);

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
      _$GetNfcPassesImpl;

  String get code;
  String get studentId;
  String get deviceId;
  @JsonKey(ignore: true)
  _$$GetNfcPassesImplCopyWith<_$GetNfcPassesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FetchNfcCodeImplCopyWith<$Res> {
  factory _$$FetchNfcCodeImplCopyWith(
          _$FetchNfcCodeImpl value, $Res Function(_$FetchNfcCodeImpl) then) =
      __$$FetchNfcCodeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchNfcCodeImplCopyWithImpl<$Res>
    extends _$NfcPassEventCopyWithImpl<$Res, _$FetchNfcCodeImpl>
    implements _$$FetchNfcCodeImplCopyWith<$Res> {
  __$$FetchNfcCodeImplCopyWithImpl(
      _$FetchNfcCodeImpl _value, $Res Function(_$FetchNfcCodeImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FetchNfcCodeImpl with DiagnosticableTreeMixin implements _FetchNfcCode {
  const _$FetchNfcCodeImpl();

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
        (other.runtimeType == runtimeType && other is _$FetchNfcCodeImpl);
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
  const factory _FetchNfcCode() = _$FetchNfcCodeImpl;
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
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl with DiagnosticableTreeMixin implements _Initial {
  const _$InitialImpl();

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
        (other.runtimeType == runtimeType && other is _$InitialImpl);
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
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl with DiagnosticableTreeMixin implements _Loading {
  const _$LoadingImpl();

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
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
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
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<NfcPass> nfcPasses});
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nfcPasses = null,
  }) {
    return _then(_$LoadedImpl(
      null == nfcPasses
          ? _value._nfcPasses
          : nfcPasses // ignore: cast_nullable_to_non_nullable
              as List<NfcPass>,
    ));
  }
}

/// @nodoc

class _$LoadedImpl with DiagnosticableTreeMixin implements _Loaded {
  const _$LoadedImpl(final List<NfcPass> nfcPasses) : _nfcPasses = nfcPasses;

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
            other is _$LoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._nfcPasses, _nfcPasses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_nfcPasses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

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
  const factory _Loaded(final List<NfcPass> nfcPasses) = _$LoadedImpl;

  List<NfcPass> get nfcPasses;
  @JsonKey(ignore: true)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NfcNotExistImplCopyWith<$Res> {
  factory _$$NfcNotExistImplCopyWith(
          _$NfcNotExistImpl value, $Res Function(_$NfcNotExistImpl) then) =
      __$$NfcNotExistImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NfcNotExistImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$NfcNotExistImpl>
    implements _$$NfcNotExistImplCopyWith<$Res> {
  __$$NfcNotExistImplCopyWithImpl(
      _$NfcNotExistImpl _value, $Res Function(_$NfcNotExistImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NfcNotExistImpl with DiagnosticableTreeMixin implements _NfcNotExist {
  const _$NfcNotExistImpl();

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
        (other.runtimeType == runtimeType && other is _$NfcNotExistImpl);
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
  const factory _NfcNotExist() = _$NfcNotExistImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String cause});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cause = null,
  }) {
    return _then(_$ErrorImpl(
      null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl with DiagnosticableTreeMixin implements _Error {
  const _$ErrorImpl(this.cause);

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
            other is _$ErrorImpl &&
            (identical(other.cause, cause) || other.cause == cause));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cause);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

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
  const factory _Error(final String cause) = _$ErrorImpl;

  String get cause;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NfcDisabledImplCopyWith<$Res> {
  factory _$$NfcDisabledImplCopyWith(
          _$NfcDisabledImpl value, $Res Function(_$NfcDisabledImpl) then) =
      __$$NfcDisabledImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NfcDisabledImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$NfcDisabledImpl>
    implements _$$NfcDisabledImplCopyWith<$Res> {
  __$$NfcDisabledImplCopyWithImpl(
      _$NfcDisabledImpl _value, $Res Function(_$NfcDisabledImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NfcDisabledImpl with DiagnosticableTreeMixin implements _NfcDisabled {
  const _$NfcDisabledImpl();

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
        (other.runtimeType == runtimeType && other is _$NfcDisabledImpl);
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
  const factory _NfcDisabled() = _$NfcDisabledImpl;
}

/// @nodoc
abstract class _$$NfcNotSupportedImplCopyWith<$Res> {
  factory _$$NfcNotSupportedImplCopyWith(_$NfcNotSupportedImpl value,
          $Res Function(_$NfcNotSupportedImpl) then) =
      __$$NfcNotSupportedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NfcNotSupportedImplCopyWithImpl<$Res>
    extends _$NfcPassStateCopyWithImpl<$Res, _$NfcNotSupportedImpl>
    implements _$$NfcNotSupportedImplCopyWith<$Res> {
  __$$NfcNotSupportedImplCopyWithImpl(
      _$NfcNotSupportedImpl _value, $Res Function(_$NfcNotSupportedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NfcNotSupportedImpl
    with DiagnosticableTreeMixin
    implements _NfcNotSupported {
  const _$NfcNotSupportedImpl();

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
        (other.runtimeType == runtimeType && other is _$NfcNotSupportedImpl);
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
  const factory _NfcNotSupported() = _$NfcNotSupportedImpl;
}
