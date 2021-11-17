import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn logIn;
  final GetUserData getUserData;

  AuthBloc({required this.logIn, required this.getUserData})
      : super(AuthInitial()) {
    on<AuthLogInEvent>(_onAuthLogIn);
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
        (r) => emit(LogInSuccess()),
      );
    }
  }
}
