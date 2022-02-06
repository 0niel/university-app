import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';

import 'package:rtu_mirea_app/common/errors/failures.dart';
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
  Future<Either<Failure, UpdateInfo>> getLastUpdateInfo() async {
    if (await connectionChecker.hasConnection) {
      try {
        final updateInfoModal = await remoteDataSource.getLastUpdateInfo();

        return Right(
          UpdateInfo(
            title: updateInfoModal.title,
            description: updateInfoModal.description,
            changeLog: updateInfoModal.changeLog,
            serverVersion: updateInfoModal.serverVersion,
            appVersion: packageInfo.version,
          ),
        );
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
