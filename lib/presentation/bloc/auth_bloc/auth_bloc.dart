import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn logIn;
  final GetUserData getUserData;
  final GetAuthToken getAuthToken;

  AuthBloc({
    required this.getAuthToken,
    required this.logIn,
    required this.getUserData,
  }) : super(AuthUnknown()) {
    on<AuthLogInEvent>(_onAuthLogIn);
    on<AuthLogInFromCache>(_onAuthLogInFromCache);
  }

  void _onAuthLogInFromCache(
    AuthLogInFromCache event,
    Emitter<AuthState> emit,
  ) async {
    final res = await getAuthToken();
    res.fold(
        (failure) => emit(const LogInError(
            cause: "Сессия устарела. Повторите попытку авторизации")),
        (token) => emit(LogInSuccess(token: token)));
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
        (res) => emit(LogInSuccess(token: res)),
      );
    }
  }
}
