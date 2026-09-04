// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ui_preferences_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UiPreferencesState {

@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson) Set<HomeSection> get enabledSections; bool get showLessonReactions; bool get showPromoBanners; Map<String, int> get lessonTypeColors;
/// Create a copy of UiPreferencesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UiPreferencesStateCopyWith<UiPreferencesState> get copyWith => _$UiPreferencesStateCopyWithImpl<UiPreferencesState>(this as UiPreferencesState, _$identity);

  /// Serializes this UiPreferencesState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UiPreferencesState&&const DeepCollectionEquality().equals(other.enabledSections, enabledSections)&&(identical(other.showLessonReactions, showLessonReactions) || other.showLessonReactions == showLessonReactions)&&(identical(other.showPromoBanners, showPromoBanners) || other.showPromoBanners == showPromoBanners)&&const DeepCollectionEquality().equals(other.lessonTypeColors, lessonTypeColors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(enabledSections),showLessonReactions,showPromoBanners,const DeepCollectionEquality().hash(lessonTypeColors));

@override
String toString() {
  return 'UiPreferencesState(enabledSections: $enabledSections, showLessonReactions: $showLessonReactions, showPromoBanners: $showPromoBanners, lessonTypeColors: $lessonTypeColors)';
}


}

/// @nodoc
abstract mixin class $UiPreferencesStateCopyWith<$Res>  {
  factory $UiPreferencesStateCopyWith(UiPreferencesState value, $Res Function(UiPreferencesState) _then) = _$UiPreferencesStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson) Set<HomeSection> enabledSections, bool showLessonReactions, bool showPromoBanners, Map<String, int> lessonTypeColors
});




}
/// @nodoc
class _$UiPreferencesStateCopyWithImpl<$Res>
    implements $UiPreferencesStateCopyWith<$Res> {
  _$UiPreferencesStateCopyWithImpl(this._self, this._then);

  final UiPreferencesState _self;
  final $Res Function(UiPreferencesState) _then;

/// Create a copy of UiPreferencesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabledSections = null,Object? showLessonReactions = null,Object? showPromoBanners = null,Object? lessonTypeColors = null,}) {
  return _then(_self.copyWith(
enabledSections: null == enabledSections ? _self.enabledSections : enabledSections // ignore: cast_nullable_to_non_nullable
as Set<HomeSection>,showLessonReactions: null == showLessonReactions ? _self.showLessonReactions : showLessonReactions // ignore: cast_nullable_to_non_nullable
as bool,showPromoBanners: null == showPromoBanners ? _self.showPromoBanners : showPromoBanners // ignore: cast_nullable_to_non_nullable
as bool,lessonTypeColors: null == lessonTypeColors ? _self.lessonTypeColors : lessonTypeColors // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [UiPreferencesState].
extension UiPreferencesStatePatterns on UiPreferencesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UiPreferencesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UiPreferencesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UiPreferencesState value)  $default,){
final _that = this;
switch (_that) {
case _UiPreferencesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UiPreferencesState value)?  $default,){
final _that = this;
switch (_that) {
case _UiPreferencesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson)  Set<HomeSection> enabledSections,  bool showLessonReactions,  bool showPromoBanners,  Map<String, int> lessonTypeColors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UiPreferencesState() when $default != null:
return $default(_that.enabledSections,_that.showLessonReactions,_that.showPromoBanners,_that.lessonTypeColors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson)  Set<HomeSection> enabledSections,  bool showLessonReactions,  bool showPromoBanners,  Map<String, int> lessonTypeColors)  $default,) {final _that = this;
switch (_that) {
case _UiPreferencesState():
return $default(_that.enabledSections,_that.showLessonReactions,_that.showPromoBanners,_that.lessonTypeColors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson)  Set<HomeSection> enabledSections,  bool showLessonReactions,  bool showPromoBanners,  Map<String, int> lessonTypeColors)?  $default,) {final _that = this;
switch (_that) {
case _UiPreferencesState() when $default != null:
return $default(_that.enabledSections,_that.showLessonReactions,_that.showPromoBanners,_that.lessonTypeColors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UiPreferencesState extends UiPreferencesState {
  const _UiPreferencesState({@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson) final  Set<HomeSection> enabledSections = kAllHomeSections, this.showLessonReactions = true, this.showPromoBanners = true, final  Map<String, int> lessonTypeColors = kDefaultLessonTypeColors}): _enabledSections = enabledSections,_lessonTypeColors = lessonTypeColors,super._();
  factory _UiPreferencesState.fromJson(Map<String, dynamic> json) => _$UiPreferencesStateFromJson(json);

 final  Set<HomeSection> _enabledSections;
@override@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson) Set<HomeSection> get enabledSections {
  if (_enabledSections is EqualUnmodifiableSetView) return _enabledSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_enabledSections);
}

@override@JsonKey() final  bool showLessonReactions;
@override@JsonKey() final  bool showPromoBanners;
 final  Map<String, int> _lessonTypeColors;
@override@JsonKey() Map<String, int> get lessonTypeColors {
  if (_lessonTypeColors is EqualUnmodifiableMapView) return _lessonTypeColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_lessonTypeColors);
}


