// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherDashboardState {

 DateTime get now; DateTime get day; TeacherDashboardBinding get binding; TeacherWorkload get workload; TeacherResource<TeacherScheduleSnapshot> get schedule; TeacherResource<List<ScheduleChange>> get changes; TeacherResource<TeacherProfile> get rating; TeacherScheduleNavigation get navigation;
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherDashboardStateCopyWith<TeacherDashboardState> get copyWith => _$TeacherDashboardStateCopyWithImpl<TeacherDashboardState>(this as TeacherDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherDashboardState&&(identical(other.now, now) || other.now == now)&&(identical(other.day, day) || other.day == day)&&(identical(other.binding, binding) || other.binding == binding)&&(identical(other.workload, workload) || other.workload == workload)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.changes, changes) || other.changes == changes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.navigation, navigation) || other.navigation == navigation));
}


@override
int get hashCode => Object.hash(runtimeType,now,day,binding,workload,schedule,changes,rating,navigation);

@override
String toString() {
  return 'TeacherDashboardState(now: $now, day: $day, binding: $binding, workload: $workload, schedule: $schedule, changes: $changes, rating: $rating, navigation: $navigation)';
}


}

/// @nodoc
abstract mixin class $TeacherDashboardStateCopyWith<$Res>  {
  factory $TeacherDashboardStateCopyWith(TeacherDashboardState value, $Res Function(TeacherDashboardState) _then) = _$TeacherDashboardStateCopyWithImpl;
@useResult
$Res call({
 DateTime now, DateTime day, TeacherDashboardBinding binding, TeacherWorkload workload, TeacherResource<TeacherScheduleSnapshot> schedule, TeacherResource<List<ScheduleChange>> changes, TeacherResource<TeacherProfile> rating, TeacherScheduleNavigation navigation
});


$TeacherDashboardBindingCopyWith<$Res> get binding;$TeacherWorkloadCopyWith<$Res> get workload;$TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res> get schedule;$TeacherResourceCopyWith<List<ScheduleChange>, $Res> get changes;$TeacherResourceCopyWith<TeacherProfile, $Res> get rating;$TeacherScheduleNavigationCopyWith<$Res> get navigation;

}
/// @nodoc
class _$TeacherDashboardStateCopyWithImpl<$Res>
    implements $TeacherDashboardStateCopyWith<$Res> {
  _$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final TeacherDashboardState _self;
  final $Res Function(TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? now = null,Object? day = null,Object? binding = null,Object? workload = null,Object? schedule = null,Object? changes = null,Object? rating = null,Object? navigation = null,}) {
  return _then(_self.copyWith(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,binding: null == binding ? _self.binding : binding // ignore: cast_nullable_to_non_nullable
as TeacherDashboardBinding,workload: null == workload ? _self.workload : workload // ignore: cast_nullable_to_non_nullable
as TeacherWorkload,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TeacherResource<TeacherScheduleSnapshot>,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as TeacherResource<List<ScheduleChange>>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as TeacherResource<TeacherProfile>,navigation: null == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as TeacherScheduleNavigation,
  ));
}
/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherDashboardBindingCopyWith<$Res> get binding {

  return $TeacherDashboardBindingCopyWith<$Res>(_self.binding, (value) {
    return _then(_self.copyWith(binding: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherWorkloadCopyWith<$Res> get workload {

  return $TeacherWorkloadCopyWith<$Res>(_self.workload, (value) {
    return _then(_self.copyWith(workload: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res> get schedule {

  return $TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<List<ScheduleChange>, $Res> get changes {

  return $TeacherResourceCopyWith<List<ScheduleChange>, $Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<TeacherProfile, $Res> get rating {

  return $TeacherResourceCopyWith<TeacherProfile, $Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherScheduleNavigationCopyWith<$Res> get navigation {

  return $TeacherScheduleNavigationCopyWith<$Res>(_self.navigation, (value) {
    return _then(_self.copyWith(navigation: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeacherDashboardState].
extension TeacherDashboardStatePatterns on TeacherDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime now,  DateTime day,  TeacherDashboardBinding binding,  TeacherWorkload workload,  TeacherResource<TeacherScheduleSnapshot> schedule,  TeacherResource<List<ScheduleChange>> changes,  TeacherResource<TeacherProfile> rating,  TeacherScheduleNavigation navigation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.now,_that.day,_that.binding,_that.workload,_that.schedule,_that.changes,_that.rating,_that.navigation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime now,  DateTime day,  TeacherDashboardBinding binding,  TeacherWorkload workload,  TeacherResource<TeacherScheduleSnapshot> schedule,  TeacherResource<List<ScheduleChange>> changes,  TeacherResource<TeacherProfile> rating,  TeacherScheduleNavigation navigation)  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState():
return $default(_that.now,_that.day,_that.binding,_that.workload,_that.schedule,_that.changes,_that.rating,_that.navigation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime now,  DateTime day,  TeacherDashboardBinding binding,  TeacherWorkload workload,  TeacherResource<TeacherScheduleSnapshot> schedule,  TeacherResource<List<ScheduleChange>> changes,  TeacherResource<TeacherProfile> rating,  TeacherScheduleNavigation navigation)?  $default,) {final _that = this;
switch (_that) {
case _TeacherDashboardState() when $default != null:
return $default(_that.now,_that.day,_that.binding,_that.workload,_that.schedule,_that.changes,_that.rating,_that.navigation);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherDashboardState extends TeacherDashboardState {
  const _TeacherDashboardState({required this.now, required this.day, required this.binding, required this.workload, this.schedule = const TeacherResource<TeacherScheduleSnapshot>.idle(), this.changes = const TeacherResource<List<ScheduleChange>>.idle(), this.rating = const TeacherResource<TeacherProfile>.idle(), this.navigation = const TeacherScheduleNavigation.idle()}): super._();


@override final  DateTime now;
@override final  DateTime day;
@override final  TeacherDashboardBinding binding;
@override final  TeacherWorkload workload;
@override@JsonKey() final  TeacherResource<TeacherScheduleSnapshot> schedule;
@override@JsonKey() final  TeacherResource<List<ScheduleChange>> changes;
@override@JsonKey() final  TeacherResource<TeacherProfile> rating;
@override@JsonKey() final  TeacherScheduleNavigation navigation;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherDashboardStateCopyWith<_TeacherDashboardState> get copyWith => __$TeacherDashboardStateCopyWithImpl<_TeacherDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherDashboardState&&(identical(other.now, now) || other.now == now)&&(identical(other.day, day) || other.day == day)&&(identical(other.binding, binding) || other.binding == binding)&&(identical(other.workload, workload) || other.workload == workload)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.changes, changes) || other.changes == changes)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.navigation, navigation) || other.navigation == navigation));
}


@override
int get hashCode => Object.hash(runtimeType,now,day,binding,workload,schedule,changes,rating,navigation);

@override
String toString() {
  return 'TeacherDashboardState(now: $now, day: $day, binding: $binding, workload: $workload, schedule: $schedule, changes: $changes, rating: $rating, navigation: $navigation)';
}


}

/// @nodoc
abstract mixin class _$TeacherDashboardStateCopyWith<$Res> implements $TeacherDashboardStateCopyWith<$Res> {
  factory _$TeacherDashboardStateCopyWith(_TeacherDashboardState value, $Res Function(_TeacherDashboardState) _then) = __$TeacherDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime now, DateTime day, TeacherDashboardBinding binding, TeacherWorkload workload, TeacherResource<TeacherScheduleSnapshot> schedule, TeacherResource<List<ScheduleChange>> changes, TeacherResource<TeacherProfile> rating, TeacherScheduleNavigation navigation
});


@override $TeacherDashboardBindingCopyWith<$Res> get binding;@override $TeacherWorkloadCopyWith<$Res> get workload;@override $TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res> get schedule;@override $TeacherResourceCopyWith<List<ScheduleChange>, $Res> get changes;@override $TeacherResourceCopyWith<TeacherProfile, $Res> get rating;@override $TeacherScheduleNavigationCopyWith<$Res> get navigation;

}
/// @nodoc
class __$TeacherDashboardStateCopyWithImpl<$Res>
    implements _$TeacherDashboardStateCopyWith<$Res> {
  __$TeacherDashboardStateCopyWithImpl(this._self, this._then);

  final _TeacherDashboardState _self;
  final $Res Function(_TeacherDashboardState) _then;

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? now = null,Object? day = null,Object? binding = null,Object? workload = null,Object? schedule = null,Object? changes = null,Object? rating = null,Object? navigation = null,}) {
  return _then(_TeacherDashboardState(
now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,binding: null == binding ? _self.binding : binding // ignore: cast_nullable_to_non_nullable
as TeacherDashboardBinding,workload: null == workload ? _self.workload : workload // ignore: cast_nullable_to_non_nullable
as TeacherWorkload,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as TeacherResource<TeacherScheduleSnapshot>,changes: null == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as TeacherResource<List<ScheduleChange>>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as TeacherResource<TeacherProfile>,navigation: null == navigation ? _self.navigation : navigation // ignore: cast_nullable_to_non_nullable
as TeacherScheduleNavigation,
  ));
}

/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherDashboardBindingCopyWith<$Res> get binding {

  return $TeacherDashboardBindingCopyWith<$Res>(_self.binding, (value) {
    return _then(_self.copyWith(binding: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherWorkloadCopyWith<$Res> get workload {

  return $TeacherWorkloadCopyWith<$Res>(_self.workload, (value) {
    return _then(_self.copyWith(workload: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res> get schedule {

  return $TeacherResourceCopyWith<TeacherScheduleSnapshot, $Res>(_self.schedule, (value) {
    return _then(_self.copyWith(schedule: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<List<ScheduleChange>, $Res> get changes {

  return $TeacherResourceCopyWith<List<ScheduleChange>, $Res>(_self.changes, (value) {
    return _then(_self.copyWith(changes: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherResourceCopyWith<TeacherProfile, $Res> get rating {

  return $TeacherResourceCopyWith<TeacherProfile, $Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}/// Create a copy of TeacherDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherScheduleNavigationCopyWith<$Res> get navigation {

  return $TeacherScheduleNavigationCopyWith<$Res>(_self.navigation, (value) {
    return _then(_self.copyWith(navigation: value));
  });
}
}

// dart format on
