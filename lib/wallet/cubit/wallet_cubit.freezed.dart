// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletState {

 WalletStatus get status; UserGamificationProfile get profile; ProfileOverview get overview; List<ShurikenEntry> get history; WalletTab get tab;
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletStateCopyWith<WalletState> get copyWith => _$WalletStateCopyWithImpl<WalletState>(this as WalletState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,overview,const DeepCollectionEquality().hash(history),tab);

@override
String toString() {
  return 'WalletState(status: $status, profile: $profile, overview: $overview, history: $history, tab: $tab)';
}


}

/// @nodoc
abstract mixin class $WalletStateCopyWith<$Res>  {
  factory $WalletStateCopyWith(WalletState value, $Res Function(WalletState) _then) = _$WalletStateCopyWithImpl;
@useResult
$Res call({
 WalletStatus status, UserGamificationProfile profile, ProfileOverview overview, List<ShurikenEntry> history, WalletTab tab
});


$UserGamificationProfileCopyWith<$Res> get profile;$ProfileOverviewCopyWith<$Res> get overview;

}
/// @nodoc
class _$WalletStateCopyWithImpl<$Res>
    implements $WalletStateCopyWith<$Res> {
  _$WalletStateCopyWithImpl(this._self, this._then);

  final WalletState _self;
  final $Res Function(WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? profile = null,Object? overview = null,Object? history = null,Object? tab = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as ProfileOverview,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ShurikenEntry>,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as WalletTab,
  ));
}
/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get profile {

  return $UserGamificationProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileOverviewCopyWith<$Res> get overview {

  return $ProfileOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletState].
extension WalletStatePatterns on WalletState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletState value)  $default,){
final _that = this;
switch (_that) {
case _WalletState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WalletStatus status,  UserGamificationProfile profile,  ProfileOverview overview,  List<ShurikenEntry> history,  WalletTab tab)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.status,_that.profile,_that.overview,_that.history,_that.tab);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WalletStatus status,  UserGamificationProfile profile,  ProfileOverview overview,  List<ShurikenEntry> history,  WalletTab tab)  $default,) {final _that = this;
switch (_that) {
case _WalletState():
return $default(_that.status,_that.profile,_that.overview,_that.history,_that.tab);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WalletStatus status,  UserGamificationProfile profile,  ProfileOverview overview,  List<ShurikenEntry> history,  WalletTab tab)?  $default,) {final _that = this;
switch (_that) {
case _WalletState() when $default != null:
return $default(_that.status,_that.profile,_that.overview,_that.history,_that.tab);case _:
  return null;

}
}

}

/// @nodoc


class _WalletState extends WalletState {
  const _WalletState({this.status = WalletStatus.initial, this.profile = UserGamificationProfile.empty, this.overview = ProfileOverview.empty, final  List<ShurikenEntry> history = const <ShurikenEntry>[], this.tab = WalletTab.earn}): _history = history,super._();


@override@JsonKey() final  WalletStatus status;
@override@JsonKey() final  UserGamificationProfile profile;
@override@JsonKey() final  ProfileOverview overview;
 final  List<ShurikenEntry> _history;
@override@JsonKey() List<ShurikenEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

@override@JsonKey() final  WalletTab tab;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletStateCopyWith<_WalletState> get copyWith => __$WalletStateCopyWithImpl<_WalletState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletState&&(identical(other.status, status) || other.status == status)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,status,profile,overview,const DeepCollectionEquality().hash(_history),tab);

@override
String toString() {
  return 'WalletState(status: $status, profile: $profile, overview: $overview, history: $history, tab: $tab)';
}


}

/// @nodoc
abstract mixin class _$WalletStateCopyWith<$Res> implements $WalletStateCopyWith<$Res> {
  factory _$WalletStateCopyWith(_WalletState value, $Res Function(_WalletState) _then) = __$WalletStateCopyWithImpl;
@override @useResult
$Res call({
 WalletStatus status, UserGamificationProfile profile, ProfileOverview overview, List<ShurikenEntry> history, WalletTab tab
});


@override $UserGamificationProfileCopyWith<$Res> get profile;@override $ProfileOverviewCopyWith<$Res> get overview;

}
/// @nodoc
class __$WalletStateCopyWithImpl<$Res>
    implements _$WalletStateCopyWith<$Res> {
  __$WalletStateCopyWithImpl(this._self, this._then);

  final _WalletState _self;
  final $Res Function(_WalletState) _then;

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? profile = null,Object? overview = null,Object? history = null,Object? tab = null,}) {
  return _then(_WalletState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletStatus,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as ProfileOverview,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ShurikenEntry>,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as WalletTab,
  ));
}

/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get profile {

  return $UserGamificationProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of WalletState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileOverviewCopyWith<$Res> get overview {

  return $ProfileOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}
}

// dart format on
