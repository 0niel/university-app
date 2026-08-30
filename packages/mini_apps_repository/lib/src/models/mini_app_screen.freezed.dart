// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_screen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiniAppScreen {

@JsonKey(includeToJson: false) String? get id; String get path;@JsonKey(includeIfNull: false) String? get title; Map<String, dynamic> get json;
/// Create a copy of MiniAppScreen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppScreenCopyWith<MiniAppScreen> get copyWith => _$MiniAppScreenCopyWithImpl<MiniAppScreen>(this as MiniAppScreen, _$identity);

  /// Serializes this MiniAppScreen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppScreen&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.json, json));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,title,const DeepCollectionEquality().hash(json));

@override
String toString() {
  return 'MiniAppScreen(id: $id, path: $path, title: $title, json: $json)';
}


}

/// @nodoc
abstract mixin class $MiniAppScreenCopyWith<$Res>  {
  factory $MiniAppScreenCopyWith(MiniAppScreen value, $Res Function(MiniAppScreen) _then) = _$MiniAppScreenCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String? id, String path,@JsonKey(includeIfNull: false) String? title, Map<String, dynamic> json
});




}
/// @nodoc
class _$MiniAppScreenCopyWithImpl<$Res>
    implements $MiniAppScreenCopyWith<$Res> {
  _$MiniAppScreenCopyWithImpl(this._self, this._then);

  final MiniAppScreen _self;
  final $Res Function(MiniAppScreen) _then;

/// Create a copy of MiniAppScreen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? path = null,Object? title = freezed,Object? json = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,json: null == json ? _self.json : json // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppScreen].
extension MiniAppScreenPatterns on MiniAppScreen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppScreen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppScreen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppScreen value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppScreen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppScreen value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppScreen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? id,  String path, @JsonKey(includeIfNull: false)  String? title,  Map<String, dynamic> json)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppScreen() when $default != null:
return $default(_that.id,_that.path,_that.title,_that.json);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String? id,  String path, @JsonKey(includeIfNull: false)  String? title,  Map<String, dynamic> json)  $default,) {final _that = this;
switch (_that) {
case _MiniAppScreen():
return $default(_that.id,_that.path,_that.title,_that.json);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String? id,  String path, @JsonKey(includeIfNull: false)  String? title,  Map<String, dynamic> json)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppScreen() when $default != null:
return $default(_that.id,_that.path,_that.title,_that.json);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiniAppScreen implements MiniAppScreen {
  const _MiniAppScreen({@JsonKey(includeToJson: false) this.id, this.path = '/', @JsonKey(includeIfNull: false) this.title, final  Map<String, dynamic> json = const <String, dynamic>{}}): _json = json;
  factory _MiniAppScreen.fromJson(Map<String, dynamic> json) => _$MiniAppScreenFromJson(json);

@override@JsonKey(includeToJson: false) final  String? id;
@override@JsonKey() final  String path;
@override@JsonKey(includeIfNull: false) final  String? title;
 final  Map<String, dynamic> _json;
@override@JsonKey() Map<String, dynamic> get json {
  if (_json is EqualUnmodifiableMapView) return _json;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_json);
}


/// Create a copy of MiniAppScreen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppScreenCopyWith<_MiniAppScreen> get copyWith => __$MiniAppScreenCopyWithImpl<_MiniAppScreen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiniAppScreenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppScreen&&(identical(other.id, id) || other.id == id)&&(identical(other.path, path) || other.path == path)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._json, _json));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,path,title,const DeepCollectionEquality().hash(_json));

@override
String toString() {
  return 'MiniAppScreen(id: $id, path: $path, title: $title, json: $json)';
}


}

/// @nodoc
abstract mixin class _$MiniAppScreenCopyWith<$Res> implements $MiniAppScreenCopyWith<$Res> {
  factory _$MiniAppScreenCopyWith(_MiniAppScreen value, $Res Function(_MiniAppScreen) _then) = __$MiniAppScreenCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String? id, String path,@JsonKey(includeIfNull: false) String? title, Map<String, dynamic> json
});




}
/// @nodoc
class __$MiniAppScreenCopyWithImpl<$Res>
    implements _$MiniAppScreenCopyWith<$Res> {
  __$MiniAppScreenCopyWithImpl(this._self, this._then);

  final _MiniAppScreen _self;
  final $Res Function(_MiniAppScreen) _then;

/// Create a copy of MiniAppScreen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? path = null,Object? title = freezed,Object? json = null,}) {
  return _then(_MiniAppScreen(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,json: null == json ? _self._json : json // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
