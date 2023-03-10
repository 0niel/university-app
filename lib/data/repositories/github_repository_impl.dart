import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/common/utils/connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/github_local.dart';
import 'package:rtu_mirea_app/data/datasources/github_remote.dart';
import 'package:rtu_mirea_app/domain/entities/contributor.dart';
import 'package:rtu_mirea_app/domain/repositories/github_repository.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteData remoteDataSource;
  final GithubLocalData localDataSource;
  final InternetConnectionChecker connectionChecker;

  GithubRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Contributor>>> getContributors() async {
    if (await connectionChecker.hasConnection) {
      try {
        final contributors = await remoteDataSource.getContributors();
        localDataSource.setContributorsToCache(contributors);
        return Right(contributors);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final contributors = await localDataSource.getContributorsFromCache();
        return Right(contributors);
      } on CacheException {
        return const Left(CacheFailure());
      }
    }
  }
}
