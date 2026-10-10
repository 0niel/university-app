// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_flow_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingIdentityDraft {

 String? get name; String? get handle; String? get verifiedHandle; OnboardingDraftOrigin get origin;
/// Create a copy of OnboardingIdentityDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingIdentityDraftCopyWith<OnboardingIdentityDraft> get copyWith => _$OnboardingIdentityDraftCopyWithImpl<OnboardingIdentityDraft>(this as OnboardingIdentityDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingIdentityDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.verifiedHandle, verifiedHandle) || other.verifiedHandle == verifiedHandle)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode => Object.hash(runtimeType,name,handle,verifiedHandle,origin);

@override
String toString() {
  return 'OnboardingIdentityDraft(name: $name, handle: $handle, verifiedHandle: $verifiedHandle, origin: $origin)';
}


}

/// @nodoc
abstract mixin class $OnboardingIdentityDraftCopyWith<$Res>  {
  factory $OnboardingIdentityDraftCopyWith(OnboardingIdentityDraft value, $Res Function(OnboardingIdentityDraft) _then) = _$OnboardingIdentityDraftCopyWithImpl;
@useResult
$Res call({
 String? name, String? handle, String? verifiedHandle, OnboardingDraftOrigin origin
});




}
/// @nodoc
class _$OnboardingIdentityDraftCopyWithImpl<$Res>
    implements $OnboardingIdentityDraftCopyWith<$Res> {
  _$OnboardingIdentityDraftCopyWithImpl(this._self, this._then);

  final OnboardingIdentityDraft _self;
  final $Res Function(OnboardingIdentityDraft) _then;

/// Create a copy of OnboardingIdentityDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? handle = freezed,Object? verifiedHandle = freezed,Object? origin = null,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,verifiedHandle: freezed == verifiedHandle ? _self.verifiedHandle : verifiedHandle // ignore: cast_nullable_to_non_nullable
as String?,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingIdentityDraft].
extension OnboardingIdentityDraftPatterns on OnboardingIdentityDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingIdentityDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingIdentityDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingIdentityDraft value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingIdentityDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingIdentityDraft value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingIdentityDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? handle,  String? verifiedHandle,  OnboardingDraftOrigin origin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingIdentityDraft() when $default != null:
return $default(_that.name,_that.handle,_that.verifiedHandle,_that.origin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? handle,  String? verifiedHandle,  OnboardingDraftOrigin origin)  $default,) {final _that = this;
switch (_that) {
case _OnboardingIdentityDraft():
return $default(_that.name,_that.handle,_that.verifiedHandle,_that.origin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? handle,  String? verifiedHandle,  OnboardingDraftOrigin origin)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingIdentityDraft() when $default != null:
return $default(_that.name,_that.handle,_that.verifiedHandle,_that.origin);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingIdentityDraft extends OnboardingIdentityDraft {
  const _OnboardingIdentityDraft({this.name, this.handle, this.verifiedHandle, this.origin = OnboardingDraftOrigin.initial}): super._();


@override final  String? name;
@override final  String? handle;
@override final  String? verifiedHandle;
@override@JsonKey() final  OnboardingDraftOrigin origin;

/// Create a copy of OnboardingIdentityDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingIdentityDraftCopyWith<_OnboardingIdentityDraft> get copyWith => __$OnboardingIdentityDraftCopyWithImpl<_OnboardingIdentityDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingIdentityDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.handle, handle) || other.handle == handle)&&(identical(other.verifiedHandle, verifiedHandle) || other.verifiedHandle == verifiedHandle)&&(identical(other.origin, origin) || other.origin == origin));
}


@override
int get hashCode => Object.hash(runtimeType,name,handle,verifiedHandle,origin);

@override
String toString() {
  return 'OnboardingIdentityDraft(name: $name, handle: $handle, verifiedHandle: $verifiedHandle, origin: $origin)';
}


}

/// @nodoc
abstract mixin class _$OnboardingIdentityDraftCopyWith<$Res> implements $OnboardingIdentityDraftCopyWith<$Res> {
  factory _$OnboardingIdentityDraftCopyWith(_OnboardingIdentityDraft value, $Res Function(_OnboardingIdentityDraft) _then) = __$OnboardingIdentityDraftCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? handle, String? verifiedHandle, OnboardingDraftOrigin origin
});




}
/// @nodoc
class __$OnboardingIdentityDraftCopyWithImpl<$Res>
    implements _$OnboardingIdentityDraftCopyWith<$Res> {
  __$OnboardingIdentityDraftCopyWithImpl(this._self, this._then);

  final _OnboardingIdentityDraft _self;
  final $Res Function(_OnboardingIdentityDraft) _then;

/// Create a copy of OnboardingIdentityDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? handle = freezed,Object? verifiedHandle = freezed,Object? origin = null,}) {
  return _then(_OnboardingIdentityDraft(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,handle: freezed == handle ? _self.handle : handle // ignore: cast_nullable_to_non_nullable
as String?,verifiedHandle: freezed == verifiedHandle ? _self.verifiedHandle : verifiedHandle // ignore: cast_nullable_to_non_nullable
as String?,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,
  ));
}


}

