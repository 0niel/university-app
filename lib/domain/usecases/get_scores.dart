import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetScores extends UseCase<Map<String, Map<String, List<Score>>>, void> {
  final UserRepository userRepository;

  GetScores(this.userRepository);

  @override
  Future<Either<Failure, Map<String, Map<String, List<Score>>>>> call([params]) async {
    return userRepository.getScores();
  }
}
