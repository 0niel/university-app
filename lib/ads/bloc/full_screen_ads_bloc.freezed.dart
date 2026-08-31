// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'full_screen_ads_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FullScreenAdsState {

 InterstitialAd? get interstitialAd; RewardedAd? get rewardedAd; Reward? get earnedReward; FullScreenAdsStatus get status;
/// Create a copy of FullScreenAdsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FullScreenAdsStateCopyWith<FullScreenAdsState> get copyWith => _$FullScreenAdsStateCopyWithImpl<FullScreenAdsState>(this as FullScreenAdsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FullScreenAdsState&&(identical(other.interstitialAd, interstitialAd) || other.interstitialAd == interstitialAd)&&(identical(other.rewardedAd, rewardedAd) || other.rewardedAd == rewardedAd)&&(identical(other.earnedReward, earnedReward) || other.earnedReward == earnedReward)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,interstitialAd,rewardedAd,earnedReward,status);

@override
String toString() {
  return 'FullScreenAdsState(interstitialAd: $interstitialAd, rewardedAd: $rewardedAd, earnedReward: $earnedReward, status: $status)';
}


}

/// @nodoc
abstract mixin class $FullScreenAdsStateCopyWith<$Res>  {
  factory $FullScreenAdsStateCopyWith(FullScreenAdsState value, $Res Function(FullScreenAdsState) _then) = _$FullScreenAdsStateCopyWithImpl;
@useResult
$Res call({
 InterstitialAd? interstitialAd, RewardedAd? rewardedAd, Reward? earnedReward, FullScreenAdsStatus status
});




}
/// @nodoc
class _$FullScreenAdsStateCopyWithImpl<$Res>
    implements $FullScreenAdsStateCopyWith<$Res> {
  _$FullScreenAdsStateCopyWithImpl(this._self, this._then);

  final FullScreenAdsState _self;
  final $Res Function(FullScreenAdsState) _then;

/// Create a copy of FullScreenAdsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interstitialAd = freezed,Object? rewardedAd = freezed,Object? earnedReward = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
interstitialAd: freezed == interstitialAd ? _self.interstitialAd : interstitialAd // ignore: cast_nullable_to_non_nullable
as InterstitialAd?,rewardedAd: freezed == rewardedAd ? _self.rewardedAd : rewardedAd // ignore: cast_nullable_to_non_nullable
as RewardedAd?,earnedReward: freezed == earnedReward ? _self.earnedReward : earnedReward // ignore: cast_nullable_to_non_nullable
as Reward?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FullScreenAdsStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [FullScreenAdsState].
extension FullScreenAdsStatePatterns on FullScreenAdsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FullScreenAdsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FullScreenAdsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FullScreenAdsState value)  $default,){
final _that = this;
switch (_that) {
case _FullScreenAdsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FullScreenAdsState value)?  $default,){
final _that = this;
switch (_that) {
case _FullScreenAdsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InterstitialAd? interstitialAd,  RewardedAd? rewardedAd,  Reward? earnedReward,  FullScreenAdsStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FullScreenAdsState() when $default != null:
return $default(_that.interstitialAd,_that.rewardedAd,_that.earnedReward,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InterstitialAd? interstitialAd,  RewardedAd? rewardedAd,  Reward? earnedReward,  FullScreenAdsStatus status)  $default,) {final _that = this;
switch (_that) {
case _FullScreenAdsState():
return $default(_that.interstitialAd,_that.rewardedAd,_that.earnedReward,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InterstitialAd? interstitialAd,  RewardedAd? rewardedAd,  Reward? earnedReward,  FullScreenAdsStatus status)?  $default,) {final _that = this;
switch (_that) {
case _FullScreenAdsState() when $default != null:
return $default(_that.interstitialAd,_that.rewardedAd,_that.earnedReward,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _FullScreenAdsState extends FullScreenAdsState {
  const _FullScreenAdsState({this.interstitialAd, this.rewardedAd, this.earnedReward, this.status = FullScreenAdsStatus.initial}): super._();


@override final  InterstitialAd? interstitialAd;
@override final  RewardedAd? rewardedAd;
@override final  Reward? earnedReward;
@override@JsonKey() final  FullScreenAdsStatus status;

/// Create a copy of FullScreenAdsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FullScreenAdsStateCopyWith<_FullScreenAdsState> get copyWith => __$FullScreenAdsStateCopyWithImpl<_FullScreenAdsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FullScreenAdsState&&(identical(other.interstitialAd, interstitialAd) || other.interstitialAd == interstitialAd)&&(identical(other.rewardedAd, rewardedAd) || other.rewardedAd == rewardedAd)&&(identical(other.earnedReward, earnedReward) || other.earnedReward == earnedReward)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,interstitialAd,rewardedAd,earnedReward,status);

@override
String toString() {
  return 'FullScreenAdsState(interstitialAd: $interstitialAd, rewardedAd: $rewardedAd, earnedReward: $earnedReward, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FullScreenAdsStateCopyWith<$Res> implements $FullScreenAdsStateCopyWith<$Res> {
  factory _$FullScreenAdsStateCopyWith(_FullScreenAdsState value, $Res Function(_FullScreenAdsState) _then) = __$FullScreenAdsStateCopyWithImpl;
@override @useResult
$Res call({
 InterstitialAd? interstitialAd, RewardedAd? rewardedAd, Reward? earnedReward, FullScreenAdsStatus status
});




}
/// @nodoc
class __$FullScreenAdsStateCopyWithImpl<$Res>
    implements _$FullScreenAdsStateCopyWith<$Res> {
  __$FullScreenAdsStateCopyWithImpl(this._self, this._then);

  final _FullScreenAdsState _self;
  final $Res Function(_FullScreenAdsState) _then;

/// Create a copy of FullScreenAdsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? interstitialAd = freezed,Object? rewardedAd = freezed,Object? earnedReward = freezed,Object? status = null,}) {
  return _then(_FullScreenAdsState(
interstitialAd: freezed == interstitialAd ? _self.interstitialAd : interstitialAd // ignore: cast_nullable_to_non_nullable
as InterstitialAd?,rewardedAd: freezed == rewardedAd ? _self.rewardedAd : rewardedAd // ignore: cast_nullable_to_non_nullable
as RewardedAd?,earnedReward: freezed == earnedReward ? _self.earnedReward : earnedReward // ignore: cast_nullable_to_non_nullable
as Reward?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FullScreenAdsStatus,
  ));
}


}

// dart format on
