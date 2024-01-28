import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/domain/entities/student.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';
import 'package:rtu_mirea_app/domain/usecases/log_out.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.g.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  final LogIn logIn;
  final LogOut logOut;
  final GetUserData getUserData;
  final GetAuthToken getAuthToken;

  UserBloc({
    required this.logIn,
    required this.logOut,
    required this.getUserData,
    required this.getAuthToken,
  }) : super(const UserState()) {
    on<LogInEvent>(_onLogInEvent);
    on<LogOutEvent>(_onLogOutEvent);
    on<Started>(_onGetUserDataEvent);
    on<GetUserDataEvent>(_onGetUserDataEvent);
    on<SetAuthenticatedData>(_onSetAuntificatedDataEvent);
  }

  void _onSetAuntificatedDataEvent(
    SetAuthenticatedData event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.authorized, user: event.user));
  }

  void _setSentryUserIdentity(String id, String email, String group) {
    Sentry.configureScope((scope) => scope.setUser(SentryUser(id: id, email: email, data: {'group': group})));
  }

  void _onLogInEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state.status == UserStatus.authorized) return;

    // We use oauth2 to get token. So we don't need to pass login and password
    // to the server. We just need to pass them to the oauth2 server.

    bool loggedIn = false;

    final logInRes = await logIn();

    logInRes.fold(
      (failure) => emit(state.copyWith(status: UserStatus.authorizeError)),
      (res) {
        loggedIn = true;
      },
    );

    if (loggedIn) {
      emit(state.copyWith(status: UserStatus.loading));
      final user = await getUserData();

      user.fold(
        (failure) => emit(state.copyWith(status: UserStatus.unauthorized)),
        (user) {
          var student = getActiveStudent(user);

          _setSentryUserIdentity(user.id.toString(), user.login, student.academicGroup);
          emit(state.copyWith(status: UserStatus.authorized, user: user));
        },
      );
    }
  }

  void _onLogOutEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    await logOut();
    emit(const UserState(status: UserStatus.unauthorized));
  }

  static Student getActiveStudent(User user) {
    var student = user.students.firstWhereOrNull((element) => element.status == 'активный');
    student ??= user.students.first;
    return student;
  }

  void _onGetUserDataEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state.status == UserStatus.authorized) return;

    final token = await getAuthToken();

    bool loggedIn = token.isRight();

    if (!loggedIn) {
      emit(state.copyWith(status: UserStatus.unauthorized));
      return;
    }

    // If token in the storage, user is authorized at least once and we can
    // try to get user data
    emit(state.copyWith(status: UserStatus.loading));
    final user = await getUserData();

    user.fold((failure) => emit(state.copyWith(status: UserStatus.unauthorized)), (r) {
      var student = getActiveStudent(r);

      _setSentryUserIdentity(r.id.toString(), r.login, student.academicGroup);
      emit(state.copyWith(status: UserStatus.authorized, user: r));
    });
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) => UserState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserState state) => state.toJson();
}
