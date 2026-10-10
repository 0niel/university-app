// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_schedule_navigation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherScheduleNavigation {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherScheduleNavigation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherScheduleNavigation()';
}


}

/// @nodoc
class $TeacherScheduleNavigationCopyWith<$Res>  {
$TeacherScheduleNavigationCopyWith(TeacherScheduleNavigation _, $Res Function(TeacherScheduleNavigation) __);
}


/// Adds pattern-matching-related methods to [TeacherScheduleNavigation].
extension TeacherScheduleNavigationPatterns on TeacherScheduleNavigation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TeacherNavigationIdle value)?  idle,TResult Function( TeacherNavigationActivating value)?  activating,TResult Function( TeacherNavigationReady value)?  ready,TResult Function( TeacherNavigationFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TeacherNavigationIdle() when idle != null:
return idle(_that);case TeacherNavigationActivating() when activating != null:
return activating(_that);case TeacherNavigationReady() when ready != null:
return ready(_that);case TeacherNavigationFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TeacherNavigationIdle value)  idle,required TResult Function( TeacherNavigationActivating value)  activating,required TResult Function( TeacherNavigationReady value)  ready,required TResult Function( TeacherNavigationFailure value)  failure,}){
final _that = this;
switch (_that) {
case TeacherNavigationIdle():
return idle(_that);case TeacherNavigationActivating():
return activating(_that);case TeacherNavigationReady():
return ready(_that);case TeacherNavigationFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TeacherNavigationIdle value)?  idle,TResult? Function( TeacherNavigationActivating value)?  activating,TResult? Function( TeacherNavigationReady value)?  ready,TResult? Function( TeacherNavigationFailure value)?  failure,}){
final _that = this;
switch (_that) {
case TeacherNavigationIdle() when idle != null:
return idle(_that);case TeacherNavigationActivating() when activating != null:
return activating(_that);case TeacherNavigationReady() when ready != null:
return ready(_that);case TeacherNavigationFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( TeacherScheduleDestination destination)?  activating,TResult Function( TeacherScheduleDestination destination)?  ready,TResult Function( TeacherScheduleDestination destination)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TeacherNavigationIdle() when idle != null:
return idle();case TeacherNavigationActivating() when activating != null:
return activating(_that.destination);case TeacherNavigationReady() when ready != null:
return ready(_that.destination);case TeacherNavigationFailure() when failure != null:
return failure(_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( TeacherScheduleDestination destination)  activating,required TResult Function( TeacherScheduleDestination destination)  ready,required TResult Function( TeacherScheduleDestination destination)  failure,}) {final _that = this;
switch (_that) {
case TeacherNavigationIdle():
return idle();case TeacherNavigationActivating():
return activating(_that.destination);case TeacherNavigationReady():
return ready(_that.destination);case TeacherNavigationFailure():
return failure(_that.destination);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( TeacherScheduleDestination destination)?  activating,TResult? Function( TeacherScheduleDestination destination)?  ready,TResult? Function( TeacherScheduleDestination destination)?  failure,}) {final _that = this;
switch (_that) {
case TeacherNavigationIdle() when idle != null:
return idle();case TeacherNavigationActivating() when activating != null:
return activating(_that.destination);case TeacherNavigationReady() when ready != null:
return ready(_that.destination);case TeacherNavigationFailure() when failure != null:
return failure(_that.destination);case _:
  return null;

}
}

}

/// @nodoc


class TeacherNavigationIdle extends TeacherScheduleNavigation {
  const TeacherNavigationIdle(): super._();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherNavigationIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TeacherScheduleNavigation.idle()';
}


}




/// @nodoc


class TeacherNavigationActivating extends TeacherScheduleNavigation {
  const TeacherNavigationActivating(this.destination): super._();


 final  TeacherScheduleDestination destination;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherNavigationActivatingCopyWith<TeacherNavigationActivating> get copyWith => _$TeacherNavigationActivatingCopyWithImpl<TeacherNavigationActivating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherNavigationActivating&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,destination);

