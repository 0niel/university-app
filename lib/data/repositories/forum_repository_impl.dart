import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/forum_local.dart';
import 'package:rtu_mirea_app/data/datasources/forum_remote.dart';
import 'package:rtu_mirea_app/domain/entities/forum_member.dart';
import 'package:rtu_mirea_app/domain/repositories/forum_repository.dart';

class ForumRepositoryImpl implements ForumRepository {
  final InternetConnectionChecker connectionChecker;
  final ForumRemoteData remoteDataSource;
  final ForumLocalData localDataSource;

  ForumRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<ForumMember>>> getPatrons() async {
    if (await connectionChecker.hasConnection) {
      try {
        final patrons = await remoteDataSource.getPatrons();
        localDataSource.setPatronsToCache(patrons);
        return Right(patrons);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      try {
        final patrons = await localDataSource.getPatronsFromCache();
        return Right(patrons);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
