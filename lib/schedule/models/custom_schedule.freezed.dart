// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomSchedule {

 String get id; String get name; List<CustomLesson> get lessons; String? get description; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of CustomSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomScheduleCopyWith<CustomSchedule> get copyWith => _$CustomScheduleCopyWithImpl<CustomSchedule>(this as CustomSchedule, _$identity);

  /// Serializes this CustomSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.lessons, lessons)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(lessons),description,createdAt,updatedAt);

@override
String toString() {
  return 'CustomSchedule(id: $id, name: $name, lessons: $lessons, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomScheduleCopyWith<$Res>  {
  factory $CustomScheduleCopyWith(CustomSchedule value, $Res Function(CustomSchedule) _then) = _$CustomScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<CustomLesson> lessons, String? description, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CustomScheduleCopyWithImpl<$Res>
    implements $CustomScheduleCopyWith<$Res> {
  _$CustomScheduleCopyWithImpl(this._self, this._then);

  final CustomSchedule _self;
  final $Res Function(CustomSchedule) _then;

/// Create a copy of CustomSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lessons = null,Object? description = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self.lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<CustomLesson>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomSchedule].
extension CustomSchedulePatterns on CustomSchedule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomSchedule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomSchedule value)  $default,){
final _that = this;
switch (_that) {
case _CustomSchedule():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _CustomSchedule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<CustomLesson> lessons,  String? description,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomSchedule() when $default != null:
return $default(_that.id,_that.name,_that.lessons,_that.description,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<CustomLesson> lessons,  String? description,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomSchedule():
return $default(_that.id,_that.name,_that.lessons,_that.description,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<CustomLesson> lessons,  String? description,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomSchedule() when $default != null:
return $default(_that.id,_that.name,_that.lessons,_that.description,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomSchedule extends CustomSchedule {
  const _CustomSchedule({required this.id, required this.name, required final  List<CustomLesson> lessons, this.description, this.createdAt, this.updatedAt}): _lessons = lessons,super._();
  factory _CustomSchedule.fromJson(Map<String, dynamic> json) => _$CustomScheduleFromJson(json);

@override final  String id;
@override final  String name;
 final  List<CustomLesson> _lessons;
@override List<CustomLesson> get lessons {
  if (_lessons is EqualUnmodifiableListView) return _lessons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessons);
}

@override final  String? description;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CustomSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomScheduleCopyWith<_CustomSchedule> get copyWith => __$CustomScheduleCopyWithImpl<_CustomSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._lessons, _lessons)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_lessons),description,createdAt,updatedAt);

@override
String toString() {
  return 'CustomSchedule(id: $id, name: $name, lessons: $lessons, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomScheduleCopyWith<$Res> implements $CustomScheduleCopyWith<$Res> {
  factory _$CustomScheduleCopyWith(_CustomSchedule value, $Res Function(_CustomSchedule) _then) = __$CustomScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<CustomLesson> lessons, String? description, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CustomScheduleCopyWithImpl<$Res>
    implements _$CustomScheduleCopyWith<$Res> {
  __$CustomScheduleCopyWithImpl(this._self, this._then);

  final _CustomSchedule _self;
  final $Res Function(_CustomSchedule) _then;

/// Create a copy of CustomSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lessons = null,Object? description = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CustomSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lessons: null == lessons ? _self._lessons : lessons // ignore: cast_nullable_to_non_nullable
as List<CustomLesson>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
