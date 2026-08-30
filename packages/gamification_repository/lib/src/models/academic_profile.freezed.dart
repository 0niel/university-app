// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'academic_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AcademicProfile {

 String? get handle; String? get group; int? get course; String? get fullName; String? get studentCardNumber;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get cardValidUntil;
/// Create a copy of AcademicProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AcademicProfileCopyWith<AcademicProfile> get copyWith => _$AcademicProfileCopyWithImpl<AcademicProfile>(this as AcademicProfile, _$identity);

  /// Serializes this AcademicProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AcademicProfile&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.course, course) || other.course == course)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.studentCardNumber, studentCardNumber) || other.studentCardNumber == studentCardNumber)&&(identical(other.cardValidUntil, cardValidUntil) || other.cardValidUntil == cardValidUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,handle,group,course,fullName,studentCardNumber,cardValidUntil);

@override
String toString() {
  return 'AcademicProfile(handle: $handle, group: $group, course: $course, fullName: $fullName, studentCardNumber: $studentCardNumber, cardValidUntil: $cardValidUntil)';
}


}

/// @nodoc
abstract mixin class $AcademicProfileCopyWith<$Res>  {
  factory $AcademicProfileCopyWith(AcademicProfile value, $Res Function(AcademicProfile) _then) = _$AcademicProfileCopyWithImpl;
@useResult
$Res call({
 String? handle, String? group, int? course, String? fullName, String? studentCardNumber,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? cardValidUntil
});




}
/// @nodoc
class _$AcademicProfileCopyWithImpl<$Res>
    implements $AcademicProfileCopyWith<$Res> {
  _$AcademicProfileCopyWithImpl(this._self, this._then);

  final AcademicProfile _self;
  final $Res Function(AcademicProfile) _then;

/// Create a copy of AcademicProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? handle = freezed,Object? group = freezed,Object? course = freezed,Object? fullName = freezed,Object? studentCardNumber = freezed,Object? cardValidUntil = freezed,}) {
  return _then(_self.copyWith(
handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,studentCardNumber: freezed == studentCardNumber ? _self.studentCardNumber : studentCardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardValidUntil: freezed == cardValidUntil ? _self.cardValidUntil : cardValidUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AcademicProfile].
extension AcademicProfilePatterns on AcademicProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AcademicProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AcademicProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AcademicProfile value)  $default,){
final _that = this;
switch (_that) {
case _AcademicProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AcademicProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AcademicProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? handle,  String? group,  int? course,  String? fullName,  String? studentCardNumber, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? cardValidUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AcademicProfile() when $default != null:
return $default(_that.handle,_that.group,_that.course,_that.fullName,_that.studentCardNumber,_that.cardValidUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? handle,  String? group,  int? course,  String? fullName,  String? studentCardNumber, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? cardValidUntil)  $default,) {final _that = this;
switch (_that) {
case _AcademicProfile():
return $default(_that.handle,_that.group,_that.course,_that.fullName,_that.studentCardNumber,_that.cardValidUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? handle,  String? group,  int? course,  String? fullName,  String? studentCardNumber, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? cardValidUntil)?  $default,) {final _that = this;
switch (_that) {
case _AcademicProfile() when $default != null:
return $default(_that.handle,_that.group,_that.course,_that.fullName,_that.studentCardNumber,_that.cardValidUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AcademicProfile implements AcademicProfile {
  const _AcademicProfile({this.handle, this.group, this.course, this.fullName, this.studentCardNumber, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.cardValidUntil});
  factory _AcademicProfile.fromJson(Map<String, dynamic> json) => _$AcademicProfileFromJson(json);

@override final  String? handle;
@override final  String? group;
@override final  int? course;
@override final  String? fullName;
@override final  String? studentCardNumber;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? cardValidUntil;

/// Create a copy of AcademicProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AcademicProfileCopyWith<_AcademicProfile> get copyWith => __$AcademicProfileCopyWithImpl<_AcademicProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AcademicProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AcademicProfile&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.group, group) || other.group == group)&&(identical(other.course, course) || other.course == course)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.studentCardNumber, studentCardNumber) || other.studentCardNumber == studentCardNumber)&&(identical(other.cardValidUntil, cardValidUntil) || other.cardValidUntil == cardValidUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,handle,group,course,fullName,studentCardNumber,cardValidUntil);

@override
String toString() {
  return 'AcademicProfile(handle: $handle, group: $group, course: $course, fullName: $fullName, studentCardNumber: $studentCardNumber, cardValidUntil: $cardValidUntil)';
}


}

/// @nodoc
abstract mixin class _$AcademicProfileCopyWith<$Res> implements $AcademicProfileCopyWith<$Res> {
  factory _$AcademicProfileCopyWith(_AcademicProfile value, $Res Function(_AcademicProfile) _then) = __$AcademicProfileCopyWithImpl;
@override @useResult
$Res call({
 String? handle, String? group, int? course, String? fullName, String? studentCardNumber,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? cardValidUntil
});




}
/// @nodoc
class __$AcademicProfileCopyWithImpl<$Res>
    implements _$AcademicProfileCopyWith<$Res> {
  __$AcademicProfileCopyWithImpl(this._self, this._then);

  final _AcademicProfile _self;
  final $Res Function(_AcademicProfile) _then;

/// Create a copy of AcademicProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? handle = freezed,Object? group = freezed,Object? course = freezed,Object? fullName = freezed,Object? studentCardNumber = freezed,Object? cardValidUntil = freezed,}) {
  return _then(_AcademicProfile(
handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,course: freezed == course ? _self.course : course // ignore: cast_nullable_to_non_nullable
as int?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,studentCardNumber: freezed == studentCardNumber ? _self.studentCardNumber : studentCardNumber // ignore: cast_nullable_to_non_nullable
as String?,cardValidUntil: freezed == cardValidUntil ? _self.cardValidUntil : cardValidUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
