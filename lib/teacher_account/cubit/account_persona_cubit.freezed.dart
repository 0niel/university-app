// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_persona_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountPersonaState {

 AccountPersona get persona; bool get loaded; AccountPersonaOperation get operation; AccountPersonaEdit? get pendingEdit; bool get entryRequested;
/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountPersonaStateCopyWith<AccountPersonaState> get copyWith => _$AccountPersonaStateCopyWithImpl<AccountPersonaState>(this as AccountPersonaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountPersonaState&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.pendingEdit, pendingEdit) || other.pendingEdit == pendingEdit)&&(identical(other.entryRequested, entryRequested) || other.entryRequested == entryRequested));
}


@override
int get hashCode => Object.hash(runtimeType,persona,loaded,operation,pendingEdit,entryRequested);

@override
String toString() {
  return 'AccountPersonaState(persona: $persona, loaded: $loaded, operation: $operation, pendingEdit: $pendingEdit, entryRequested: $entryRequested)';
}


}

/// @nodoc
abstract mixin class $AccountPersonaStateCopyWith<$Res>  {
  factory $AccountPersonaStateCopyWith(AccountPersonaState value, $Res Function(AccountPersonaState) _then) = _$AccountPersonaStateCopyWithImpl;
@useResult
$Res call({
 AccountPersona persona, bool loaded, AccountPersonaOperation operation, AccountPersonaEdit? pendingEdit, bool entryRequested
});


$AccountPersonaCopyWith<$Res> get persona;

}
/// @nodoc
class _$AccountPersonaStateCopyWithImpl<$Res>
    implements $AccountPersonaStateCopyWith<$Res> {
  _$AccountPersonaStateCopyWithImpl(this._self, this._then);

  final AccountPersonaState _self;
  final $Res Function(AccountPersonaState) _then;

/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? persona = null,Object? loaded = null,Object? operation = null,Object? pendingEdit = freezed,Object? entryRequested = null,}) {
  return _then(_self.copyWith(
persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AccountPersona,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as AccountPersonaOperation,pendingEdit: freezed == pendingEdit ? _self.pendingEdit : pendingEdit // ignore: cast_nullable_to_non_nullable
as AccountPersonaEdit?,entryRequested: null == entryRequested ? _self.entryRequested : entryRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaCopyWith<$Res> get persona {

  return $AccountPersonaCopyWith<$Res>(_self.persona, (value) {
    return _then(_self.copyWith(persona: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountPersonaState].
extension AccountPersonaStatePatterns on AccountPersonaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountPersonaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountPersonaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountPersonaState value)  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountPersonaState value)?  $default,){
final _that = this;
switch (_that) {
case _AccountPersonaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccountPersona persona,  bool loaded,  AccountPersonaOperation operation,  AccountPersonaEdit? pendingEdit,  bool entryRequested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountPersonaState() when $default != null:
return $default(_that.persona,_that.loaded,_that.operation,_that.pendingEdit,_that.entryRequested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccountPersona persona,  bool loaded,  AccountPersonaOperation operation,  AccountPersonaEdit? pendingEdit,  bool entryRequested)  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaState():
return $default(_that.persona,_that.loaded,_that.operation,_that.pendingEdit,_that.entryRequested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccountPersona persona,  bool loaded,  AccountPersonaOperation operation,  AccountPersonaEdit? pendingEdit,  bool entryRequested)?  $default,) {final _that = this;
switch (_that) {
case _AccountPersonaState() when $default != null:
return $default(_that.persona,_that.loaded,_that.operation,_that.pendingEdit,_that.entryRequested);case _:
  return null;

}
}

}

/// @nodoc


class _AccountPersonaState extends AccountPersonaState {
  const _AccountPersonaState({this.persona = AccountPersona.empty, this.loaded = false, this.operation = AccountPersonaOperation.idle, this.pendingEdit, this.entryRequested = false}): super._();


@override@JsonKey() final  AccountPersona persona;
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  AccountPersonaOperation operation;
@override final  AccountPersonaEdit? pendingEdit;
@override@JsonKey() final  bool entryRequested;

/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountPersonaStateCopyWith<_AccountPersonaState> get copyWith => __$AccountPersonaStateCopyWithImpl<_AccountPersonaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountPersonaState&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.pendingEdit, pendingEdit) || other.pendingEdit == pendingEdit)&&(identical(other.entryRequested, entryRequested) || other.entryRequested == entryRequested));
}


@override
int get hashCode => Object.hash(runtimeType,persona,loaded,operation,pendingEdit,entryRequested);

@override
String toString() {
  return 'AccountPersonaState(persona: $persona, loaded: $loaded, operation: $operation, pendingEdit: $pendingEdit, entryRequested: $entryRequested)';
}


}

/// @nodoc
abstract mixin class _$AccountPersonaStateCopyWith<$Res> implements $AccountPersonaStateCopyWith<$Res> {
  factory _$AccountPersonaStateCopyWith(_AccountPersonaState value, $Res Function(_AccountPersonaState) _then) = __$AccountPersonaStateCopyWithImpl;
@override @useResult
$Res call({
 AccountPersona persona, bool loaded, AccountPersonaOperation operation, AccountPersonaEdit? pendingEdit, bool entryRequested
});


@override $AccountPersonaCopyWith<$Res> get persona;

}
/// @nodoc
class __$AccountPersonaStateCopyWithImpl<$Res>
    implements _$AccountPersonaStateCopyWith<$Res> {
  __$AccountPersonaStateCopyWithImpl(this._self, this._then);

  final _AccountPersonaState _self;
  final $Res Function(_AccountPersonaState) _then;

/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? persona = null,Object? loaded = null,Object? operation = null,Object? pendingEdit = freezed,Object? entryRequested = null,}) {
  return _then(_AccountPersonaState(
persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AccountPersona,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as AccountPersonaOperation,pendingEdit: freezed == pendingEdit ? _self.pendingEdit : pendingEdit // ignore: cast_nullable_to_non_nullable
as AccountPersonaEdit?,entryRequested: null == entryRequested ? _self.entryRequested : entryRequested // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AccountPersonaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountPersonaCopyWith<$Res> get persona {

  return $AccountPersonaCopyWith<$Res>(_self.persona, (value) {
    return _then(_self.copyWith(persona: value));
  });
}
}

// dart format on
