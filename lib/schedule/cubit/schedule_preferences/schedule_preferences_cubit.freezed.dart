// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_preferences_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchedulePreferencesState {

 bool get isMiniature; bool get showEmptyLessons; bool get isListModeEnabled; bool get showCommentsIndicators; bool get showLectures; bool get showSeminars; bool get showLabs; bool get showExams; bool get showGaps; bool get collapsePast; List<String> get hiddenSubjects;
/// Create a copy of SchedulePreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePreferencesStateCopyWith<SchedulePreferencesState> get copyWith => _$SchedulePreferencesStateCopyWithImpl<SchedulePreferencesState>(this as SchedulePreferencesState, _$identity);

  /// Serializes this SchedulePreferencesState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePreferencesState&&(identical(other.isMiniature, isMiniature) || other.isMiniature == isMiniature)&&(identical(other.showEmptyLessons, showEmptyLessons) || other.showEmptyLessons == showEmptyLessons)&&(identical(other.isListModeEnabled, isListModeEnabled) || other.isListModeEnabled == isListModeEnabled)&&(identical(other.showCommentsIndicators, showCommentsIndicators) || other.showCommentsIndicators == showCommentsIndicators)&&(identical(other.showLectures, showLectures) || other.showLectures == showLectures)&&(identical(other.showSeminars, showSeminars) || other.showSeminars == showSeminars)&&(identical(other.showLabs, showLabs) || other.showLabs == showLabs)&&(identical(other.showExams, showExams) || other.showExams == showExams)&&(identical(other.showGaps, showGaps) || other.showGaps == showGaps)&&(identical(other.collapsePast, collapsePast) || other.collapsePast == collapsePast)&&const DeepCollectionEquality().equals(other.hiddenSubjects, hiddenSubjects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isMiniature,showEmptyLessons,isListModeEnabled,showCommentsIndicators,showLectures,showSeminars,showLabs,showExams,showGaps,collapsePast,const DeepCollectionEquality().hash(hiddenSubjects));

@override
String toString() {
  return 'SchedulePreferencesState(isMiniature: $isMiniature, showEmptyLessons: $showEmptyLessons, isListModeEnabled: $isListModeEnabled, showCommentsIndicators: $showCommentsIndicators, showLectures: $showLectures, showSeminars: $showSeminars, showLabs: $showLabs, showExams: $showExams, showGaps: $showGaps, collapsePast: $collapsePast, hiddenSubjects: $hiddenSubjects)';
}


}

