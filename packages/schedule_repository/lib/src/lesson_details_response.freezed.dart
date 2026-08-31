// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LessonDetailsResponse {

 LessonReactionResponse get reactions; List<LessonMaterial> get materials; List<LessonReview> get reviews;
/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonDetailsResponseCopyWith<LessonDetailsResponse> get copyWith => _$LessonDetailsResponseCopyWithImpl<LessonDetailsResponse>(this as LessonDetailsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonDetailsResponse&&(identical(other.reactions, reactions) || other.reactions == reactions)&&const DeepCollectionEquality().equals(other.materials, materials)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}


@override
int get hashCode => Object.hash(runtimeType,reactions,const DeepCollectionEquality().hash(materials),const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'LessonDetailsResponse(reactions: $reactions, materials: $materials, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $LessonDetailsResponseCopyWith<$Res>  {
  factory $LessonDetailsResponseCopyWith(LessonDetailsResponse value, $Res Function(LessonDetailsResponse) _then) = _$LessonDetailsResponseCopyWithImpl;
@useResult
$Res call({
 LessonReactionResponse reactions, List<LessonMaterial> materials, List<LessonReview> reviews
});


$LessonReactionResponseCopyWith<$Res> get reactions;

}
/// @nodoc
class _$LessonDetailsResponseCopyWithImpl<$Res>
    implements $LessonDetailsResponseCopyWith<$Res> {
  _$LessonDetailsResponseCopyWithImpl(this._self, this._then);

  final LessonDetailsResponse _self;
  final $Res Function(LessonDetailsResponse) _then;

/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reactions = null,Object? materials = null,Object? reviews = null,}) {
  return _then(_self.copyWith(
reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as LessonReactionResponse,materials: null == materials ? _self.materials : materials // ignore: cast_nullable_to_non_nullable
as List<LessonMaterial>,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<LessonReview>,
  ));
}
/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonReactionResponseCopyWith<$Res> get reactions {

  return $LessonReactionResponseCopyWith<$Res>(_self.reactions, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonDetailsResponse].
extension LessonDetailsResponsePatterns on LessonDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _LessonDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LessonDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonReactionResponse reactions,  List<LessonMaterial> materials,  List<LessonReview> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonDetailsResponse() when $default != null:
return $default(_that.reactions,_that.materials,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonReactionResponse reactions,  List<LessonMaterial> materials,  List<LessonReview> reviews)  $default,) {final _that = this;
switch (_that) {
case _LessonDetailsResponse():
return $default(_that.reactions,_that.materials,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonReactionResponse reactions,  List<LessonMaterial> materials,  List<LessonReview> reviews)?  $default,) {final _that = this;
switch (_that) {
case _LessonDetailsResponse() when $default != null:
return $default(_that.reactions,_that.materials,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc


class _LessonDetailsResponse implements LessonDetailsResponse {
  const _LessonDetailsResponse({required this.reactions, required final  List<LessonMaterial> materials, required final  List<LessonReview> reviews}): _materials = materials,_reviews = reviews;


@override final  LessonReactionResponse reactions;
 final  List<LessonMaterial> _materials;
@override List<LessonMaterial> get materials {
  if (_materials is EqualUnmodifiableListView) return _materials;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_materials);
}

 final  List<LessonReview> _reviews;
@override List<LessonReview> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonDetailsResponseCopyWith<_LessonDetailsResponse> get copyWith => __$LessonDetailsResponseCopyWithImpl<_LessonDetailsResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonDetailsResponse&&(identical(other.reactions, reactions) || other.reactions == reactions)&&const DeepCollectionEquality().equals(other._materials, _materials)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}


@override
int get hashCode => Object.hash(runtimeType,reactions,const DeepCollectionEquality().hash(_materials),const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'LessonDetailsResponse(reactions: $reactions, materials: $materials, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$LessonDetailsResponseCopyWith<$Res> implements $LessonDetailsResponseCopyWith<$Res> {
  factory _$LessonDetailsResponseCopyWith(_LessonDetailsResponse value, $Res Function(_LessonDetailsResponse) _then) = __$LessonDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 LessonReactionResponse reactions, List<LessonMaterial> materials, List<LessonReview> reviews
});


@override $LessonReactionResponseCopyWith<$Res> get reactions;

}
/// @nodoc
class __$LessonDetailsResponseCopyWithImpl<$Res>
    implements _$LessonDetailsResponseCopyWith<$Res> {
  __$LessonDetailsResponseCopyWithImpl(this._self, this._then);

  final _LessonDetailsResponse _self;
  final $Res Function(_LessonDetailsResponse) _then;

/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reactions = null,Object? materials = null,Object? reviews = null,}) {
  return _then(_LessonDetailsResponse(
reactions: null == reactions ? _self.reactions : reactions // ignore: cast_nullable_to_non_nullable
as LessonReactionResponse,materials: null == materials ? _self._materials : materials // ignore: cast_nullable_to_non_nullable
as List<LessonMaterial>,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<LessonReview>,
  ));
}

/// Create a copy of LessonDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonReactionResponseCopyWith<$Res> get reactions {

  return $LessonReactionResponseCopyWith<$Res>(_self.reactions, (value) {
    return _then(_self.copyWith(reactions: value));
  });
}
}

// dart format on
