import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';

import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/repositories/strapi_repository.dart';

class StrapiRepositoryImpl implements StrapiRepository {
  final StrapiRemoteData remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  StrapiRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    if (await connectionChecker.hasConnection) {
      try {
        final stories = await remoteDataSource.getStories();

        return Right(stories);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(ServerFailure());
    }
  }
}
