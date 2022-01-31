import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';
import 'package:rtu_mirea_app/domain/repositories/github_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetContributors extends UseCase<List<Contributor>, void> {
  final GithubRepository githubRepository;

  GetContributors(this.githubRepository);

  @override
  Future<Either<Failure, List<Contributor>>> call([params]) async {
    return await githubRepository.getContributors();
  }
}
