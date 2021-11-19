import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetUserData extends UseCase<User, GetUserDataParams> {
  final UserRepository userRepository;

  GetUserData(this.userRepository);

  @override
  Future<Either<Failure, User>> call(GetUserDataParams params) {
    return userRepository.getUserData(params.token);
  }
}

class GetUserDataParams extends Equatable {
  final String token;
  const GetUserDataParams(this.token);

  @override
  List<Object?> get props => [token];
}