/// @nodoc
mixin _$OnboardingFlowState {

 OnboardingStage get stage; AccountRole get role; OnboardingDraftOrigin get roleOrigin; Group? get group; String get groupQuery; OnboardingDraftOrigin get groupOrigin; Teacher? get teacher; OnboardingDraftOrigin get teacherOrigin; OnboardingIdentityDraft get identity; OnboardingIdentityRequirement get identityRequirement; FormzSubmissionStatus get submission;
/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingFlowStateCopyWith<OnboardingFlowState> get copyWith => _$OnboardingFlowStateCopyWithImpl<OnboardingFlowState>(this as OnboardingFlowState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingFlowState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleOrigin, roleOrigin) || other.roleOrigin == roleOrigin)&&(identical(other.group, group) || other.group == group)&&(identical(other.groupQuery, groupQuery) || other.groupQuery == groupQuery)&&(identical(other.groupOrigin, groupOrigin) || other.groupOrigin == groupOrigin)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.teacherOrigin, teacherOrigin) || other.teacherOrigin == teacherOrigin)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.identityRequirement, identityRequirement) || other.identityRequirement == identityRequirement)&&(identical(other.submission, submission) || other.submission == submission));
}


@override
int get hashCode => Object.hash(runtimeType,stage,role,roleOrigin,group,groupQuery,groupOrigin,teacher,teacherOrigin,identity,identityRequirement,submission);

@override
String toString() {
  return 'OnboardingFlowState(stage: $stage, role: $role, roleOrigin: $roleOrigin, group: $group, groupQuery: $groupQuery, groupOrigin: $groupOrigin, teacher: $teacher, teacherOrigin: $teacherOrigin, identity: $identity, identityRequirement: $identityRequirement, submission: $submission)';
}


}

/// @nodoc
abstract mixin class $OnboardingFlowStateCopyWith<$Res>  {
  factory $OnboardingFlowStateCopyWith(OnboardingFlowState value, $Res Function(OnboardingFlowState) _then) = _$OnboardingFlowStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStage stage, AccountRole role, OnboardingDraftOrigin roleOrigin, Group? group, String groupQuery, OnboardingDraftOrigin groupOrigin, Teacher? teacher, OnboardingDraftOrigin teacherOrigin, OnboardingIdentityDraft identity, OnboardingIdentityRequirement identityRequirement, FormzSubmissionStatus submission
});


