import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';
import 'package:rtu_mirea_app/domain/usecases/log_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn logIn;
  final LogOut logOut;
  final GetUserData getUserData;
  final GetAuthToken getAuthToken;

  AuthBloc({
    required this.getAuthToken,
    required this.logIn,
    required this.logOut,
    required this.getUserData,
  }) : super(AuthUnknown()) {
    on<AuthLogInEvent>(_onAuthLogIn);
    on<AuthLogInFromCache>(_onAuthLogInFromCache);
    on<AuthLogOut>(_onAuthLogOut);
  }

  void _onAuthLogInFromCache(
    AuthLogInFromCache event,
    Emitter<AuthState> emit,
  ) async {
    final res = await getAuthToken();
    res.fold((failure) => emit(const LogInError(cause: '')),
        (token) => emit(LogInSuccess(token: token)));
  }

  void _onAuthLogOut(
    AuthLogOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await logOut();
    res.fold((failure) => null, (r) => emit(AuthUnauthorized()));
  }

  void _onAuthLogIn(
    AuthLogInEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event is AuthLogInEvent) {
      if (event.login.length < 4 || event.password.length < 4) {
        return emit(
            const LogInError(cause: "Введёт неверный логин или пароль"));
      }

      final res = await logIn(LogInParams(event.login, event.password));
      res.fold(
        (failure) => emit(LogInError(
            cause: failure.cause ??
                "Ошибка при авторизации. Повторите попытку позже")),
        (res) {
          emit(LogInSuccess(token: res));
          FirebaseAnalytics.instance.logLogin();
        },
      );
    }
  }
}
