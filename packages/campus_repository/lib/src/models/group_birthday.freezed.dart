// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_birthday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupBirthday {

@JsonKey(defaultValue: '') String get name;@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime get date; bool get isMe;
/// Create a copy of GroupBirthday
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupBirthdayCopyWith<GroupBirthday> get copyWith => _$GroupBirthdayCopyWithImpl<GroupBirthday>(this as GroupBirthday, _$identity);

  /// Serializes this GroupBirthday to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupBirthday&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,date,isMe);

@override
String toString() {
  return 'GroupBirthday(name: $name, date: $date, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class $GroupBirthdayCopyWith<$Res>  {
  factory $GroupBirthdayCopyWith(GroupBirthday value, $Res Function(GroupBirthday) _then) = _$GroupBirthdayCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String name,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime date, bool isMe
});




}
/// @nodoc
class _$GroupBirthdayCopyWithImpl<$Res>
    implements $GroupBirthdayCopyWith<$Res> {
  _$GroupBirthdayCopyWithImpl(this._self, this._then);

  final GroupBirthday _self;
  final $Res Function(GroupBirthday) _then;

/// Create a copy of GroupBirthday
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? date = null,Object? isMe = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupBirthday].
extension GroupBirthdayPatterns on GroupBirthday {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupBirthday value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupBirthday() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupBirthday value)  $default,){
final _that = this;
switch (_that) {
case _GroupBirthday():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupBirthday value)?  $default,){
final _that = this;
switch (_that) {
case _GroupBirthday() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String name, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime date,  bool isMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupBirthday() when $default != null:
return $default(_that.name,_that.date,_that.isMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String name, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime date,  bool isMe)  $default,) {final _that = this;
switch (_that) {
case _GroupBirthday():
return $default(_that.name,_that.date,_that.isMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String name, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime date,  bool isMe)?  $default,) {final _that = this;
switch (_that) {
case _GroupBirthday() when $default != null:
return $default(_that.name,_that.date,_that.isMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupBirthday extends GroupBirthday {
  const _GroupBirthday({@JsonKey(defaultValue: '') required this.name, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) required this.date, this.isMe = false}): super._();
  factory _GroupBirthday.fromJson(Map<String, dynamic> json) => _$GroupBirthdayFromJson(json);

@override@JsonKey(defaultValue: '') final  String name;
@override@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) final  DateTime date;
@override@JsonKey() final  bool isMe;

/// Create a copy of GroupBirthday
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupBirthdayCopyWith<_GroupBirthday> get copyWith => __$GroupBirthdayCopyWithImpl<_GroupBirthday>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupBirthdayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupBirthday&&(identical(other.name, name) || other.name == name)&&(identical(other.date, date) || other.date == date)&&(identical(other.isMe, isMe) || other.isMe == isMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,date,isMe);

@override
String toString() {
  return 'GroupBirthday(name: $name, date: $date, isMe: $isMe)';
}


}

/// @nodoc
abstract mixin class _$GroupBirthdayCopyWith<$Res> implements $GroupBirthdayCopyWith<$Res> {
  factory _$GroupBirthdayCopyWith(_GroupBirthday value, $Res Function(_GroupBirthday) _then) = __$GroupBirthdayCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String name,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime date, bool isMe
});




}
/// @nodoc
class __$GroupBirthdayCopyWithImpl<$Res>
    implements _$GroupBirthdayCopyWith<$Res> {
  __$GroupBirthdayCopyWithImpl(this._self, this._then);

  final _GroupBirthday _self;
  final $Res Function(_GroupBirthday) _then;

/// Create a copy of GroupBirthday
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? date = null,Object? isMe = null,}) {
  return _then(_GroupBirthday(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
