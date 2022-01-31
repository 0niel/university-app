import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetAuthToken extends UseCase<String, void> {
  final UserRepository userRepository;

  GetAuthToken(this.userRepository);

  @override
  Future<Either<Failure, String>> call([params]) async {
    return await userRepository.getAuthToken();
  }
}
