// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'update_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateInfoModel _$UpdateInfoModelFromJson(Map<String, dynamic> json) {
  return _UpdateInfoModel.fromJson(json);
}

/// @nodoc
class _$UpdateInfoModelTearOff {
  const _$UpdateInfoModelTearOff();

  _UpdateInfoModel call(
      {@JsonKey(name: 'title') required String title,
      @JsonKey(name: 'description') required String description,
      @JsonKey(name: 'text') required String changeLog,
      @JsonKey(name: 'appVersion') required String serverVersion}) {
    return _UpdateInfoModel(
      title: title,
      description: description,
      changeLog: changeLog,
      serverVersion: serverVersion,
    );
  }

  UpdateInfoModel fromJson(Map<String, Object?> json) {
    return UpdateInfoModel.fromJson(json);
  }
}

/// @nodoc
const $UpdateInfoModel = _$UpdateInfoModelTearOff();

/// @nodoc
mixin _$UpdateInfoModel {
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
  $UpdateInfoModelCopyWith<UpdateInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoModelCopyWith<$Res> {
  factory $UpdateInfoModelCopyWith(
          UpdateInfoModel value, $Res Function(UpdateInfoModel) then) =
      _$UpdateInfoModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'text') String changeLog,
      @JsonKey(name: 'appVersion') String serverVersion});
}

/// @nodoc
class _$UpdateInfoModelCopyWithImpl<$Res>
    implements $UpdateInfoModelCopyWith<$Res> {
  _$UpdateInfoModelCopyWithImpl(this._value, this._then);

  final UpdateInfoModel _value;
  // ignore: unused_field
  final $Res Function(UpdateInfoModel) _then;

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
abstract class _$UpdateInfoModelCopyWith<$Res>
    implements $UpdateInfoModelCopyWith<$Res> {
  factory _$UpdateInfoModelCopyWith(
          _UpdateInfoModel value, $Res Function(_UpdateInfoModel) then) =
      __$UpdateInfoModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'text') String changeLog,
      @JsonKey(name: 'appVersion') String serverVersion});
}

/// @nodoc
class __$UpdateInfoModelCopyWithImpl<$Res>
    extends _$UpdateInfoModelCopyWithImpl<$Res>
    implements _$UpdateInfoModelCopyWith<$Res> {
  __$UpdateInfoModelCopyWithImpl(
      _UpdateInfoModel _value, $Res Function(_UpdateInfoModel) _then)
      : super(_value, (v) => _then(v as _UpdateInfoModel));

  @override
  _UpdateInfoModel get _value => super._value as _UpdateInfoModel;

  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? changeLog = freezed,
    Object? serverVersion = freezed,
  }) {
    return _then(_UpdateInfoModel(
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
class _$_UpdateInfoModel implements _UpdateInfoModel {
  const _$_UpdateInfoModel(
      {@JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'text') required this.changeLog,
      @JsonKey(name: 'appVersion') required this.serverVersion});

  factory _$_UpdateInfoModel.fromJson(Map<String, dynamic> json) =>
      _$$_UpdateInfoModelFromJson(json);

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
    return 'UpdateInfoModel(title: $title, description: $description, changeLog: $changeLog, serverVersion: $serverVersion)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateInfoModel &&
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
  _$UpdateInfoModelCopyWith<_UpdateInfoModel> get copyWith =>
      __$UpdateInfoModelCopyWithImpl<_UpdateInfoModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UpdateInfoModelToJson(this);
  }
}

abstract class _UpdateInfoModel implements UpdateInfoModel {
  const factory _UpdateInfoModel(
          {@JsonKey(name: 'title') required String title,
          @JsonKey(name: 'description') required String description,
          @JsonKey(name: 'text') required String changeLog,
          @JsonKey(name: 'appVersion') required String serverVersion}) =
      _$_UpdateInfoModel;

  factory _UpdateInfoModel.fromJson(Map<String, dynamic> json) =
      _$_UpdateInfoModel.fromJson;

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
  _$UpdateInfoModelCopyWith<_UpdateInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}
