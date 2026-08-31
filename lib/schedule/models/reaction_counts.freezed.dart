// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_counts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReactionCounts {

 int get fire; int get brain; int get love; int get sad; int get flushed; int get sick; int get poo; int get thinking; int get sleepy; int get skull; int get mindblown; int get respect;
/// Create a copy of ReactionCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReactionCountsCopyWith<ReactionCounts> get copyWith => _$ReactionCountsCopyWithImpl<ReactionCounts>(this as ReactionCounts, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReactionCounts&&(identical(other.fire, fire) || other.fire == fire)&&(identical(other.brain, brain) || other.brain == brain)&&(identical(other.love, love) || other.love == love)&&(identical(other.sad, sad) || other.sad == sad)&&(identical(other.flushed, flushed) || other.flushed == flushed)&&(identical(other.sick, sick) || other.sick == sick)&&(identical(other.poo, poo) || other.poo == poo)&&(identical(other.thinking, thinking) || other.thinking == thinking)&&(identical(other.sleepy, sleepy) || other.sleepy == sleepy)&&(identical(other.skull, skull) || other.skull == skull)&&(identical(other.mindblown, mindblown) || other.mindblown == mindblown)&&(identical(other.respect, respect) || other.respect == respect));
}


@override
int get hashCode => Object.hash(runtimeType,fire,brain,love,sad,flushed,sick,poo,thinking,sleepy,skull,mindblown,respect);

@override
String toString() {
  return 'ReactionCounts(fire: $fire, brain: $brain, love: $love, sad: $sad, flushed: $flushed, sick: $sick, poo: $poo, thinking: $thinking, sleepy: $sleepy, skull: $skull, mindblown: $mindblown, respect: $respect)';
}


}

/// @nodoc
abstract mixin class $ReactionCountsCopyWith<$Res>  {
  factory $ReactionCountsCopyWith(ReactionCounts value, $Res Function(ReactionCounts) _then) = _$ReactionCountsCopyWithImpl;
@useResult
$Res call({
 int fire, int brain, int love, int sad, int flushed, int sick, int poo, int thinking, int sleepy, int skull, int mindblown, int respect
});




}
/// @nodoc
class _$ReactionCountsCopyWithImpl<$Res>
    implements $ReactionCountsCopyWith<$Res> {
  _$ReactionCountsCopyWithImpl(this._self, this._then);

  final ReactionCounts _self;
  final $Res Function(ReactionCounts) _then;

/// Create a copy of ReactionCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fire = null,Object? brain = null,Object? love = null,Object? sad = null,Object? flushed = null,Object? sick = null,Object? poo = null,Object? thinking = null,Object? sleepy = null,Object? skull = null,Object? mindblown = null,Object? respect = null,}) {
  return _then(_self.copyWith(
fire: null == fire ? _self.fire : fire // ignore: cast_nullable_to_non_nullable
as int,brain: null == brain ? _self.brain : brain // ignore: cast_nullable_to_non_nullable
as int,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as int,sad: null == sad ? _self.sad : sad // ignore: cast_nullable_to_non_nullable
as int,flushed: null == flushed ? _self.flushed : flushed // ignore: cast_nullable_to_non_nullable
as int,sick: null == sick ? _self.sick : sick // ignore: cast_nullable_to_non_nullable
as int,poo: null == poo ? _self.poo : poo // ignore: cast_nullable_to_non_nullable
as int,thinking: null == thinking ? _self.thinking : thinking // ignore: cast_nullable_to_non_nullable
as int,sleepy: null == sleepy ? _self.sleepy : sleepy // ignore: cast_nullable_to_non_nullable
as int,skull: null == skull ? _self.skull : skull // ignore: cast_nullable_to_non_nullable
as int,mindblown: null == mindblown ? _self.mindblown : mindblown // ignore: cast_nullable_to_non_nullable
as int,respect: null == respect ? _self.respect : respect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReactionCounts].
extension ReactionCountsPatterns on ReactionCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReactionCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReactionCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReactionCounts value)  $default,){
final _that = this;
switch (_that) {
case _ReactionCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReactionCounts value)?  $default,){
final _that = this;
switch (_that) {
case _ReactionCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fire,  int brain,  int love,  int sad,  int flushed,  int sick,  int poo,  int thinking,  int sleepy,  int skull,  int mindblown,  int respect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReactionCounts() when $default != null:
return $default(_that.fire,_that.brain,_that.love,_that.sad,_that.flushed,_that.sick,_that.poo,_that.thinking,_that.sleepy,_that.skull,_that.mindblown,_that.respect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fire,  int brain,  int love,  int sad,  int flushed,  int sick,  int poo,  int thinking,  int sleepy,  int skull,  int mindblown,  int respect)  $default,) {final _that = this;
switch (_that) {
case _ReactionCounts():
return $default(_that.fire,_that.brain,_that.love,_that.sad,_that.flushed,_that.sick,_that.poo,_that.thinking,_that.sleepy,_that.skull,_that.mindblown,_that.respect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fire,  int brain,  int love,  int sad,  int flushed,  int sick,  int poo,  int thinking,  int sleepy,  int skull,  int mindblown,  int respect)?  $default,) {final _that = this;
switch (_that) {
case _ReactionCounts() when $default != null:
return $default(_that.fire,_that.brain,_that.love,_that.sad,_that.flushed,_that.sick,_that.poo,_that.thinking,_that.sleepy,_that.skull,_that.mindblown,_that.respect);case _:
  return null;

}
}

}

/// @nodoc


class _ReactionCounts extends ReactionCounts {
  const _ReactionCounts({this.fire = 0, this.brain = 0, this.love = 0, this.sad = 0, this.flushed = 0, this.sick = 0, this.poo = 0, this.thinking = 0, this.sleepy = 0, this.skull = 0, this.mindblown = 0, this.respect = 0}): assert(fire >= 0, 'fire must be non-negative'),assert(brain >= 0, 'brain must be non-negative'),assert(love >= 0, 'love must be non-negative'),assert(sad >= 0, 'sad must be non-negative'),assert(flushed >= 0, 'flushed must be non-negative'),assert(sick >= 0, 'sick must be non-negative'),assert(poo >= 0, 'poo must be non-negative'),assert(thinking >= 0, 'thinking must be non-negative'),assert(sleepy >= 0, 'sleepy must be non-negative'),assert(skull >= 0, 'skull must be non-negative'),assert(mindblown >= 0, 'mindblown must be non-negative'),assert(respect >= 0, 'respect must be non-negative'),super._();


@override@JsonKey() final  int fire;
@override@JsonKey() final  int brain;
@override@JsonKey() final  int love;
@override@JsonKey() final  int sad;
@override@JsonKey() final  int flushed;
@override@JsonKey() final  int sick;
@override@JsonKey() final  int poo;
@override@JsonKey() final  int thinking;
@override@JsonKey() final  int sleepy;
@override@JsonKey() final  int skull;
@override@JsonKey() final  int mindblown;
@override@JsonKey() final  int respect;

/// Create a copy of ReactionCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactionCountsCopyWith<_ReactionCounts> get copyWith => __$ReactionCountsCopyWithImpl<_ReactionCounts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReactionCounts&&(identical(other.fire, fire) || other.fire == fire)&&(identical(other.brain, brain) || other.brain == brain)&&(identical(other.love, love) || other.love == love)&&(identical(other.sad, sad) || other.sad == sad)&&(identical(other.flushed, flushed) || other.flushed == flushed)&&(identical(other.sick, sick) || other.sick == sick)&&(identical(other.poo, poo) || other.poo == poo)&&(identical(other.thinking, thinking) || other.thinking == thinking)&&(identical(other.sleepy, sleepy) || other.sleepy == sleepy)&&(identical(other.skull, skull) || other.skull == skull)&&(identical(other.mindblown, mindblown) || other.mindblown == mindblown)&&(identical(other.respect, respect) || other.respect == respect));
}


@override
int get hashCode => Object.hash(runtimeType,fire,brain,love,sad,flushed,sick,poo,thinking,sleepy,skull,mindblown,respect);

@override
String toString() {
  return 'ReactionCounts(fire: $fire, brain: $brain, love: $love, sad: $sad, flushed: $flushed, sick: $sick, poo: $poo, thinking: $thinking, sleepy: $sleepy, skull: $skull, mindblown: $mindblown, respect: $respect)';
}


}

