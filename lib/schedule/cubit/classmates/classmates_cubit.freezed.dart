// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'classmates_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassmatesState {

 List<Friend> get classmates; String get group; bool get loading;
/// Create a copy of ClassmatesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassmatesStateCopyWith<ClassmatesState> get copyWith => _$ClassmatesStateCopyWithImpl<ClassmatesState>(this as ClassmatesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassmatesState&&const DeepCollectionEquality().equals(other.classmates, classmates)&&(identical(other.group, group) || other.group == group)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(classmates),group,loading);

@override
String toString() {
  return 'ClassmatesState(classmates: $classmates, group: $group, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $ClassmatesStateCopyWith<$Res>  {
  factory $ClassmatesStateCopyWith(ClassmatesState value, $Res Function(ClassmatesState) _then) = _$ClassmatesStateCopyWithImpl;
@useResult
$Res call({
 List<Friend> classmates, String group, bool loading
});




}
/// @nodoc
class _$ClassmatesStateCopyWithImpl<$Res>
    implements $ClassmatesStateCopyWith<$Res> {
  _$ClassmatesStateCopyWithImpl(this._self, this._then);

  final ClassmatesState _self;
  final $Res Function(ClassmatesState) _then;

/// Create a copy of ClassmatesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? classmates = null,Object? group = null,Object? loading = null,}) {
  return _then(_self.copyWith(
classmates: null == classmates ? _self.classmates : classmates // ignore: cast_nullable_to_non_nullable
as List<Friend>,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassmatesState].
extension ClassmatesStatePatterns on ClassmatesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassmatesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassmatesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassmatesState value)  $default,){
final _that = this;
switch (_that) {
case _ClassmatesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassmatesState value)?  $default,){
final _that = this;
switch (_that) {
case _ClassmatesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Friend> classmates,  String group,  bool loading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassmatesState() when $default != null:
return $default(_that.classmates,_that.group,_that.loading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Friend> classmates,  String group,  bool loading)  $default,) {final _that = this;
switch (_that) {
case _ClassmatesState():
return $default(_that.classmates,_that.group,_that.loading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Friend> classmates,  String group,  bool loading)?  $default,) {final _that = this;
switch (_that) {
case _ClassmatesState() when $default != null:
return $default(_that.classmates,_that.group,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class _ClassmatesState extends ClassmatesState {
  const _ClassmatesState({final  List<Friend> classmates = const <Friend>[], this.group = '', this.loading = false}): _classmates = classmates,super._();


 final  List<Friend> _classmates;
@override@JsonKey() List<Friend> get classmates {
  if (_classmates is EqualUnmodifiableListView) return _classmates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classmates);
}

@override@JsonKey() final  String group;
@override@JsonKey() final  bool loading;

/// Create a copy of ClassmatesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassmatesStateCopyWith<_ClassmatesState> get copyWith => __$ClassmatesStateCopyWithImpl<_ClassmatesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassmatesState&&const DeepCollectionEquality().equals(other._classmates, _classmates)&&(identical(other.group, group) || other.group == group)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_classmates),group,loading);

@override
String toString() {
  return 'ClassmatesState(classmates: $classmates, group: $group, loading: $loading)';
}


}

/// @nodoc
abstract mixin class _$ClassmatesStateCopyWith<$Res> implements $ClassmatesStateCopyWith<$Res> {
  factory _$ClassmatesStateCopyWith(_ClassmatesState value, $Res Function(_ClassmatesState) _then) = __$ClassmatesStateCopyWithImpl;
@override @useResult
$Res call({
 List<Friend> classmates, String group, bool loading
});




}
/// @nodoc
class __$ClassmatesStateCopyWithImpl<$Res>
    implements _$ClassmatesStateCopyWith<$Res> {
  __$ClassmatesStateCopyWithImpl(this._self, this._then);

  final _ClassmatesState _self;
  final $Res Function(_ClassmatesState) _then;

/// Create a copy of ClassmatesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classmates = null,Object? group = null,Object? loading = null,}) {
  return _then(_ClassmatesState(
classmates: null == classmates ? _self._classmates : classmates // ignore: cast_nullable_to_non_nullable
as List<Friend>,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
