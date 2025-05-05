// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomSchedule _$CustomScheduleFromJson(Map<String, dynamic> json) {
  return _CustomSchedule.fromJson(json);
}

/// @nodoc
mixin _$CustomSchedule {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<LessonSchedulePart> get lessons => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CustomSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomScheduleCopyWith<CustomSchedule> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomScheduleCopyWith<$Res> {
  factory $CustomScheduleCopyWith(CustomSchedule value, $Res Function(CustomSchedule) then) =
      _$CustomScheduleCopyWithImpl<$Res, CustomSchedule>;
  @useResult
  $Res call({
    String id,
    String name,
    List<LessonSchedulePart> lessons,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CustomScheduleCopyWithImpl<$Res, $Val extends CustomSchedule> implements $CustomScheduleCopyWith<$Res> {
  _$CustomScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lessons = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            lessons:
                null == lessons
                    ? _value.lessons
                    : lessons // ignore: cast_nullable_to_non_nullable
                        as List<LessonSchedulePart>,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomScheduleImplCopyWith<$Res> implements $CustomScheduleCopyWith<$Res> {
  factory _$$CustomScheduleImplCopyWith(_$CustomScheduleImpl value, $Res Function(_$CustomScheduleImpl) then) =
      __$$CustomScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<LessonSchedulePart> lessons,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CustomScheduleImplCopyWithImpl<$Res> extends _$CustomScheduleCopyWithImpl<$Res, _$CustomScheduleImpl>
    implements _$$CustomScheduleImplCopyWith<$Res> {
  __$$CustomScheduleImplCopyWithImpl(_$CustomScheduleImpl _value, $Res Function(_$CustomScheduleImpl) _then)
    : super(_value, _then);

  /// Create a copy of CustomSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? lessons = null,
    Object? description = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CustomScheduleImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        lessons:
            null == lessons
                ? _value._lessons
                : lessons // ignore: cast_nullable_to_non_nullable
                    as List<LessonSchedulePart>,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomScheduleImpl implements _CustomSchedule {
  const _$CustomScheduleImpl({
    required this.id,
    required this.name,
    required final List<LessonSchedulePart> lessons,
    this.description,
    this.createdAt,
    this.updatedAt,
  }) : _lessons = lessons;

  factory _$CustomScheduleImpl.fromJson(Map<String, dynamic> json) => _$$CustomScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<LessonSchedulePart> _lessons;
  @override
  List<LessonSchedulePart> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  final String? description;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'CustomSchedule(id: $id, name: $name, lessons: $lessons, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_lessons),
    description,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CustomSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomScheduleImplCopyWith<_$CustomScheduleImpl> get copyWith =>
      __$$CustomScheduleImplCopyWithImpl<_$CustomScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomScheduleImplToJson(this);
  }
}

abstract class _CustomSchedule implements CustomSchedule {
  const factory _CustomSchedule({
    required final String id,
    required final String name,
    required final List<LessonSchedulePart> lessons,
    final String? description,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CustomScheduleImpl;

  factory _CustomSchedule.fromJson(Map<String, dynamic> json) = _$CustomScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<LessonSchedulePart> get lessons;
  @override
  String? get description;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of CustomSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomScheduleImplCopyWith<_$CustomScheduleImpl> get copyWith => throw _privateConstructorUsedError;
}
