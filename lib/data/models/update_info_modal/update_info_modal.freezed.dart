// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'update_info_modal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateInfoModal _$UpdateInfoModalFromJson(Map<String, dynamic> json) {
  return _UpdateInfoModal.fromJson(json);
}

/// @nodoc
class _$UpdateInfoModalTearOff {
  const _$UpdateInfoModalTearOff();

  _UpdateInfoModal call(
      {@JsonKey(name: 'title') required String title,
      @JsonKey(name: 'description') required String description,
      @JsonKey(name: 'text') required String changeLog,
      @JsonKey(name: 'appVersion') required String serverVersion}) {
    return _UpdateInfoModal(
      title: title,
      description: description,
      changeLog: changeLog,
      serverVersion: serverVersion,
    );
  }

  UpdateInfoModal fromJson(Map<String, Object?> json) {
    return UpdateInfoModal.fromJson(json);
  }
}

/// @nodoc
const $UpdateInfoModal = _$UpdateInfoModalTearOff();

/// @nodoc
mixin _$UpdateInfoModal {
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'text')
  String get changeLog => throw _privateConstructorUsedError;
  @JsonKey(name: 'appVersion')
  String get serverVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateInfoModalCopyWith<UpdateInfoModal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoModalCopyWith<$Res> {
  factory $UpdateInfoModalCopyWith(
          UpdateInfoModal value, $Res Function(UpdateInfoModal) then) =
      _$UpdateInfoModalCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'text') String changeLog,
      @JsonKey(name: 'appVersion') String serverVersion});
}

/// @nodoc
class _$UpdateInfoModalCopyWithImpl<$Res>
    implements $UpdateInfoModalCopyWith<$Res> {
  _$UpdateInfoModalCopyWithImpl(this._value, this._then);

  final UpdateInfoModal _value;
  // ignore: unused_field
  final $Res Function(UpdateInfoModal) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? changeLog = freezed,
    Object? serverVersion = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      changeLog: changeLog == freezed
          ? _value.changeLog
          : changeLog // ignore: cast_nullable_to_non_nullable
              as String,
      serverVersion: serverVersion == freezed
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$UpdateInfoModalCopyWith<$Res>
    implements $UpdateInfoModalCopyWith<$Res> {
  factory _$UpdateInfoModalCopyWith(
          _UpdateInfoModal value, $Res Function(_UpdateInfoModal) then) =
      __$UpdateInfoModalCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'text') String changeLog,
      @JsonKey(name: 'appVersion') String serverVersion});
}

/// @nodoc
class __$UpdateInfoModalCopyWithImpl<$Res>
    extends _$UpdateInfoModalCopyWithImpl<$Res>
    implements _$UpdateInfoModalCopyWith<$Res> {
  __$UpdateInfoModalCopyWithImpl(
      _UpdateInfoModal _value, $Res Function(_UpdateInfoModal) _then)
      : super(_value, (v) => _then(v as _UpdateInfoModal));

  @override
  _UpdateInfoModal get _value => super._value as _UpdateInfoModal;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? changeLog = freezed,
    Object? serverVersion = freezed,
  }) {
    return _then(_UpdateInfoModal(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      changeLog: changeLog == freezed
          ? _value.changeLog
          : changeLog // ignore: cast_nullable_to_non_nullable
              as String,
      serverVersion: serverVersion == freezed
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UpdateInfoModal implements _UpdateInfoModal {
  const _$_UpdateInfoModal(
      {@JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'text') required this.changeLog,
      @JsonKey(name: 'appVersion') required this.serverVersion});

  factory _$_UpdateInfoModal.fromJson(Map<String, dynamic> json) =>
      _$$_UpdateInfoModalFromJson(json);

  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'text')
  final String changeLog;
  @override
  @JsonKey(name: 'appVersion')
  final String serverVersion;

  @override
  String toString() {
    return 'UpdateInfoModal(title: $title, description: $description, changeLog: $changeLog, serverVersion: $serverVersion)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateInfoModal &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.changeLog, changeLog) &&
            const DeepCollectionEquality()
                .equals(other.serverVersion, serverVersion));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(changeLog),
      const DeepCollectionEquality().hash(serverVersion));

  @JsonKey(ignore: true)
  @override
  _$UpdateInfoModalCopyWith<_UpdateInfoModal> get copyWith =>
      __$UpdateInfoModalCopyWithImpl<_UpdateInfoModal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UpdateInfoModalToJson(this);
  }
}

abstract class _UpdateInfoModal implements UpdateInfoModal {
  const factory _UpdateInfoModal(
          {@JsonKey(name: 'title') required String title,
          @JsonKey(name: 'description') required String description,
          @JsonKey(name: 'text') required String changeLog,
          @JsonKey(name: 'appVersion') required String serverVersion}) =
      _$_UpdateInfoModal;

  factory _UpdateInfoModal.fromJson(Map<String, dynamic> json) =
      _$_UpdateInfoModal.fromJson;

  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'text')
  String get changeLog;
  @override
  @JsonKey(name: 'appVersion')
  String get serverVersion;
  @override
  @JsonKey(ignore: true)
  _$UpdateInfoModalCopyWith<_UpdateInfoModal> get copyWith =>
      throw _privateConstructorUsedError;
}