/// @nodoc
abstract mixin class $SchedulePreferencesStateCopyWith<$Res>  {
  factory $SchedulePreferencesStateCopyWith(SchedulePreferencesState value, $Res Function(SchedulePreferencesState) _then) = _$SchedulePreferencesStateCopyWithImpl;
@useResult
$Res call({
 bool isMiniature, bool showEmptyLessons, bool isListModeEnabled, bool showCommentsIndicators, bool showLectures, bool showSeminars, bool showLabs, bool showExams, bool showGaps, bool collapsePast, List<String> hiddenSubjects
});




}
/// @nodoc
class _$SchedulePreferencesStateCopyWithImpl<$Res>
    implements $SchedulePreferencesStateCopyWith<$Res> {
  _$SchedulePreferencesStateCopyWithImpl(this._self, this._then);

  final SchedulePreferencesState _self;
  final $Res Function(SchedulePreferencesState) _then;

/// Create a copy of SchedulePreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isMiniature = null,Object? showEmptyLessons = null,Object? isListModeEnabled = null,Object? showCommentsIndicators = null,Object? showLectures = null,Object? showSeminars = null,Object? showLabs = null,Object? showExams = null,Object? showGaps = null,Object? collapsePast = null,Object? hiddenSubjects = null,}) {
  return _then(_self.copyWith(
isMiniature: null == isMiniature ? _self.isMiniature : isMiniature // ignore: cast_nullable_to_non_nullable
as bool,showEmptyLessons: null == showEmptyLessons ? _self.showEmptyLessons : showEmptyLessons // ignore: cast_nullable_to_non_nullable
as bool,isListModeEnabled: null == isListModeEnabled ? _self.isListModeEnabled : isListModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,showCommentsIndicators: null == showCommentsIndicators ? _self.showCommentsIndicators : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
as bool,showLectures: null == showLectures ? _self.showLectures : showLectures // ignore: cast_nullable_to_non_nullable
as bool,showSeminars: null == showSeminars ? _self.showSeminars : showSeminars // ignore: cast_nullable_to_non_nullable
as bool,showLabs: null == showLabs ? _self.showLabs : showLabs // ignore: cast_nullable_to_non_nullable
as bool,showExams: null == showExams ? _self.showExams : showExams // ignore: cast_nullable_to_non_nullable
as bool,showGaps: null == showGaps ? _self.showGaps : showGaps // ignore: cast_nullable_to_non_nullable
as bool,collapsePast: null == collapsePast ? _self.collapsePast : collapsePast // ignore: cast_nullable_to_non_nullable
as bool,hiddenSubjects: null == hiddenSubjects ? _self.hiddenSubjects : hiddenSubjects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePreferencesState].
extension SchedulePreferencesStatePatterns on SchedulePreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePreferencesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePreferencesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePreferencesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isMiniature,  bool showEmptyLessons,  bool isListModeEnabled,  bool showCommentsIndicators,  bool showLectures,  bool showSeminars,  bool showLabs,  bool showExams,  bool showGaps,  bool collapsePast,  List<String> hiddenSubjects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePreferencesState() when $default != null:
return $default(_that.isMiniature,_that.showEmptyLessons,_that.isListModeEnabled,_that.showCommentsIndicators,_that.showLectures,_that.showSeminars,_that.showLabs,_that.showExams,_that.showGaps,_that.collapsePast,_that.hiddenSubjects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isMiniature,  bool showEmptyLessons,  bool isListModeEnabled,  bool showCommentsIndicators,  bool showLectures,  bool showSeminars,  bool showLabs,  bool showExams,  bool showGaps,  bool collapsePast,  List<String> hiddenSubjects)  $default,) {final _that = this;
switch (_that) {
case _SchedulePreferencesState():
return $default(_that.isMiniature,_that.showEmptyLessons,_that.isListModeEnabled,_that.showCommentsIndicators,_that.showLectures,_that.showSeminars,_that.showLabs,_that.showExams,_that.showGaps,_that.collapsePast,_that.hiddenSubjects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isMiniature,  bool showEmptyLessons,  bool isListModeEnabled,  bool showCommentsIndicators,  bool showLectures,  bool showSeminars,  bool showLabs,  bool showExams,  bool showGaps,  bool collapsePast,  List<String> hiddenSubjects)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePreferencesState() when $default != null:
return $default(_that.isMiniature,_that.showEmptyLessons,_that.isListModeEnabled,_that.showCommentsIndicators,_that.showLectures,_that.showSeminars,_that.showLabs,_that.showExams,_that.showGaps,_that.collapsePast,_that.hiddenSubjects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePreferencesState implements SchedulePreferencesState {
  const _SchedulePreferencesState({this.isMiniature = false, this.showEmptyLessons = false, this.isListModeEnabled = false, this.showCommentsIndicators = true, this.showLectures = true, this.showSeminars = true, this.showLabs = true, this.showExams = true, this.showGaps = true, this.collapsePast = true, final  List<String> hiddenSubjects = const <String>[]}): _hiddenSubjects = hiddenSubjects;
  factory _SchedulePreferencesState.fromJson(Map<String, dynamic> json) => _$SchedulePreferencesStateFromJson(json);

@override@JsonKey() final  bool isMiniature;
@override@JsonKey() final  bool showEmptyLessons;
@override@JsonKey() final  bool isListModeEnabled;
@override@JsonKey() final  bool showCommentsIndicators;
@override@JsonKey() final  bool showLectures;
@override@JsonKey() final  bool showSeminars;
@override@JsonKey() final  bool showLabs;
@override@JsonKey() final  bool showExams;
@override@JsonKey() final  bool showGaps;
@override@JsonKey() final  bool collapsePast;
 final  List<String> _hiddenSubjects;
@override@JsonKey() List<String> get hiddenSubjects {
  if (_hiddenSubjects is EqualUnmodifiableListView) return _hiddenSubjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hiddenSubjects);
}


/// Create a copy of SchedulePreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePreferencesStateCopyWith<_SchedulePreferencesState> get copyWith => __$SchedulePreferencesStateCopyWithImpl<_SchedulePreferencesState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePreferencesStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePreferencesState&&(identical(other.isMiniature, isMiniature) || other.isMiniature == isMiniature)&&(identical(other.showEmptyLessons, showEmptyLessons) || other.showEmptyLessons == showEmptyLessons)&&(identical(other.isListModeEnabled, isListModeEnabled) || other.isListModeEnabled == isListModeEnabled)&&(identical(other.showCommentsIndicators, showCommentsIndicators) || other.showCommentsIndicators == showCommentsIndicators)&&(identical(other.showLectures, showLectures) || other.showLectures == showLectures)&&(identical(other.showSeminars, showSeminars) || other.showSeminars == showSeminars)&&(identical(other.showLabs, showLabs) || other.showLabs == showLabs)&&(identical(other.showExams, showExams) || other.showExams == showExams)&&(identical(other.showGaps, showGaps) || other.showGaps == showGaps)&&(identical(other.collapsePast, collapsePast) || other.collapsePast == collapsePast)&&const DeepCollectionEquality().equals(other._hiddenSubjects, _hiddenSubjects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isMiniature,showEmptyLessons,isListModeEnabled,showCommentsIndicators,showLectures,showSeminars,showLabs,showExams,showGaps,collapsePast,const DeepCollectionEquality().hash(_hiddenSubjects));

@override
String toString() {
  return 'SchedulePreferencesState(isMiniature: $isMiniature, showEmptyLessons: $showEmptyLessons, isListModeEnabled: $isListModeEnabled, showCommentsIndicators: $showCommentsIndicators, showLectures: $showLectures, showSeminars: $showSeminars, showLabs: $showLabs, showExams: $showExams, showGaps: $showGaps, collapsePast: $collapsePast, hiddenSubjects: $hiddenSubjects)';
}


}

/// @nodoc
abstract mixin class _$SchedulePreferencesStateCopyWith<$Res> implements $SchedulePreferencesStateCopyWith<$Res> {
  factory _$SchedulePreferencesStateCopyWith(_SchedulePreferencesState value, $Res Function(_SchedulePreferencesState) _then) = __$SchedulePreferencesStateCopyWithImpl;
@override @useResult
$Res call({
 bool isMiniature, bool showEmptyLessons, bool isListModeEnabled, bool showCommentsIndicators, bool showLectures, bool showSeminars, bool showLabs, bool showExams, bool showGaps, bool collapsePast, List<String> hiddenSubjects
});




}
/// @nodoc
class __$SchedulePreferencesStateCopyWithImpl<$Res>
    implements _$SchedulePreferencesStateCopyWith<$Res> {
  __$SchedulePreferencesStateCopyWithImpl(this._self, this._then);

  final _SchedulePreferencesState _self;
  final $Res Function(_SchedulePreferencesState) _then;

/// Create a copy of SchedulePreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isMiniature = null,Object? showEmptyLessons = null,Object? isListModeEnabled = null,Object? showCommentsIndicators = null,Object? showLectures = null,Object? showSeminars = null,Object? showLabs = null,Object? showExams = null,Object? showGaps = null,Object? collapsePast = null,Object? hiddenSubjects = null,}) {
  return _then(_SchedulePreferencesState(
isMiniature: null == isMiniature ? _self.isMiniature : isMiniature // ignore: cast_nullable_to_non_nullable
as bool,showEmptyLessons: null == showEmptyLessons ? _self.showEmptyLessons : showEmptyLessons // ignore: cast_nullable_to_non_nullable
as bool,isListModeEnabled: null == isListModeEnabled ? _self.isListModeEnabled : isListModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,showCommentsIndicators: null == showCommentsIndicators ? _self.showCommentsIndicators : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
as bool,showLectures: null == showLectures ? _self.showLectures : showLectures // ignore: cast_nullable_to_non_nullable
as bool,showSeminars: null == showSeminars ? _self.showSeminars : showSeminars // ignore: cast_nullable_to_non_nullable
as bool,showLabs: null == showLabs ? _self.showLabs : showLabs // ignore: cast_nullable_to_non_nullable
as bool,showExams: null == showExams ? _self.showExams : showExams // ignore: cast_nullable_to_non_nullable
as bool,showGaps: null == showGaps ? _self.showGaps : showGaps // ignore: cast_nullable_to_non_nullable
as bool,collapsePast: null == collapsePast ? _self.collapsePast : collapsePast // ignore: cast_nullable_to_non_nullable
as bool,hiddenSubjects: null == hiddenSubjects ? _self._hiddenSubjects : hiddenSubjects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
