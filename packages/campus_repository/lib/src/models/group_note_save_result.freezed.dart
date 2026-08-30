// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_note_save_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupNoteSaveResult {

 int get revision;@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime get updatedAt;
/// Create a copy of GroupNoteSaveResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupNoteSaveResultCopyWith<GroupNoteSaveResult> get copyWith => _$GroupNoteSaveResultCopyWithImpl<GroupNoteSaveResult>(this as GroupNoteSaveResult, _$identity);

  /// Serializes this GroupNoteSaveResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupNoteSaveResult&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revision,updatedAt);

@override
String toString() {
  return 'GroupNoteSaveResult(revision: $revision, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GroupNoteSaveResultCopyWith<$Res>  {
  factory $GroupNoteSaveResultCopyWith(GroupNoteSaveResult value, $Res Function(GroupNoteSaveResult) _then) = _$GroupNoteSaveResultCopyWithImpl;
@useResult
$Res call({
 int revision,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime updatedAt
});




}
/// @nodoc
class _$GroupNoteSaveResultCopyWithImpl<$Res>
    implements $GroupNoteSaveResultCopyWith<$Res> {
  _$GroupNoteSaveResultCopyWithImpl(this._self, this._then);

  final GroupNoteSaveResult _self;
  final $Res Function(GroupNoteSaveResult) _then;

/// Create a copy of GroupNoteSaveResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? revision = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupNoteSaveResult].
extension GroupNoteSaveResultPatterns on GroupNoteSaveResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupNoteSaveResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupNoteSaveResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupNoteSaveResult value)  $default,){
final _that = this;
switch (_that) {
case _GroupNoteSaveResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupNoteSaveResult value)?  $default,){
final _that = this;
switch (_that) {
case _GroupNoteSaveResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupNoteSaveResult() when $default != null:
return $default(_that.revision,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GroupNoteSaveResult():
return $default(_that.revision,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson)  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GroupNoteSaveResult() when $default != null:
return $default(_that.revision,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupNoteSaveResult implements GroupNoteSaveResult {
  const _GroupNoteSaveResult({required this.revision, @JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) required this.updatedAt});
  factory _GroupNoteSaveResult.fromJson(Map<String, dynamic> json) => _$GroupNoteSaveResultFromJson(json);

@override final  int revision;
@override@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) final  DateTime updatedAt;

/// Create a copy of GroupNoteSaveResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupNoteSaveResultCopyWith<_GroupNoteSaveResult> get copyWith => __$GroupNoteSaveResultCopyWithImpl<_GroupNoteSaveResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupNoteSaveResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupNoteSaveResult&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,revision,updatedAt);

@override
String toString() {
  return 'GroupNoteSaveResult(revision: $revision, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GroupNoteSaveResultCopyWith<$Res> implements $GroupNoteSaveResultCopyWith<$Res> {
  factory _$GroupNoteSaveResultCopyWith(_GroupNoteSaveResult value, $Res Function(_GroupNoteSaveResult) _then) = __$GroupNoteSaveResultCopyWithImpl;
@override @useResult
$Res call({
 int revision,@JsonKey(fromJson: requiredDateTimeFromJson, toJson: requiredDateTimeToJson) DateTime updatedAt
});




}
/// @nodoc
class __$GroupNoteSaveResultCopyWithImpl<$Res>
    implements _$GroupNoteSaveResultCopyWith<$Res> {
  __$GroupNoteSaveResultCopyWithImpl(this._self, this._then);

  final _GroupNoteSaveResult _self;
  final $Res Function(_GroupNoteSaveResult) _then;

/// Create a copy of GroupNoteSaveResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? revision = null,Object? updatedAt = null,}) {
  return _then(_GroupNoteSaveResult(
revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
