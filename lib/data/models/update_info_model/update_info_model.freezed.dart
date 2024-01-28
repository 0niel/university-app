// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateInfoModel _$UpdateInfoModelFromJson(Map<String, dynamic> json) {
  return _UpdateInfoModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateInfoModel {
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'text')
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'appVersion')
  String get appVersion => throw _privateConstructorUsedError;
  @JsonKey(name: 'buildNumber')
  int get buildNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateInfoModelCopyWith<UpdateInfoModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateInfoModelCopyWith<$Res> {
  factory $UpdateInfoModelCopyWith(UpdateInfoModel value, $Res Function(UpdateInfoModel) then) =
      _$UpdateInfoModelCopyWithImpl<$Res, UpdateInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'text') String text,
      @JsonKey(name: 'appVersion') String appVersion,
      @JsonKey(name: 'buildNumber') int buildNumber});
}

/// @nodoc
class _$UpdateInfoModelCopyWithImpl<$Res, $Val extends UpdateInfoModel> implements $UpdateInfoModelCopyWith<$Res> {
  _$UpdateInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? text = null,
    Object? appVersion = null,
    Object? buildNumber = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateInfoModelImplCopyWith<$Res> implements $UpdateInfoModelCopyWith<$Res> {
  factory _$$UpdateInfoModelImplCopyWith(_$UpdateInfoModelImpl value, $Res Function(_$UpdateInfoModelImpl) then) =
      __$$UpdateInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String title,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'text') String text,
      @JsonKey(name: 'appVersion') String appVersion,
      @JsonKey(name: 'buildNumber') int buildNumber});
}

/// @nodoc
class __$$UpdateInfoModelImplCopyWithImpl<$Res> extends _$UpdateInfoModelCopyWithImpl<$Res, _$UpdateInfoModelImpl>
    implements _$$UpdateInfoModelImplCopyWith<$Res> {
  __$$UpdateInfoModelImplCopyWithImpl(_$UpdateInfoModelImpl _value, $Res Function(_$UpdateInfoModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? text = null,
    Object? appVersion = null,
    Object? buildNumber = null,
  }) {
    return _then(_$UpdateInfoModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateInfoModelImpl implements _UpdateInfoModel {
  const _$UpdateInfoModelImpl(
      {@JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'description') required this.description,
      @JsonKey(name: 'text') required this.text,
      @JsonKey(name: 'appVersion') required this.appVersion,
      @JsonKey(name: 'buildNumber') required this.buildNumber});

  factory _$UpdateInfoModelImpl.fromJson(Map<String, dynamic> json) => _$$UpdateInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'text')
  final String text;
  @override
  @JsonKey(name: 'appVersion')
  final String appVersion;
  @override
  @JsonKey(name: 'buildNumber')
  final int buildNumber;

  @override
  String toString() {
    return 'UpdateInfoModel(title: $title, description: $description, text: $text, appVersion: $appVersion, buildNumber: $buildNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateInfoModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.appVersion, appVersion) || other.appVersion == appVersion) &&
            (identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, text, appVersion, buildNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateInfoModelImplCopyWith<_$UpdateInfoModelImpl> get copyWith =>
      __$$UpdateInfoModelImplCopyWithImpl<_$UpdateInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateInfoModelImplToJson(
      this,
    );
  }
}

abstract class _UpdateInfoModel implements UpdateInfoModel {
  const factory _UpdateInfoModel(
      {@JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'description') required final String? description,
      @JsonKey(name: 'text') required final String text,
      @JsonKey(name: 'appVersion') required final String appVersion,
      @JsonKey(name: 'buildNumber') required final int buildNumber}) = _$UpdateInfoModelImpl;

  factory _UpdateInfoModel.fromJson(Map<String, dynamic> json) = _$UpdateInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'text')
  String get text;
  @override
  @JsonKey(name: 'appVersion')
  String get appVersion;
  @override
  @JsonKey(name: 'buildNumber')
  int get buildNumber;
  @override
  @JsonKey(ignore: true)
  _$$UpdateInfoModelImplCopyWith<_$UpdateInfoModelImpl> get copyWith => throw _privateConstructorUsedError;
}