$GroupCopyWith<$Res>? get group;$TeacherCopyWith<$Res>? get teacher;$OnboardingIdentityDraftCopyWith<$Res> get identity;

}
/// @nodoc
class _$OnboardingFlowStateCopyWithImpl<$Res>
    implements $OnboardingFlowStateCopyWith<$Res> {
  _$OnboardingFlowStateCopyWithImpl(this._self, this._then);

  final OnboardingFlowState _self;
  final $Res Function(OnboardingFlowState) _then;

/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? role = null,Object? roleOrigin = null,Object? group = freezed,Object? groupQuery = null,Object? groupOrigin = null,Object? teacher = freezed,Object? teacherOrigin = null,Object? identity = null,Object? identityRequirement = null,Object? submission = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OnboardingStage,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,roleOrigin: null == roleOrigin ? _self.roleOrigin : roleOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,groupQuery: null == groupQuery ? _self.groupQuery : groupQuery // ignore: cast_nullable_to_non_nullable
as String,groupOrigin: null == groupOrigin ? _self.groupOrigin : groupOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher?,teacherOrigin: null == teacherOrigin ? _self.teacherOrigin : teacherOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as OnboardingIdentityDraft,identityRequirement: null == identityRequirement ? _self.identityRequirement : identityRequirement // ignore: cast_nullable_to_non_nullable
as OnboardingIdentityRequirement,submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,
  ));
}
/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
    return null;
  }

  return $TeacherCopyWith<$Res>(_self.teacher!, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingIdentityDraftCopyWith<$Res> get identity {

  return $OnboardingIdentityDraftCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingFlowState].
extension OnboardingFlowStatePatterns on OnboardingFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingFlowState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStage stage,  AccountRole role,  OnboardingDraftOrigin roleOrigin,  Group? group,  String groupQuery,  OnboardingDraftOrigin groupOrigin,  Teacher? teacher,  OnboardingDraftOrigin teacherOrigin,  OnboardingIdentityDraft identity,  OnboardingIdentityRequirement identityRequirement,  FormzSubmissionStatus submission)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingFlowState() when $default != null:
return $default(_that.stage,_that.role,_that.roleOrigin,_that.group,_that.groupQuery,_that.groupOrigin,_that.teacher,_that.teacherOrigin,_that.identity,_that.identityRequirement,_that.submission);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStage stage,  AccountRole role,  OnboardingDraftOrigin roleOrigin,  Group? group,  String groupQuery,  OnboardingDraftOrigin groupOrigin,  Teacher? teacher,  OnboardingDraftOrigin teacherOrigin,  OnboardingIdentityDraft identity,  OnboardingIdentityRequirement identityRequirement,  FormzSubmissionStatus submission)  $default,) {final _that = this;
switch (_that) {
case _OnboardingFlowState():
return $default(_that.stage,_that.role,_that.roleOrigin,_that.group,_that.groupQuery,_that.groupOrigin,_that.teacher,_that.teacherOrigin,_that.identity,_that.identityRequirement,_that.submission);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStage stage,  AccountRole role,  OnboardingDraftOrigin roleOrigin,  Group? group,  String groupQuery,  OnboardingDraftOrigin groupOrigin,  Teacher? teacher,  OnboardingDraftOrigin teacherOrigin,  OnboardingIdentityDraft identity,  OnboardingIdentityRequirement identityRequirement,  FormzSubmissionStatus submission)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingFlowState() when $default != null:
return $default(_that.stage,_that.role,_that.roleOrigin,_that.group,_that.groupQuery,_that.groupOrigin,_that.teacher,_that.teacherOrigin,_that.identity,_that.identityRequirement,_that.submission);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingFlowState extends OnboardingFlowState {
  const _OnboardingFlowState({this.stage = OnboardingStage.welcome, this.role = AccountRole.student, this.roleOrigin = OnboardingDraftOrigin.initial, this.group, this.groupQuery = '', this.groupOrigin = OnboardingDraftOrigin.initial, this.teacher, this.teacherOrigin = OnboardingDraftOrigin.initial, this.identity = const OnboardingIdentityDraft(), this.identityRequirement = OnboardingIdentityRequirement.required, this.submission = FormzSubmissionStatus.initial}): super._();


@override@JsonKey() final  OnboardingStage stage;
@override@JsonKey() final  AccountRole role;
@override@JsonKey() final  OnboardingDraftOrigin roleOrigin;
@override final  Group? group;
@override@JsonKey() final  String groupQuery;
@override@JsonKey() final  OnboardingDraftOrigin groupOrigin;
@override final  Teacher? teacher;
@override@JsonKey() final  OnboardingDraftOrigin teacherOrigin;
@override@JsonKey() final  OnboardingIdentityDraft identity;
@override@JsonKey() final  OnboardingIdentityRequirement identityRequirement;
@override@JsonKey() final  FormzSubmissionStatus submission;

/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingFlowStateCopyWith<_OnboardingFlowState> get copyWith => __$OnboardingFlowStateCopyWithImpl<_OnboardingFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingFlowState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.role, role) || other.role == role)&&(identical(other.roleOrigin, roleOrigin) || other.roleOrigin == roleOrigin)&&(identical(other.group, group) || other.group == group)&&(identical(other.groupQuery, groupQuery) || other.groupQuery == groupQuery)&&(identical(other.groupOrigin, groupOrigin) || other.groupOrigin == groupOrigin)&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.teacherOrigin, teacherOrigin) || other.teacherOrigin == teacherOrigin)&&(identical(other.identity, identity) || other.identity == identity)&&(identical(other.identityRequirement, identityRequirement) || other.identityRequirement == identityRequirement)&&(identical(other.submission, submission) || other.submission == submission));
}


