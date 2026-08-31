// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classroom.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Classroom {

 String get name; String? get uid; Campus? get campus; String? get url;
/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassroomCopyWith<Classroom> get copyWith => _$ClassroomCopyWithImpl<Classroom>(this as Classroom, _$identity);

  /// Serializes this Classroom to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Classroom&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,campus,url);

@override
String toString() {
  return 'Classroom(name: $name, uid: $uid, campus: $campus, url: $url)';
}


}

/// @nodoc
abstract mixin class $ClassroomCopyWith<$Res>  {
  factory $ClassroomCopyWith(Classroom value, $Res Function(Classroom) _then) = _$ClassroomCopyWithImpl;
@useResult
$Res call({
 String name, String? uid, Campus? campus, String? url
});


$CampusCopyWith<$Res>? get campus;

}
/// @nodoc
class _$ClassroomCopyWithImpl<$Res>
    implements $ClassroomCopyWith<$Res> {
  _$ClassroomCopyWithImpl(this._self, this._then);

  final Classroom _self;
  final $Res Function(Classroom) _then;

/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? uid = freezed,Object? campus = freezed,Object? url = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as Campus?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusCopyWith<$Res>? get campus {
    if (_self.campus == null) {
    return null;
  }

  return $CampusCopyWith<$Res>(_self.campus!, (value) {
    return _then(_self.copyWith(campus: value));
  });
}
}


/// Adds pattern-matching-related methods to [Classroom].
extension ClassroomPatterns on Classroom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Classroom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Classroom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Classroom value)  $default,){
final _that = this;
switch (_that) {
case _Classroom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Classroom value)?  $default,){
final _that = this;
switch (_that) {
case _Classroom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? uid,  Campus? campus,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Classroom() when $default != null:
return $default(_that.name,_that.uid,_that.campus,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? uid,  Campus? campus,  String? url)  $default,) {final _that = this;
switch (_that) {
case _Classroom():
return $default(_that.name,_that.uid,_that.campus,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? uid,  Campus? campus,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _Classroom() when $default != null:
return $default(_that.name,_that.uid,_that.campus,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Classroom extends Classroom {
  const _Classroom({required this.name, this.uid, this.campus, this.url}): super._();
  factory _Classroom.fromJson(Map<String, dynamic> json) => _$ClassroomFromJson(json);

@override final  String name;
@override final  String? uid;
@override final  Campus? campus;
@override final  String? url;

/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassroomCopyWith<_Classroom> get copyWith => __$ClassroomCopyWithImpl<_Classroom>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassroomToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Classroom&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,campus,url);

@override
String toString() {
  return 'Classroom(name: $name, uid: $uid, campus: $campus, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ClassroomCopyWith<$Res> implements $ClassroomCopyWith<$Res> {
  factory _$ClassroomCopyWith(_Classroom value, $Res Function(_Classroom) _then) = __$ClassroomCopyWithImpl;
@override @useResult
$Res call({
 String name, String? uid, Campus? campus, String? url
});


@override $CampusCopyWith<$Res>? get campus;

}
/// @nodoc
class __$ClassroomCopyWithImpl<$Res>
    implements _$ClassroomCopyWith<$Res> {
  __$ClassroomCopyWithImpl(this._self, this._then);

  final _Classroom _self;
  final $Res Function(_Classroom) _then;

/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? uid = freezed,Object? campus = freezed,Object? url = freezed,}) {
  return _then(_Classroom(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as Campus?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Classroom
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CampusCopyWith<$Res>? get campus {
    if (_self.campus == null) {
    return null;
  }

  return $CampusCopyWith<$Res>(_self.campus!, (value) {
    return _then(_self.copyWith(campus: value));
  });
}
}

// dart format on
