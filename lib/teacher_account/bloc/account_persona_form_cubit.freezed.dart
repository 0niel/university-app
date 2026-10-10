// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_persona_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountPersonaDraft {

 AccountRole? get role; TeacherSelectionEdit get selection;
/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountPersonaDraftCopyWith<AccountPersonaDraft> get copyWith => _$AccountPersonaDraftCopyWithImpl<AccountPersonaDraft>(this as AccountPersonaDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountPersonaDraft&&(identical(other.role, role) || other.role == role)&&(identical(other.selection, selection) || other.selection == selection));
}


@override
int get hashCode => Object.hash(runtimeType,role,selection);

@override
String toString() {
  return 'AccountPersonaDraft(role: $role, selection: $selection)';
}


}

/// @nodoc
abstract mixin class $AccountPersonaDraftCopyWith<$Res>  {
  factory $AccountPersonaDraftCopyWith(AccountPersonaDraft value, $Res Function(AccountPersonaDraft) _then) = _$AccountPersonaDraftCopyWithImpl;
@useResult
$Res call({
 AccountRole? role, TeacherSelectionEdit selection
});


$TeacherSelectionEditCopyWith<$Res> get selection;

}
/// @nodoc
class _$AccountPersonaDraftCopyWithImpl<$Res>
    implements $AccountPersonaDraftCopyWith<$Res> {
  _$AccountPersonaDraftCopyWithImpl(this._self, this._then);

  final AccountPersonaDraft _self;
  final $Res Function(AccountPersonaDraft) _then;

/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? selection = null,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole?,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as TeacherSelectionEdit,
  ));
}
/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherSelectionEditCopyWith<$Res> get selection {

  return $TeacherSelectionEditCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountPersonaDraft].
extension AccountPersonaDraftPatterns on AccountPersonaDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountPersonaDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountPersonaDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountPersonaDraft value)  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountPersonaDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountRole? role,  TeacherSelectionEdit selection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountPersonaDraft() when $default != null:
return $default(_that.role,_that.selection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountRole? role,  TeacherSelectionEdit selection)  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaDraft():
return $default(_that.role,_that.selection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountRole? role,  TeacherSelectionEdit selection)?  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaDraft() when $default != null:
return $default(_that.role,_that.selection);case _:
  return null;

}
}

}

/// @nodoc


class _AccountPersonaDraft implements AccountPersonaDraft {
  const _AccountPersonaDraft({this.role, this.selection = const TeacherSelectionEdit.keep()});


@override final  AccountRole? role;
@override@JsonKey() final  TeacherSelectionEdit selection;

/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountPersonaDraftCopyWith<_AccountPersonaDraft> get copyWith => __$AccountPersonaDraftCopyWithImpl<_AccountPersonaDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountPersonaDraft&&(identical(other.role, role) || other.role == role)&&(identical(other.selection, selection) || other.selection == selection));
}


@override
int get hashCode => Object.hash(runtimeType,role,selection);

@override
String toString() {
  return 'AccountPersonaDraft(role: $role, selection: $selection)';
}


}

/// @nodoc
abstract mixin class _$AccountPersonaDraftCopyWith<$Res> implements $AccountPersonaDraftCopyWith<$Res> {
  factory _$AccountPersonaDraftCopyWith(_AccountPersonaDraft value, $Res Function(_AccountPersonaDraft) _then) = __$AccountPersonaDraftCopyWithImpl;
@override @useResult
$Res call({
 AccountRole? role, TeacherSelectionEdit selection
});


@override $TeacherSelectionEditCopyWith<$Res> get selection;

}
/// @nodoc
class __$AccountPersonaDraftCopyWithImpl<$Res>
    implements _$AccountPersonaDraftCopyWith<$Res> {
  __$AccountPersonaDraftCopyWithImpl(this._self, this._then);

  final _AccountPersonaDraft _self;
  final $Res Function(_AccountPersonaDraft) _then;

/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? selection = null,}) {
  return _then(_AccountPersonaDraft(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as AccountRole?,selection: null == selection ? _self.selection : selection // ignore: cast_nullable_to_non_nullable
as TeacherSelectionEdit,
  ));
}

/// Create a copy of AccountPersonaDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherSelectionEditCopyWith<$Res> get selection {

  return $TeacherSelectionEditCopyWith<$Res>(_self.selection, (value) {
    return _then(_self.copyWith(selection: value));
  });
}
}

