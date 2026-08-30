// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_reaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonReactionResponse {

 Map<String, int> get counts; String? get userReaction;
/// Create a copy of LessonReactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonReactionResponseCopyWith<LessonReactionResponse> get copyWith => _$LessonReactionResponseCopyWithImpl<LessonReactionResponse>(this as LessonReactionResponse, _$identity);

  /// Serializes this LessonReactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonReactionResponse&&const DeepCollectionEquality().equals(other.counts, counts)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(counts),userReaction);

@override
String toString() {
  return 'LessonReactionResponse(counts: $counts, userReaction: $userReaction)';
}


}

/// @nodoc
abstract mixin class $LessonReactionResponseCopyWith<$Res>  {
  factory $LessonReactionResponseCopyWith(LessonReactionResponse value, $Res Function(LessonReactionResponse) _then) = _$LessonReactionResponseCopyWithImpl;
@useResult
$Res call({
 Map<String, int> counts, String? userReaction
});




}
/// @nodoc
class _$LessonReactionResponseCopyWithImpl<$Res>
    implements $LessonReactionResponseCopyWith<$Res> {
  _$LessonReactionResponseCopyWithImpl(this._self, this._then);

  final LessonReactionResponse _self;
  final $Res Function(LessonReactionResponse) _then;

/// Create a copy of LessonReactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? counts = null,Object? userReaction = freezed,}) {
  return _then(_self.copyWith(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonReactionResponse].
extension LessonReactionResponsePatterns on LessonReactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonReactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonReactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonReactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _LessonReactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonReactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LessonReactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> counts,  String? userReaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonReactionResponse() when $default != null:
return $default(_that.counts,_that.userReaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> counts,  String? userReaction)  $default,) {final _that = this;
switch (_that) {
case _LessonReactionResponse():
return $default(_that.counts,_that.userReaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> counts,  String? userReaction)?  $default,) {final _that = this;
switch (_that) {
case _LessonReactionResponse() when $default != null:
return $default(_that.counts,_that.userReaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonReactionResponse implements LessonReactionResponse {
  const _LessonReactionResponse({required final  Map<String, int> counts, this.userReaction}): _counts = counts;
  factory _LessonReactionResponse.fromJson(Map<String, dynamic> json) => _$LessonReactionResponseFromJson(json);

 final  Map<String, int> _counts;
@override Map<String, int> get counts {
  if (_counts is EqualUnmodifiableMapView) return _counts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_counts);
}

@override final  String? userReaction;

/// Create a copy of LessonReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonReactionResponseCopyWith<_LessonReactionResponse> get copyWith => __$LessonReactionResponseCopyWithImpl<_LessonReactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonReactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonReactionResponse&&const DeepCollectionEquality().equals(other._counts, _counts)&&(identical(other.userReaction, userReaction) || other.userReaction == userReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_counts),userReaction);

@override
String toString() {
  return 'LessonReactionResponse(counts: $counts, userReaction: $userReaction)';
}


}

/// @nodoc
abstract mixin class _$LessonReactionResponseCopyWith<$Res> implements $LessonReactionResponseCopyWith<$Res> {
  factory _$LessonReactionResponseCopyWith(_LessonReactionResponse value, $Res Function(_LessonReactionResponse) _then) = __$LessonReactionResponseCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> counts, String? userReaction
});




}
/// @nodoc
class __$LessonReactionResponseCopyWithImpl<$Res>
    implements _$LessonReactionResponseCopyWith<$Res> {
  __$LessonReactionResponseCopyWithImpl(this._self, this._then);

  final _LessonReactionResponse _self;
  final $Res Function(_LessonReactionResponse) _then;

/// Create a copy of LessonReactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? counts = null,Object? userReaction = freezed,}) {
  return _then(_LessonReactionResponse(
counts: null == counts ? _self._counts : counts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,userReaction: freezed == userReaction ? _self.userReaction : userReaction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
