// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppState {

 AppStatus get status; User get user; bool get isAmoled; int? get discoursePostIdToOpen; String? get routeToOpen; int get notificationNavigationId;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.isAmoled, isAmoled) || other.isAmoled == isAmoled)&&(identical(other.discoursePostIdToOpen, discoursePostIdToOpen) || other.discoursePostIdToOpen == discoursePostIdToOpen)&&(identical(other.routeToOpen, routeToOpen) || other.routeToOpen == routeToOpen)&&(identical(other.notificationNavigationId, notificationNavigationId) || other.notificationNavigationId == notificationNavigationId));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,isAmoled,discoursePostIdToOpen,routeToOpen,notificationNavigationId);

@override
String toString() {
  return 'AppState(status: $status, user: $user, isAmoled: $isAmoled, discoursePostIdToOpen: $discoursePostIdToOpen, routeToOpen: $routeToOpen, notificationNavigationId: $notificationNavigationId)';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 AppStatus status, User user, bool isAmoled, int? discoursePostIdToOpen, String? routeToOpen, int notificationNavigationId
});


$UserCopyWith<$Res> get user;

}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? user = null,Object? isAmoled = null,Object? discoursePostIdToOpen = freezed,Object? routeToOpen = freezed,Object? notificationNavigationId = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatus,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,isAmoled: null == isAmoled ? _self.isAmoled : isAmoled // ignore: cast_nullable_to_non_nullable
as bool,discoursePostIdToOpen: freezed == discoursePostIdToOpen ? _self.discoursePostIdToOpen : discoursePostIdToOpen // ignore: cast_nullable_to_non_nullable
as int?,routeToOpen: freezed == routeToOpen ? _self.routeToOpen : routeToOpen // ignore: cast_nullable_to_non_nullable
as String?,notificationNavigationId: null == notificationNavigationId ? _self.notificationNavigationId : notificationNavigationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {

  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppState value)  $default,){
final _that = this;
switch (_that) {
case _AppState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppState value)?  $default,){
final _that = this;
switch (_that) {
case _AppState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppStatus status,  User user,  bool isAmoled,  int? discoursePostIdToOpen,  String? routeToOpen,  int notificationNavigationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.status,_that.user,_that.isAmoled,_that.discoursePostIdToOpen,_that.routeToOpen,_that.notificationNavigationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppStatus status,  User user,  bool isAmoled,  int? discoursePostIdToOpen,  String? routeToOpen,  int notificationNavigationId)  $default,) {final _that = this;
switch (_that) {
case _AppState():
return $default(_that.status,_that.user,_that.isAmoled,_that.discoursePostIdToOpen,_that.routeToOpen,_that.notificationNavigationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppStatus status,  User user,  bool isAmoled,  int? discoursePostIdToOpen,  String? routeToOpen,  int notificationNavigationId)?  $default,) {final _that = this;
switch (_that) {
case _AppState() when $default != null:
return $default(_that.status,_that.user,_that.isAmoled,_that.discoursePostIdToOpen,_that.routeToOpen,_that.notificationNavigationId);case _:
  return null;

}
}

}

/// @nodoc


class _AppState extends AppState {
  const _AppState({this.status = AppStatus.unauthenticated, this.user = User.anonymous, this.isAmoled = false, this.discoursePostIdToOpen, this.routeToOpen, this.notificationNavigationId = 0}): super._();


@override@JsonKey() final  AppStatus status;
@override@JsonKey() final  User user;
@override@JsonKey() final  bool isAmoled;
@override final  int? discoursePostIdToOpen;
@override final  String? routeToOpen;
@override@JsonKey() final  int notificationNavigationId;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.isAmoled, isAmoled) || other.isAmoled == isAmoled)&&(identical(other.discoursePostIdToOpen, discoursePostIdToOpen) || other.discoursePostIdToOpen == discoursePostIdToOpen)&&(identical(other.routeToOpen, routeToOpen) || other.routeToOpen == routeToOpen)&&(identical(other.notificationNavigationId, notificationNavigationId) || other.notificationNavigationId == notificationNavigationId));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,isAmoled,discoursePostIdToOpen,routeToOpen,notificationNavigationId);

@override
String toString() {
  return 'AppState(status: $status, user: $user, isAmoled: $isAmoled, discoursePostIdToOpen: $discoursePostIdToOpen, routeToOpen: $routeToOpen, notificationNavigationId: $notificationNavigationId)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 AppStatus status, User user, bool isAmoled, int? discoursePostIdToOpen, String? routeToOpen, int notificationNavigationId
});


@override $UserCopyWith<$Res> get user;

}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? user = null,Object? isAmoled = null,Object? discoursePostIdToOpen = freezed,Object? routeToOpen = freezed,Object? notificationNavigationId = null,}) {
  return _then(_AppState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AppStatus,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,isAmoled: null == isAmoled ? _self.isAmoled : isAmoled // ignore: cast_nullable_to_non_nullable
as bool,discoursePostIdToOpen: freezed == discoursePostIdToOpen ? _self.discoursePostIdToOpen : discoursePostIdToOpen // ignore: cast_nullable_to_non_nullable
as int?,routeToOpen: freezed == routeToOpen ? _self.routeToOpen : routeToOpen // ignore: cast_nullable_to_non_nullable
as String?,notificationNavigationId: null == notificationNavigationId ? _self.notificationNavigationId : notificationNavigationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {

  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
