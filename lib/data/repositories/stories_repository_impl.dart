import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';

import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/repositories/stories_repository.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final StrapiRemoteData remoteDataSource;

  StoriesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Story>>> getStories() async {
    try {
      final stories = await remoteDataSource.getStories();

      return Right(stories);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
