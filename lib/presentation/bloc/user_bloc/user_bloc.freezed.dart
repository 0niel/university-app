// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEventCopyWith<$Res> {
  factory $UserEventCopyWith(UserEvent value, $Res Function(UserEvent) then) =
      _$UserEventCopyWithImpl<$Res, UserEvent>;
}

/// @nodoc
class _$UserEventCopyWithImpl<$Res, $Val extends UserEvent>
    implements $UserEventCopyWith<$Res> {
  _$UserEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_StartedCopyWith<$Res> {
  factory _$$_StartedCopyWith(
          _$_Started value, $Res Function(_$_Started) then) =
      __$$_StartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_StartedCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$_Started>
    implements _$$_StartedCopyWith<$Res> {
  __$$_StartedCopyWithImpl(_$_Started _value, $Res Function(_$_Started) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Started implements _Started {
  const _$_Started();

  @override
  String toString() {
    return 'UserEvent.started()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements UserEvent {
  const factory _Started() = _$_Started;
}

/// @nodoc
abstract class _$$_LogInCopyWith<$Res> {
  factory _$$_LogInCopyWith(_$_LogIn value, $Res Function(_$_LogIn) then) =
      __$$_LogInCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LogInCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$_LogIn>
    implements _$$_LogInCopyWith<$Res> {
  __$$_LogInCopyWithImpl(_$_LogIn _value, $Res Function(_$_LogIn) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_LogIn implements _LogIn {
  const _$_LogIn();

  @override
  String toString() {
    return 'UserEvent.logIn()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LogIn);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) {
    return logIn();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) {
    return logIn?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (logIn != null) {
      return logIn();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) {
    return logIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) {
    return logIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (logIn != null) {
      return logIn(this);
    }
    return orElse();
  }
}

abstract class _LogIn implements UserEvent {
  const factory _LogIn() = _$_LogIn;
}

/// @nodoc
abstract class _$$_LogOutCopyWith<$Res> {
  factory _$$_LogOutCopyWith(_$_LogOut value, $Res Function(_$_LogOut) then) =
      __$$_LogOutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LogOutCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$_LogOut>
    implements _$$_LogOutCopyWith<$Res> {
  __$$_LogOutCopyWithImpl(_$_LogOut _value, $Res Function(_$_LogOut) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_LogOut implements _LogOut {
  const _$_LogOut();

  @override
  String toString() {
    return 'UserEvent.logOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_LogOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) {
    return logOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) {
    return logOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (logOut != null) {
      return logOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) {
    return logOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) {
    return logOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (logOut != null) {
      return logOut(this);
    }
    return orElse();
  }
}

abstract class _LogOut implements UserEvent {
  const factory _LogOut() = _$_LogOut;
}

/// @nodoc
abstract class _$$_GetUserDataCopyWith<$Res> {
  factory _$$_GetUserDataCopyWith(
          _$_GetUserData value, $Res Function(_$_GetUserData) then) =
      __$$_GetUserDataCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_GetUserDataCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$_GetUserData>
    implements _$$_GetUserDataCopyWith<$Res> {
  __$$_GetUserDataCopyWithImpl(
      _$_GetUserData _value, $Res Function(_$_GetUserData) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_GetUserData implements _GetUserData {
  const _$_GetUserData();

  @override
  String toString() {
    return 'UserEvent.getUserData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_GetUserData);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) {
    return getUserData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) {
    return getUserData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (getUserData != null) {
      return getUserData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) {
    return getUserData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) {
    return getUserData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (getUserData != null) {
      return getUserData(this);
    }
    return orElse();
  }
}

abstract class _GetUserData implements UserEvent {
  const factory _GetUserData() = _$_GetUserData;
}

/// @nodoc
abstract class _$$_SetAuntificatedDataCopyWith<$Res> {
  factory _$$_SetAuntificatedDataCopyWith(_$_SetAuntificatedData value,
          $Res Function(_$_SetAuntificatedData) then) =
      __$$_SetAuntificatedDataCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$_SetAuntificatedDataCopyWithImpl<$Res>
    extends _$UserEventCopyWithImpl<$Res, _$_SetAuntificatedData>
    implements _$$_SetAuntificatedDataCopyWith<$Res> {
  __$$_SetAuntificatedDataCopyWithImpl(_$_SetAuntificatedData _value,
      $Res Function(_$_SetAuntificatedData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$_SetAuntificatedData(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$_SetAuntificatedData implements _SetAuntificatedData {
  const _$_SetAuntificatedData({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'UserEvent.setAuntificatedData(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SetAuntificatedData &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SetAuntificatedDataCopyWith<_$_SetAuntificatedData> get copyWith =>
      __$$_SetAuntificatedDataCopyWithImpl<_$_SetAuntificatedData>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function() logIn,
    required TResult Function() logOut,
    required TResult Function() getUserData,
    required TResult Function(User user) setAuntificatedData,
  }) {
    return setAuntificatedData(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function()? logIn,
    TResult? Function()? logOut,
    TResult? Function()? getUserData,
    TResult? Function(User user)? setAuntificatedData,
  }) {
    return setAuntificatedData?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function()? logIn,
    TResult Function()? logOut,
    TResult Function()? getUserData,
    TResult Function(User user)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (setAuntificatedData != null) {
      return setAuntificatedData(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_LogIn value) logIn,
    required TResult Function(_LogOut value) logOut,
    required TResult Function(_GetUserData value) getUserData,
    required TResult Function(_SetAuntificatedData value) setAuntificatedData,
  }) {
    return setAuntificatedData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_LogIn value)? logIn,
    TResult? Function(_LogOut value)? logOut,
    TResult? Function(_GetUserData value)? getUserData,
    TResult? Function(_SetAuntificatedData value)? setAuntificatedData,
  }) {
    return setAuntificatedData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_LogIn value)? logIn,
    TResult Function(_LogOut value)? logOut,
    TResult Function(_GetUserData value)? getUserData,
    TResult Function(_SetAuntificatedData value)? setAuntificatedData,
    required TResult orElse(),
  }) {
    if (setAuntificatedData != null) {
      return setAuntificatedData(this);
    }
    return orElse();
  }
}

abstract class _SetAuntificatedData implements UserEvent {
  const factory _SetAuntificatedData({required final User user}) =
      _$_SetAuntificatedData;

  User get user;
  @JsonKey(ignore: true)
  _$$_SetAuntificatedDataCopyWith<_$_SetAuntificatedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorized,
    required TResult Function() loading,
    required TResult Function(String cause) logInError,
    required TResult Function(User user) logInSuccess,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthorized,
    TResult? Function()? loading,
    TResult? Function(String cause)? logInError,
    TResult? Function(User user)? logInSuccess,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorized,
    TResult Function()? loading,
    TResult Function(String cause)? logInError,
    TResult Function(User user)? logInSuccess,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthorized value) unauthorized,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LogInError value) logInError,
    required TResult Function(_LogInSuccess value) logInSuccess,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthorized value)? unauthorized,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LogInError value)? logInError,
    TResult? Function(_LogInSuccess value)? logInSuccess,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthorized value)? unauthorized,
    TResult Function(_Loading value)? loading,
    TResult Function(_LogInError value)? logInError,
    TResult Function(_LogInSuccess value)? logInSuccess,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateCopyWith<$Res> {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) then) =
      _$UserStateCopyWithImpl<$Res, UserState>;
}

/// @nodoc
class _$UserStateCopyWithImpl<$Res, $Val extends UserState>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_UnauthorizedCopyWith<$Res> {
  factory _$$_UnauthorizedCopyWith(
          _$_Unauthorized value, $Res Function(_$_Unauthorized) then) =
      __$$_UnauthorizedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_UnauthorizedCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$_Unauthorized>
    implements _$$_UnauthorizedCopyWith<$Res> {
  __$$_UnauthorizedCopyWithImpl(
      _$_Unauthorized _value, $Res Function(_$_Unauthorized) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Unauthorized implements _Unauthorized {
  const _$_Unauthorized();

  @override
  String toString() {
    return 'UserState.unauthorized()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Unauthorized);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorized,
    required TResult Function() loading,
    required TResult Function(String cause) logInError,
    required TResult Function(User user) logInSuccess,
  }) {
    return unauthorized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthorized,
    TResult? Function()? loading,
    TResult? Function(String cause)? logInError,
    TResult? Function(User user)? logInSuccess,
  }) {
    return unauthorized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorized,
    TResult Function()? loading,
    TResult Function(String cause)? logInError,
    TResult Function(User user)? logInSuccess,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthorized value) unauthorized,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LogInError value) logInError,
    required TResult Function(_LogInSuccess value) logInSuccess,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthorized value)? unauthorized,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LogInError value)? logInError,
    TResult? Function(_LogInSuccess value)? logInSuccess,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthorized value)? unauthorized,
    TResult Function(_Loading value)? loading,
    TResult Function(_LogInError value)? logInError,
    TResult Function(_LogInSuccess value)? logInSuccess,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class _Unauthorized implements UserState {
  const factory _Unauthorized() = _$_Unauthorized;
}

/// @nodoc
abstract class _$$_LoadingCopyWith<$Res> {
  factory _$$_LoadingCopyWith(
          _$_Loading value, $Res Function(_$_Loading) then) =
      __$$_LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_LoadingCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$_Loading>
    implements _$$_LoadingCopyWith<$Res> {
  __$$_LoadingCopyWithImpl(_$_Loading _value, $Res Function(_$_Loading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Loading implements _Loading {
  const _$_Loading();

  @override
  String toString() {
    return 'UserState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorized,
    required TResult Function() loading,
    required TResult Function(String cause) logInError,
    required TResult Function(User user) logInSuccess,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthorized,
    TResult? Function()? loading,
    TResult? Function(String cause)? logInError,
    TResult? Function(User user)? logInSuccess,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorized,
    TResult Function()? loading,
    TResult Function(String cause)? logInError,
    TResult Function(User user)? logInSuccess,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthorized value) unauthorized,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LogInError value) logInError,
    required TResult Function(_LogInSuccess value) logInSuccess,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthorized value)? unauthorized,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LogInError value)? logInError,
    TResult? Function(_LogInSuccess value)? logInSuccess,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthorized value)? unauthorized,
    TResult Function(_Loading value)? loading,
    TResult Function(_LogInError value)? logInError,
    TResult Function(_LogInSuccess value)? logInSuccess,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements UserState {
  const factory _Loading() = _$_Loading;
}

/// @nodoc
abstract class _$$_LogInErrorCopyWith<$Res> {
  factory _$$_LogInErrorCopyWith(
          _$_LogInError value, $Res Function(_$_LogInError) then) =
      __$$_LogInErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({String cause});
}

/// @nodoc
class __$$_LogInErrorCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$_LogInError>
    implements _$$_LogInErrorCopyWith<$Res> {
  __$$_LogInErrorCopyWithImpl(
      _$_LogInError _value, $Res Function(_$_LogInError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cause = null,
  }) {
    return _then(_$_LogInError(
      null == cause
          ? _value.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LogInError implements _LogInError {
  const _$_LogInError(this.cause);

  @override
  final String cause;

  @override
  String toString() {
    return 'UserState.logInError(cause: $cause)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogInError &&
            (identical(other.cause, cause) || other.cause == cause));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cause);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LogInErrorCopyWith<_$_LogInError> get copyWith =>
      __$$_LogInErrorCopyWithImpl<_$_LogInError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorized,
    required TResult Function() loading,
    required TResult Function(String cause) logInError,
    required TResult Function(User user) logInSuccess,
  }) {
    return logInError(cause);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthorized,
    TResult? Function()? loading,
    TResult? Function(String cause)? logInError,
    TResult? Function(User user)? logInSuccess,
  }) {
    return logInError?.call(cause);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorized,
    TResult Function()? loading,
    TResult Function(String cause)? logInError,
    TResult Function(User user)? logInSuccess,
    required TResult orElse(),
  }) {
    if (logInError != null) {
      return logInError(cause);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthorized value) unauthorized,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LogInError value) logInError,
    required TResult Function(_LogInSuccess value) logInSuccess,
  }) {
    return logInError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthorized value)? unauthorized,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LogInError value)? logInError,
    TResult? Function(_LogInSuccess value)? logInSuccess,
  }) {
    return logInError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthorized value)? unauthorized,
    TResult Function(_Loading value)? loading,
    TResult Function(_LogInError value)? logInError,
    TResult Function(_LogInSuccess value)? logInSuccess,
    required TResult orElse(),
  }) {
    if (logInError != null) {
      return logInError(this);
    }
    return orElse();
  }
}

abstract class _LogInError implements UserState {
  const factory _LogInError(final String cause) = _$_LogInError;

  String get cause;
  @JsonKey(ignore: true)
  _$$_LogInErrorCopyWith<_$_LogInError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_LogInSuccessCopyWith<$Res> {
  factory _$$_LogInSuccessCopyWith(
          _$_LogInSuccess value, $Res Function(_$_LogInSuccess) then) =
      __$$_LogInSuccessCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});
}

/// @nodoc
class __$$_LogInSuccessCopyWithImpl<$Res>
    extends _$UserStateCopyWithImpl<$Res, _$_LogInSuccess>
    implements _$$_LogInSuccessCopyWith<$Res> {
  __$$_LogInSuccessCopyWithImpl(
      _$_LogInSuccess _value, $Res Function(_$_LogInSuccess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$_LogInSuccess(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$_LogInSuccess implements _LogInSuccess {
  const _$_LogInSuccess(this.user);

  @override
  final User user;

  @override
  String toString() {
    return 'UserState.logInSuccess(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LogInSuccess &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LogInSuccessCopyWith<_$_LogInSuccess> get copyWith =>
      __$$_LogInSuccessCopyWithImpl<_$_LogInSuccess>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unauthorized,
    required TResult Function() loading,
    required TResult Function(String cause) logInError,
    required TResult Function(User user) logInSuccess,
  }) {
    return logInSuccess(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unauthorized,
    TResult? Function()? loading,
    TResult? Function(String cause)? logInError,
    TResult? Function(User user)? logInSuccess,
  }) {
    return logInSuccess?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unauthorized,
    TResult Function()? loading,
    TResult Function(String cause)? logInError,
    TResult Function(User user)? logInSuccess,
    required TResult orElse(),
  }) {
    if (logInSuccess != null) {
      return logInSuccess(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Unauthorized value) unauthorized,
    required TResult Function(_Loading value) loading,
    required TResult Function(_LogInError value) logInError,
    required TResult Function(_LogInSuccess value) logInSuccess,
  }) {
    return logInSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Unauthorized value)? unauthorized,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_LogInError value)? logInError,
    TResult? Function(_LogInSuccess value)? logInSuccess,
  }) {
    return logInSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Unauthorized value)? unauthorized,
    TResult Function(_Loading value)? loading,
    TResult Function(_LogInError value)? logInError,
    TResult Function(_LogInSuccess value)? logInSuccess,
    required TResult orElse(),
  }) {
    if (logInSuccess != null) {
      return logInSuccess(this);
    }
    return orElse();
  }
}

abstract class _LogInSuccess implements UserState {
  const factory _LogInSuccess(final User user) = _$_LogInSuccess;

  User get user;
  @JsonKey(ignore: true)
  _$$_LogInSuccessCopyWith<_$_LogInSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
