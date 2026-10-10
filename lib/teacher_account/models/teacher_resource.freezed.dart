// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_resource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherResource<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherResource<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherResource<$T>()';
}


}

/// @nodoc
class $TeacherResourceCopyWith<T,$Res>  {
$TeacherResourceCopyWith(TeacherResource<T> _, $Res Function(TeacherResource<T>) __);
}


/// Adds pattern-matching-related methods to [TeacherResource].
extension TeacherResourcePatterns<T> on TeacherResource<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeacherResourceIdle<T> value)?  idle,TResult Function( TeacherResourceLoading<T> value)?  loading,TResult Function( TeacherResourceReady<T> value)?  ready,TResult Function( TeacherResourceFailure<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeacherResourceIdle() when idle != null:
return idle(_that);case TeacherResourceLoading() when loading != null:
return loading(_that);case TeacherResourceReady() when ready != null:
return ready(_that);case TeacherResourceFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeacherResourceIdle<T> value)  idle,required TResult Function( TeacherResourceLoading<T> value)  loading,required TResult Function( TeacherResourceReady<T> value)  ready,required TResult Function( TeacherResourceFailure<T> value)  failure,}){
final _that = this;
switch (_that) {
case TeacherResourceIdle():
return idle(_that);case TeacherResourceLoading():
return loading(_that);case TeacherResourceReady():
return ready(_that);case TeacherResourceFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeacherResourceIdle<T> value)?  idle,TResult? Function( TeacherResourceLoading<T> value)?  loading,TResult? Function( TeacherResourceReady<T> value)?  ready,TResult? Function( TeacherResourceFailure<T> value)?  failure,}){
final _that = this;
switch (_that) {
case TeacherResourceIdle() when idle != null:
return idle(_that);case TeacherResourceLoading() when loading != null:
return loading(_that);case TeacherResourceReady() when ready != null:
return ready(_that);case TeacherResourceFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( T? previous)?  loading,TResult Function( T value)?  ready,TResult Function( T? previous)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeacherResourceIdle() when idle != null:
return idle();case TeacherResourceLoading() when loading != null:
return loading(_that.previous);case TeacherResourceReady() when ready != null:
return ready(_that.value);case TeacherResourceFailure() when failure != null:
return failure(_that.previous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( T? previous)  loading,required TResult Function( T value)  ready,required TResult Function( T? previous)  failure,}) {final _that = this;
switch (_that) {
case TeacherResourceIdle():
return idle();case TeacherResourceLoading():
return loading(_that.previous);case TeacherResourceReady():
return ready(_that.value);case TeacherResourceFailure():
return failure(_that.previous);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( T? previous)?  loading,TResult? Function( T value)?  ready,TResult? Function( T? previous)?  failure,}) {final _that = this;
switch (_that) {
case TeacherResourceIdle() when idle != null:
return idle();case TeacherResourceLoading() when loading != null:
return loading(_that.previous);case TeacherResourceReady() when ready != null:
return ready(_that.value);case TeacherResourceFailure() when failure != null:
return failure(_that.previous);case _:
  return null;

}
}

}

/// @nodoc


class TeacherResourceIdle<T> extends TeacherResource<T> {
  const TeacherResourceIdle(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherResourceIdle<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherResource<$T>.idle()';
}


}




/// @nodoc


class TeacherResourceLoading<T> extends TeacherResource<T> {
  const TeacherResourceLoading({this.previous}): super._();


 final  T? previous;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherResourceLoadingCopyWith<T, TeacherResourceLoading<T>> get copyWith => _$TeacherResourceLoadingCopyWithImpl<T, TeacherResourceLoading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherResourceLoading<T>&&const DeepCollectionEquality().equals(other.previous, previous));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(previous));

@override
String toString() {
  return 'TeacherResource<$T>.loading(previous: $previous)';
}


}

/// @nodoc
abstract mixin class $TeacherResourceLoadingCopyWith<T,$Res> implements $TeacherResourceCopyWith<T, $Res> {
  factory $TeacherResourceLoadingCopyWith(TeacherResourceLoading<T> value, $Res Function(TeacherResourceLoading<T>) _then) = _$TeacherResourceLoadingCopyWithImpl;
@useResult
$Res call({
 T? previous
});




}
/// @nodoc
class _$TeacherResourceLoadingCopyWithImpl<T,$Res>
    implements $TeacherResourceLoadingCopyWith<T, $Res> {
  _$TeacherResourceLoadingCopyWithImpl(this._self, this._then);

  final TeacherResourceLoading<T> _self;
  final $Res Function(TeacherResourceLoading<T>) _then;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previous = freezed,}) {
  return _then(TeacherResourceLoading<T>(
previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

/// @nodoc


class TeacherResourceReady<T> extends TeacherResource<T> {
  const TeacherResourceReady(this.value): super._();


 final  T value;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherResourceReadyCopyWith<T, TeacherResourceReady<T>> get copyWith => _$TeacherResourceReadyCopyWithImpl<T, TeacherResourceReady<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherResourceReady<T>&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'TeacherResource<$T>.ready(value: $value)';
}


}

/// @nodoc
abstract mixin class $TeacherResourceReadyCopyWith<T,$Res> implements $TeacherResourceCopyWith<T, $Res> {
  factory $TeacherResourceReadyCopyWith(TeacherResourceReady<T> value, $Res Function(TeacherResourceReady<T>) _then) = _$TeacherResourceReadyCopyWithImpl;
@useResult
$Res call({
 T value
});




}
/// @nodoc
class _$TeacherResourceReadyCopyWithImpl<T,$Res>
    implements $TeacherResourceReadyCopyWith<T, $Res> {
  _$TeacherResourceReadyCopyWithImpl(this._self, this._then);

  final TeacherResourceReady<T> _self;
  final $Res Function(TeacherResourceReady<T>) _then;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(TeacherResourceReady<T>(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class TeacherResourceFailure<T> extends TeacherResource<T> {
  const TeacherResourceFailure({this.previous}): super._();


 final  T? previous;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherResourceFailureCopyWith<T, TeacherResourceFailure<T>> get copyWith => _$TeacherResourceFailureCopyWithImpl<T, TeacherResourceFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherResourceFailure<T>&&const DeepCollectionEquality().equals(other.previous, previous));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(previous));

@override
String toString() {
  return 'TeacherResource<$T>.failure(previous: $previous)';
}


}

/// @nodoc
abstract mixin class $TeacherResourceFailureCopyWith<T,$Res> implements $TeacherResourceCopyWith<T, $Res> {
  factory $TeacherResourceFailureCopyWith(TeacherResourceFailure<T> value, $Res Function(TeacherResourceFailure<T>) _then) = _$TeacherResourceFailureCopyWithImpl;
@useResult
$Res call({
 T? previous
});




}
/// @nodoc
class _$TeacherResourceFailureCopyWithImpl<T,$Res>
    implements $TeacherResourceFailureCopyWith<T, $Res> {
  _$TeacherResourceFailureCopyWithImpl(this._self, this._then);

  final TeacherResourceFailure<T> _self;
  final $Res Function(TeacherResourceFailure<T>) _then;

/// Create a copy of TeacherResource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previous = freezed,}) {
  return _then(TeacherResourceFailure<T>(
previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

// dart format on
