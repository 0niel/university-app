import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';
import 'package:rtu_mirea_app/domain/usecases/log_out.dart';

part 'user_event.dart';
part 'user_state.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final LogIn logIn;
  final LogOut logOut;
  final GetUserData getUserData;
  final GetAuthToken getAuthToken;

  UserBloc({
    required this.logIn,
    required this.logOut,
    required this.getUserData,
    required this.getAuthToken,
  }) : super(const _Unauthorized()) {
    on<_LogIn>(_onLogInEvent);
    on<_LogOut>(_onLogOutEvent);
    on<_Started>(_onGetUserDataEvent);
    on<_GetUserData>(_onGetUserDataEvent);
  }

  void _onLogInEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    // We use oauth2 to get token. So we don't need to pass login and password
    // to the server. We just need to pass them to the oauth2 server.

    bool loggedIn = false;

    final logInRes = await logIn();

    logInRes.fold(
      (failure) => emit(_LogInError(
          failure.cause ?? "Ошибка при авторизации. Повторите попытку")),
      (res) {
        loggedIn = true;
      },
    );

    if (loggedIn) {
      emit(const _Loading());
      final user = await getUserData();

      user.fold(
        (failure) => emit(const _Unauthorized()),
        (user) {
          FirebaseAnalytics.instance.logLogin();
          emit(_LogInSuccess(user));
        },
      );
    }
  }

  void _onLogOutEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    final res = await logOut();
    res.fold((failure) => null, (r) => emit(const _Unauthorized()));
  }

  void _onGetUserDataEvent(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    final token = await getAuthToken();

    bool loggedIn = token.isRight();

    if (!loggedIn) return;

    // If token in the storage, user is authorized at least once and we can
    // try to get user data
    emit(const _Loading());
    final user = await getUserData();

    user.fold(
      (failure) => emit(const _Unauthorized()),
      (r) => emit(_LogInSuccess(r)),
    );
  }
}
