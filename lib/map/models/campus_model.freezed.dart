// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campus_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CampusModel {

 String get id; String get displayName; List<FloorModel> get floors;
/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusModelCopyWith<CampusModel> get copyWith => _$CampusModelCopyWithImpl<CampusModel>(this as CampusModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.floors, floors));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,const DeepCollectionEquality().hash(floors));

@override
String toString() {
  return 'CampusModel(id: $id, displayName: $displayName, floors: $floors)';
}


}

/// @nodoc
abstract mixin class $CampusModelCopyWith<$Res>  {
  factory $CampusModelCopyWith(CampusModel value, $Res Function(CampusModel) _then) = _$CampusModelCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, List<FloorModel> floors
});




}
/// @nodoc
class _$CampusModelCopyWithImpl<$Res>
    implements $CampusModelCopyWith<$Res> {
  _$CampusModelCopyWithImpl(this._self, this._then);

  final CampusModel _self;
  final $Res Function(CampusModel) _then;

/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? floors = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,floors: null == floors ? _self.floors : floors // ignore: cast_nullable_to_non_nullable
as List<FloorModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CampusModel].
extension CampusModelPatterns on CampusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampusModel value)  $default,){
final _that = this;
switch (_that) {
case _CampusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampusModel value)?  $default,){
final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  List<FloorModel> floors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
return $default(_that.id,_that.displayName,_that.floors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  List<FloorModel> floors)  $default,) {final _that = this;
switch (_that) {
case _CampusModel():
return $default(_that.id,_that.displayName,_that.floors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  List<FloorModel> floors)?  $default,) {final _that = this;
switch (_that) {
case _CampusModel() when $default != null:
return $default(_that.id,_that.displayName,_that.floors);case _:
  return null;

}
}

}

/// @nodoc


class _CampusModel implements CampusModel {
  const _CampusModel({required this.id, required this.displayName, required final  List<FloorModel> floors}): _floors = floors;


@override final  String id;
@override final  String displayName;
 final  List<FloorModel> _floors;
@override List<FloorModel> get floors {
  if (_floors is EqualUnmodifiableListView) return _floors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_floors);
}


/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusModelCopyWith<_CampusModel> get copyWith => __$CampusModelCopyWithImpl<_CampusModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampusModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other._floors, _floors));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,const DeepCollectionEquality().hash(_floors));

@override
String toString() {
  return 'CampusModel(id: $id, displayName: $displayName, floors: $floors)';
}


}

/// @nodoc
abstract mixin class _$CampusModelCopyWith<$Res> implements $CampusModelCopyWith<$Res> {
  factory _$CampusModelCopyWith(_CampusModel value, $Res Function(_CampusModel) _then) = __$CampusModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, List<FloorModel> floors
});




}
/// @nodoc
class __$CampusModelCopyWithImpl<$Res>
    implements _$CampusModelCopyWith<$Res> {
  __$CampusModelCopyWithImpl(this._self, this._then);

  final _CampusModel _self;
  final $Res Function(_CampusModel) _then;

/// Create a copy of CampusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? floors = null,}) {
  return _then(_CampusModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,floors: null == floors ? _self._floors : floors // ignore: cast_nullable_to_non_nullable
as List<FloorModel>,
  ));
}


}

// dart format on