/// Create a copy of UiPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UiPreferencesStateCopyWith<_UiPreferencesState> get copyWith => __$UiPreferencesStateCopyWithImpl<_UiPreferencesState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UiPreferencesStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UiPreferencesState&&const DeepCollectionEquality().equals(other._enabledSections, _enabledSections)&&(identical(other.showLessonReactions, showLessonReactions) || other.showLessonReactions == showLessonReactions)&&(identical(other.showPromoBanners, showPromoBanners) || other.showPromoBanners == showPromoBanners)&&const DeepCollectionEquality().equals(other._lessonTypeColors, _lessonTypeColors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_enabledSections),showLessonReactions,showPromoBanners,const DeepCollectionEquality().hash(_lessonTypeColors));

@override
String toString() {
  return 'UiPreferencesState(enabledSections: $enabledSections, showLessonReactions: $showLessonReactions, showPromoBanners: $showPromoBanners, lessonTypeColors: $lessonTypeColors)';
}


}

/// @nodoc
abstract mixin class _$UiPreferencesStateCopyWith<$Res> implements $UiPreferencesStateCopyWith<$Res> {
  factory _$UiPreferencesStateCopyWith(_UiPreferencesState value, $Res Function(_UiPreferencesState) _then) = __$UiPreferencesStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _homeSectionsFromJson, toJson: _homeSectionsToJson) Set<HomeSection> enabledSections, bool showLessonReactions, bool showPromoBanners, Map<String, int> lessonTypeColors
});




}
/// @nodoc
class __$UiPreferencesStateCopyWithImpl<$Res>
    implements _$UiPreferencesStateCopyWith<$Res> {
  __$UiPreferencesStateCopyWithImpl(this._self, this._then);

  final _UiPreferencesState _self;
  final $Res Function(_UiPreferencesState) _then;

/// Create a copy of UiPreferencesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabledSections = null,Object? showLessonReactions = null,Object? showPromoBanners = null,Object? lessonTypeColors = null,}) {
  return _then(_UiPreferencesState(
enabledSections: null == enabledSections ? _self._enabledSections : enabledSections // ignore: cast_nullable_to_non_nullable
as Set<HomeSection>,showLessonReactions: null == showLessonReactions ? _self.showLessonReactions : showLessonReactions // ignore: cast_nullable_to_non_nullable
as bool,showPromoBanners: null == showPromoBanners ? _self.showPromoBanners : showPromoBanners // ignore: cast_nullable_to_non_nullable
as bool,lessonTypeColors: null == lessonTypeColors ? _self._lessonTypeColors : lessonTypeColors // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
