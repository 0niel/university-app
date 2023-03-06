import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';

import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/common/utils/connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';
import 'package:rtu_mirea_app/domain/repositories/strapi_repository.dart';

class StrapiRepositoryImpl implements StrapiRepository {
  final StrapiRemoteData remoteDataSource;
  final InternetConnectionChecker connectionChecker;
  final PackageInfo packageInfo;

  StrapiRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
    required this.packageInfo,
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

  @override
  Future<Either<Failure, UpdateInfo?>> getLastUpdateInfo() async {
    if (await connectionChecker.hasConnection) {
      try {
        final updatesList = await remoteDataSource.getLastUpdateInfo();
        final currentBuildNumber = int.parse(packageInfo.buildNumber);
        for (final updateInfo in updatesList) {
          if (updateInfo.buildNumber > currentBuildNumber) {
            return Right(UpdateInfo(
              appVersion: updateInfo.appVersion,
              title: updateInfo.title,
              description: updateInfo.description,
              text: updateInfo.text,
              buildNumber: updateInfo.buildNumber,
            ));
          }
        }
        return const Right(null);
      } on ParsingException catch (e) {
        return Left(ServerFailure(e.cause));
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(ServerFailure());
    }
  }
}