/// @nodoc
mixin _$AccountPersonaFormState {

 AccountPersona get persona; AccountPersonaDraft get draft; FormzSubmissionStatus get status;
/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountPersonaFormStateCopyWith<AccountPersonaFormState> get copyWith => _$AccountPersonaFormStateCopyWithImpl<AccountPersonaFormState>(this as AccountPersonaFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountPersonaFormState&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,persona,draft,status);

@override
String toString() {
  return 'AccountPersonaFormState(persona: $persona, draft: $draft, status: $status)';
}


}

/// @nodoc
abstract mixin class $AccountPersonaFormStateCopyWith<$Res>  {
  factory $AccountPersonaFormStateCopyWith(AccountPersonaFormState value, $Res Function(AccountPersonaFormState) _then) = _$AccountPersonaFormStateCopyWithImpl;
@useResult
$Res call({
 AccountPersona persona, AccountPersonaDraft draft, FormzSubmissionStatus status
});


$AccountPersonaCopyWith<$Res> get persona;$AccountPersonaDraftCopyWith<$Res> get draft;

}
/// @nodoc
class _$AccountPersonaFormStateCopyWithImpl<$Res>
    implements $AccountPersonaFormStateCopyWith<$Res> {
  _$AccountPersonaFormStateCopyWithImpl(this._self, this._then);

  final AccountPersonaFormState _self;
  final $Res Function(AccountPersonaFormState) _then;

/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? persona = null,Object? draft = null,Object? status = null,}) {
  return _then(_self.copyWith(
persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AccountPersona,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as AccountPersonaDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,
  ));
}
/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaCopyWith<$Res> get persona {

  return $AccountPersonaCopyWith<$Res>(_self.persona, (value) {
    return _then(_self.copyWith(persona: value));
  });
}/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaDraftCopyWith<$Res> get draft {

  return $AccountPersonaDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountPersonaFormState].
extension AccountPersonaFormStatePatterns on AccountPersonaFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountPersonaFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountPersonaFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountPersonaFormState value)  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountPersonaFormState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountPersona persona,  AccountPersonaDraft draft,  FormzSubmissionStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountPersonaFormState() when $default != null:
return $default(_that.persona,_that.draft,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountPersona persona,  AccountPersonaDraft draft,  FormzSubmissionStatus status)  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaFormState():
return $default(_that.persona,_that.draft,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountPersona persona,  AccountPersonaDraft draft,  FormzSubmissionStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaFormState() when $default != null:
return $default(_that.persona,_that.draft,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AccountPersonaFormState extends AccountPersonaFormState {
  const _AccountPersonaFormState({required this.persona, this.draft = const AccountPersonaDraft(), this.status = FormzSubmissionStatus.initial}): super._();


@override final  AccountPersona persona;
@override@JsonKey() final  AccountPersonaDraft draft;
@override@JsonKey() final  FormzSubmissionStatus status;

/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountPersonaFormStateCopyWith<_AccountPersonaFormState> get copyWith => __$AccountPersonaFormStateCopyWithImpl<_AccountPersonaFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountPersonaFormState&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,persona,draft,status);

@override
String toString() {
  return 'AccountPersonaFormState(persona: $persona, draft: $draft, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AccountPersonaFormStateCopyWith<$Res> implements $AccountPersonaFormStateCopyWith<$Res> {
  factory _$AccountPersonaFormStateCopyWith(_AccountPersonaFormState value, $Res Function(_AccountPersonaFormState) _then) = __$AccountPersonaFormStateCopyWithImpl;
@override @useResult
$Res call({
 AccountPersona persona, AccountPersonaDraft draft, FormzSubmissionStatus status
});


@override $AccountPersonaCopyWith<$Res> get persona;@override $AccountPersonaDraftCopyWith<$Res> get draft;

}
/// @nodoc
class __$AccountPersonaFormStateCopyWithImpl<$Res>
    implements _$AccountPersonaFormStateCopyWith<$Res> {
  __$AccountPersonaFormStateCopyWithImpl(this._self, this._then);

  final _AccountPersonaFormState _self;
  final $Res Function(_AccountPersonaFormState) _then;

/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? persona = null,Object? draft = null,Object? status = null,}) {
  return _then(_AccountPersonaFormState(
persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AccountPersona,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as AccountPersonaDraft,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,
  ));
}

/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaCopyWith<$Res> get persona {

  return $AccountPersonaCopyWith<$Res>(_self.persona, (value) {
    return _then(_self.copyWith(persona: value));
  });
}/// Create a copy of AccountPersonaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaDraftCopyWith<$Res> get draft {

  return $AccountPersonaDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
