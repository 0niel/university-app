import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetUserData extends UseCase<User, void> {
  final UserRepository userRepository;

  GetUserData(this.userRepository);

  @override
  Future<Either<Failure, User>> call([params]) async {
    return userRepository.getUserData();
  }
}