@override
String toString() {
  return 'TeacherScheduleNavigation.activating(destination: $destination)';
}


}

/// @nodoc
abstract mixin class $TeacherNavigationActivatingCopyWith<$Res> implements $TeacherScheduleNavigationCopyWith<$Res> {
  factory $TeacherNavigationActivatingCopyWith(TeacherNavigationActivating value, $Res Function(TeacherNavigationActivating) _then) = _$TeacherNavigationActivatingCopyWithImpl;
@useResult
$Res call({
 TeacherScheduleDestination destination
});




}
/// @nodoc
class _$TeacherNavigationActivatingCopyWithImpl<$Res>
    implements $TeacherNavigationActivatingCopyWith<$Res> {
  _$TeacherNavigationActivatingCopyWithImpl(this._self, this._then);

  final TeacherNavigationActivating _self;
  final $Res Function(TeacherNavigationActivating) _then;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? destination = null,}) {
  return _then(TeacherNavigationActivating(
null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as TeacherScheduleDestination,
  ));
}


}

/// @nodoc


class TeacherNavigationReady extends TeacherScheduleNavigation {
  const TeacherNavigationReady(this.destination): super._();


 final  TeacherScheduleDestination destination;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherNavigationReadyCopyWith<TeacherNavigationReady> get copyWith => _$TeacherNavigationReadyCopyWithImpl<TeacherNavigationReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherNavigationReady&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,destination);

@override
String toString() {
  return 'TeacherScheduleNavigation.ready(destination: $destination)';
}


}

/// @nodoc
abstract mixin class $TeacherNavigationReadyCopyWith<$Res> implements $TeacherScheduleNavigationCopyWith<$Res> {
  factory $TeacherNavigationReadyCopyWith(TeacherNavigationReady value, $Res Function(TeacherNavigationReady) _then) = _$TeacherNavigationReadyCopyWithImpl;
@useResult
$Res call({
 TeacherScheduleDestination destination
});




}
/// @nodoc
class _$TeacherNavigationReadyCopyWithImpl<$Res>
    implements $TeacherNavigationReadyCopyWith<$Res> {
  _$TeacherNavigationReadyCopyWithImpl(this._self, this._then);

  final TeacherNavigationReady _self;
  final $Res Function(TeacherNavigationReady) _then;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? destination = null,}) {
  return _then(TeacherNavigationReady(
null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as TeacherScheduleDestination,
  ));
}


}

/// @nodoc


class TeacherNavigationFailure extends TeacherScheduleNavigation {
  const TeacherNavigationFailure(this.destination): super._();


 final  TeacherScheduleDestination destination;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherNavigationFailureCopyWith<TeacherNavigationFailure> get copyWith => _$TeacherNavigationFailureCopyWithImpl<TeacherNavigationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherNavigationFailure&&(identical(other.destination, destination) || other.destination == destination));
}


@override
int get hashCode => Object.hash(runtimeType,destination);

@override
String toString() {
  return 'TeacherScheduleNavigation.failure(destination: $destination)';
}


}

/// @nodoc
abstract mixin class $TeacherNavigationFailureCopyWith<$Res> implements $TeacherScheduleNavigationCopyWith<$Res> {
  factory $TeacherNavigationFailureCopyWith(TeacherNavigationFailure value, $Res Function(TeacherNavigationFailure) _then) = _$TeacherNavigationFailureCopyWithImpl;
@useResult
$Res call({
 TeacherScheduleDestination destination
});




}
/// @nodoc
class _$TeacherNavigationFailureCopyWithImpl<$Res>
    implements $TeacherNavigationFailureCopyWith<$Res> {
  _$TeacherNavigationFailureCopyWithImpl(this._self, this._then);

  final TeacherNavigationFailure _self;
  final $Res Function(TeacherNavigationFailure) _then;

/// Create a copy of TeacherScheduleNavigation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? destination = null,}) {
  return _then(TeacherNavigationFailure(
null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as TeacherScheduleDestination,
  ));
}


}

// dart format on
