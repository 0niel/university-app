// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_group_join_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudyGroupJoinRequest {

 String get id; String get userId; String get fullName; String? get handle;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? get createdAt;
/// Create a copy of StudyGroupJoinRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyGroupJoinRequestCopyWith<StudyGroupJoinRequest> get copyWith => _$StudyGroupJoinRequestCopyWithImpl<StudyGroupJoinRequest>(this as StudyGroupJoinRequest, _$identity);

  /// Serializes this StudyGroupJoinRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyGroupJoinRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,handle,createdAt);

@override
String toString() {
  return 'StudyGroupJoinRequest(id: $id, userId: $userId, fullName: $fullName, handle: $handle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StudyGroupJoinRequestCopyWith<$Res>  {
  factory $StudyGroupJoinRequestCopyWith(StudyGroupJoinRequest value, $Res Function(StudyGroupJoinRequest) _then) = _$StudyGroupJoinRequestCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String fullName, String? handle,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class _$StudyGroupJoinRequestCopyWithImpl<$Res>
    implements $StudyGroupJoinRequestCopyWith<$Res> {
  _$StudyGroupJoinRequestCopyWithImpl(this._self, this._then);

  final StudyGroupJoinRequest _self;
  final $Res Function(StudyGroupJoinRequest) _then;

/// Create a copy of StudyGroupJoinRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyGroupJoinRequest].
extension StudyGroupJoinRequestPatterns on StudyGroupJoinRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyGroupJoinRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyGroupJoinRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyGroupJoinRequest value)  $default,){
final _that = this;
switch (_that) {
case _StudyGroupJoinRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyGroupJoinRequest value)?  $default,){
final _that = this;
switch (_that) {
case _StudyGroupJoinRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? handle, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyGroupJoinRequest() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.handle,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String fullName,  String? handle, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _StudyGroupJoinRequest():
return $default(_that.id,_that.userId,_that.fullName,_that.handle,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String fullName,  String? handle, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyGroupJoinRequest() when $default != null:
return $default(_that.id,_that.userId,_that.fullName,_that.handle,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudyGroupJoinRequest implements StudyGroupJoinRequest {
  const _StudyGroupJoinRequest({required this.id, required this.userId, required this.fullName, this.handle, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) this.createdAt});
  factory _StudyGroupJoinRequest.fromJson(Map<String, dynamic> json) => _$StudyGroupJoinRequestFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String fullName;
@override final  String? handle;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime? createdAt;

/// Create a copy of StudyGroupJoinRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyGroupJoinRequestCopyWith<_StudyGroupJoinRequest> get copyWith => __$StudyGroupJoinRequestCopyWithImpl<_StudyGroupJoinRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyGroupJoinRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyGroupJoinRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,fullName,handle,createdAt);

@override
String toString() {
  return 'StudyGroupJoinRequest(id: $id, userId: $userId, fullName: $fullName, handle: $handle, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StudyGroupJoinRequestCopyWith<$Res> implements $StudyGroupJoinRequestCopyWith<$Res> {
  factory _$StudyGroupJoinRequestCopyWith(_StudyGroupJoinRequest value, $Res Function(_StudyGroupJoinRequest) _then) = __$StudyGroupJoinRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String fullName, String? handle,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime? createdAt
});




}
/// @nodoc
class __$StudyGroupJoinRequestCopyWithImpl<$Res>
    implements _$StudyGroupJoinRequestCopyWith<$Res> {
  __$StudyGroupJoinRequestCopyWithImpl(this._self, this._then);

  final _StudyGroupJoinRequest _self;
  final $Res Function(_StudyGroupJoinRequest) _then;

/// Create a copy of StudyGroupJoinRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? fullName = null,Object? handle = freezed,Object? createdAt = freezed,}) {
  return _then(_StudyGroupJoinRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