@override
int get hashCode => Object.hash(runtimeType,stage,role,roleOrigin,group,groupQuery,groupOrigin,teacher,teacherOrigin,identity,identityRequirement,submission);

@override
String toString() {
  return 'OnboardingFlowState(stage: $stage, role: $role, roleOrigin: $roleOrigin, group: $group, groupQuery: $groupQuery, groupOrigin: $groupOrigin, teacher: $teacher, teacherOrigin: $teacherOrigin, identity: $identity, identityRequirement: $identityRequirement, submission: $submission)';
}


}

/// @nodoc
abstract mixin class _$OnboardingFlowStateCopyWith<$Res> implements $OnboardingFlowStateCopyWith<$Res> {
  factory _$OnboardingFlowStateCopyWith(_OnboardingFlowState value, $Res Function(_OnboardingFlowState) _then) = __$OnboardingFlowStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStage stage, AccountRole role, OnboardingDraftOrigin roleOrigin, Group? group, String groupQuery, OnboardingDraftOrigin groupOrigin, Teacher? teacher, OnboardingDraftOrigin teacherOrigin, OnboardingIdentityDraft identity, OnboardingIdentityRequirement identityRequirement, FormzSubmissionStatus submission
});


@override $GroupCopyWith<$Res>? get group;@override $TeacherCopyWith<$Res>? get teacher;@override $OnboardingIdentityDraftCopyWith<$Res> get identity;

}
/// @nodoc
class __$OnboardingFlowStateCopyWithImpl<$Res>
    implements _$OnboardingFlowStateCopyWith<$Res> {
  __$OnboardingFlowStateCopyWithImpl(this._self, this._then);

  final _OnboardingFlowState _self;
  final $Res Function(_OnboardingFlowState) _then;

/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? role = null,Object? roleOrigin = null,Object? group = freezed,Object? groupQuery = null,Object? groupOrigin = null,Object? teacher = freezed,Object? teacherOrigin = null,Object? identity = null,Object? identityRequirement = null,Object? submission = null,}) {
  return _then(_OnboardingFlowState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OnboardingStage,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole,roleOrigin: null == roleOrigin ? _self.roleOrigin : roleOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,groupQuery: null == groupQuery ? _self.groupQuery : groupQuery // ignore: cast_nullable_to_non_nullable
as String,groupOrigin: null == groupOrigin ? _self.groupOrigin : groupOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,teacher: freezed == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher?,teacherOrigin: null == teacherOrigin ? _self.teacherOrigin : teacherOrigin // ignore: cast_nullable_to_non_nullable
as OnboardingDraftOrigin,identity: null == identity ? _self.identity : identity // ignore: cast_nullable_to_non_nullable
as OnboardingIdentityDraft,identityRequirement: null == identityRequirement ? _self.identityRequirement : identityRequirement // ignore: cast_nullable_to_non_nullable
as OnboardingIdentityRequirement,submission: null == submission ? _self.submission : submission // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,
  ));
}

/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
    return null;
  }

  return $TeacherCopyWith<$Res>(_self.teacher!, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}/// Create a copy of OnboardingFlowState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingIdentityDraftCopyWith<$Res> get identity {

  return $OnboardingIdentityDraftCopyWith<$Res>(_self.identity, (value) {
    return _then(_self.copyWith(identity: value));
  });
}
}

// dart format on
