import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class LogIn extends UseCase<String, LogInParams> {
  final UserRepository userRepository;

  LogIn(this.userRepository);

  @override
  Future<Either<Failure, String>> call(LogInParams params) async {
    return userRepository.logIn(params.login, params.password);
  }
}

class LogInParams extends Equatable {
  final String login;
  final String password;

  const LogInParams(this.login, this.password);

  @override
  List<Object?> get props => [login, password];
}
