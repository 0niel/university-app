// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FloorModel {

 String get id; int get number; String get svgPath;
/// Create a copy of FloorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FloorModelCopyWith<FloorModel> get copyWith => _$FloorModelCopyWithImpl<FloorModel>(this as FloorModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FloorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.svgPath, svgPath) || other.svgPath == svgPath));
}


@override
int get hashCode => Object.hash(runtimeType,id,number,svgPath);

@override
String toString() {
  return 'FloorModel(id: $id, number: $number, svgPath: $svgPath)';
}


}

/// @nodoc
abstract mixin class $FloorModelCopyWith<$Res>  {
  factory $FloorModelCopyWith(FloorModel value, $Res Function(FloorModel) _then) = _$FloorModelCopyWithImpl;
@useResult
$Res call({
 String id, int number, String svgPath
});




}
/// @nodoc
class _$FloorModelCopyWithImpl<$Res>
    implements $FloorModelCopyWith<$Res> {
  _$FloorModelCopyWithImpl(this._self, this._then);

  final FloorModel _self;
  final $Res Function(FloorModel) _then;

/// Create a copy of FloorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = null,Object? svgPath = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,svgPath: null == svgPath ? _self.svgPath : svgPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FloorModel].
extension FloorModelPatterns on FloorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FloorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FloorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FloorModel value)  $default,){
final _that = this;
switch (_that) {
case _FloorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FloorModel value)?  $default,){
final _that = this;
switch (_that) {
case _FloorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int number,  String svgPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FloorModel() when $default != null:
return $default(_that.id,_that.number,_that.svgPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int number,  String svgPath)  $default,) {final _that = this;
switch (_that) {
case _FloorModel():
return $default(_that.id,_that.number,_that.svgPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int number,  String svgPath)?  $default,) {final _that = this;
switch (_that) {
case _FloorModel() when $default != null:
return $default(_that.id,_that.number,_that.svgPath);case _:
  return null;

}
}

}

/// @nodoc


class _FloorModel implements FloorModel {
  const _FloorModel({required this.id, required this.number, required this.svgPath});


@override final  String id;
@override final  int number;
@override final  String svgPath;

/// Create a copy of FloorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FloorModelCopyWith<_FloorModel> get copyWith => __$FloorModelCopyWithImpl<_FloorModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FloorModel&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.svgPath, svgPath) || other.svgPath == svgPath));
}


@override
int get hashCode => Object.hash(runtimeType,id,number,svgPath);

@override
String toString() {
  return 'FloorModel(id: $id, number: $number, svgPath: $svgPath)';
}


}

/// @nodoc
abstract mixin class _$FloorModelCopyWith<$Res> implements $FloorModelCopyWith<$Res> {
  factory _$FloorModelCopyWith(_FloorModel value, $Res Function(_FloorModel) _then) = __$FloorModelCopyWithImpl;
@override @useResult
$Res call({
 String id, int number, String svgPath
});




}
/// @nodoc
class __$FloorModelCopyWithImpl<$Res>
    implements _$FloorModelCopyWith<$Res> {
  __$FloorModelCopyWithImpl(this._self, this._then);

  final _FloorModel _self;
  final $Res Function(_FloorModel) _then;

/// Create a copy of FloorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = null,Object? svgPath = null,}) {
  return _then(_FloorModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,svgPath: null == svgPath ? _self.svgPath : svgPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
