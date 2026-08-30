// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_application_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamApplicationDraft {

 String get teamId; String get role; String get message; bool get attachProfile;
/// Create a copy of TeamApplicationDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamApplicationDraftCopyWith<TeamApplicationDraft> get copyWith => _$TeamApplicationDraftCopyWithImpl<TeamApplicationDraft>(this as TeamApplicationDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamApplicationDraft&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message)&&(identical(other.attachProfile, attachProfile) || other.attachProfile == attachProfile));
}


@override
int get hashCode => Object.hash(runtimeType,teamId,role,message,attachProfile);

@override
String toString() {
  return 'TeamApplicationDraft(teamId: $teamId, role: $role, message: $message, attachProfile: $attachProfile)';
}


}

/// @nodoc
abstract mixin class $TeamApplicationDraftCopyWith<$Res>  {
  factory $TeamApplicationDraftCopyWith(TeamApplicationDraft value, $Res Function(TeamApplicationDraft) _then) = _$TeamApplicationDraftCopyWithImpl;
@useResult
$Res call({
 String teamId, String role, String message, bool attachProfile
});




}
/// @nodoc
class _$TeamApplicationDraftCopyWithImpl<$Res>
    implements $TeamApplicationDraftCopyWith<$Res> {
  _$TeamApplicationDraftCopyWithImpl(this._self, this._then);

  final TeamApplicationDraft _self;
  final $Res Function(TeamApplicationDraft) _then;

/// Create a copy of TeamApplicationDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? role = null,Object? message = null,Object? attachProfile = null,}) {
  return _then(_self.copyWith(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,attachProfile: null == attachProfile ? _self.attachProfile : attachProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamApplicationDraft].
extension TeamApplicationDraftPatterns on TeamApplicationDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamApplicationDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamApplicationDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamApplicationDraft value)  $default,){
final _that = this;
switch (_that) {
case _TeamApplicationDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamApplicationDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TeamApplicationDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamId,  String role,  String message,  bool attachProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamApplicationDraft() when $default != null:
return $default(_that.teamId,_that.role,_that.message,_that.attachProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamId,  String role,  String message,  bool attachProfile)  $default,) {final _that = this;
switch (_that) {
case _TeamApplicationDraft():
return $default(_that.teamId,_that.role,_that.message,_that.attachProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamId,  String role,  String message,  bool attachProfile)?  $default,) {final _that = this;
switch (_that) {
case _TeamApplicationDraft() when $default != null:
return $default(_that.teamId,_that.role,_that.message,_that.attachProfile);case _:
  return null;

}
}

}

/// @nodoc


class _TeamApplicationDraft implements TeamApplicationDraft {
  const _TeamApplicationDraft({required this.teamId, this.role = '', this.message = '', this.attachProfile = true});


@override final  String teamId;
@override@JsonKey() final  String role;
@override@JsonKey() final  String message;
@override@JsonKey() final  bool attachProfile;

/// Create a copy of TeamApplicationDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamApplicationDraftCopyWith<_TeamApplicationDraft> get copyWith => __$TeamApplicationDraftCopyWithImpl<_TeamApplicationDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamApplicationDraft&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.role, role) || other.role == role)&&(identical(other.message, message) || other.message == message)&&(identical(other.attachProfile, attachProfile) || other.attachProfile == attachProfile));
}


@override
int get hashCode => Object.hash(runtimeType,teamId,role,message,attachProfile);

@override
String toString() {
  return 'TeamApplicationDraft(teamId: $teamId, role: $role, message: $message, attachProfile: $attachProfile)';
}


}

/// @nodoc
abstract mixin class _$TeamApplicationDraftCopyWith<$Res> implements $TeamApplicationDraftCopyWith<$Res> {
  factory _$TeamApplicationDraftCopyWith(_TeamApplicationDraft value, $Res Function(_TeamApplicationDraft) _then) = __$TeamApplicationDraftCopyWithImpl;
@override @useResult
$Res call({
 String teamId, String role, String message, bool attachProfile
});




}
/// @nodoc
class __$TeamApplicationDraftCopyWithImpl<$Res>
    implements _$TeamApplicationDraftCopyWith<$Res> {
  __$TeamApplicationDraftCopyWithImpl(this._self, this._then);

  final _TeamApplicationDraft _self;
  final $Res Function(_TeamApplicationDraft) _then;

/// Create a copy of TeamApplicationDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? role = null,Object? message = null,Object? attachProfile = null,}) {
  return _then(_TeamApplicationDraft(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,attachProfile: null == attachProfile ? _self.attachProfile : attachProfile // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
