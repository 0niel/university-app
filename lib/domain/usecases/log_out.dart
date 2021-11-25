import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class LogOut extends UseCase<void, void> {
  final UserRepository userRepository;

  LogOut(this.userRepository);

  @override
  Future<Either<Failure, void>> call([params]) async {
    return await userRepository.logOut();
  }
}
