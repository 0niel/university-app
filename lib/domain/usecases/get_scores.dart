import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetScores extends UseCase<Map<String, List<Score>>, GetScoresParams> {
  final UserRepository userRepository;

  GetScores(this.userRepository);

  @override
  Future<Either<Failure, Map<String, List<Score>>>> call(
      GetScoresParams params) {
    return userRepository.getScores(params.token);
  }
}

class GetScoresParams extends Equatable {
  final String token;
  const GetScoresParams(this.token);

  @override
  List<Object?> get props => [token];
}