/// @nodoc
abstract mixin class _$ReactionCountsCopyWith<$Res> implements $ReactionCountsCopyWith<$Res> {
  factory _$ReactionCountsCopyWith(_ReactionCounts value, $Res Function(_ReactionCounts) _then) = __$ReactionCountsCopyWithImpl;
@override @useResult
$Res call({
 int fire, int brain, int love, int sad, int flushed, int sick, int poo, int thinking, int sleepy, int skull, int mindblown, int respect
});




}
/// @nodoc
class __$ReactionCountsCopyWithImpl<$Res>
    implements _$ReactionCountsCopyWith<$Res> {
  __$ReactionCountsCopyWithImpl(this._self, this._then);

  final _ReactionCounts _self;
  final $Res Function(_ReactionCounts) _then;

/// Create a copy of ReactionCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fire = null,Object? brain = null,Object? love = null,Object? sad = null,Object? flushed = null,Object? sick = null,Object? poo = null,Object? thinking = null,Object? sleepy = null,Object? skull = null,Object? mindblown = null,Object? respect = null,}) {
  return _then(_ReactionCounts(
fire: null == fire ? _self.fire : fire // ignore: cast_nullable_to_non_nullable
as int,brain: null == brain ? _self.brain : brain // ignore: cast_nullable_to_non_nullable
as int,love: null == love ? _self.love : love // ignore: cast_nullable_to_non_nullable
as int,sad: null == sad ? _self.sad : sad // ignore: cast_nullable_to_non_nullable
as int,flushed: null == flushed ? _self.flushed : flushed // ignore: cast_nullable_to_non_nullable
as int,sick: null == sick ? _self.sick : sick // ignore: cast_nullable_to_non_nullable
as int,poo: null == poo ? _self.poo : poo // ignore: cast_nullable_to_non_nullable
as int,thinking: null == thinking ? _self.thinking : thinking // ignore: cast_nullable_to_non_nullable
as int,sleepy: null == sleepy ? _self.sleepy : sleepy // ignore: cast_nullable_to_non_nullable
as int,skull: null == skull ? _self.skull : skull // ignore: cast_nullable_to_non_nullable
as int,mindblown: null == mindblown ? _self.mindblown : mindblown // ignore: cast_nullable_to_non_nullable
as int,respect: null == respect ? _self.respect : respect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
