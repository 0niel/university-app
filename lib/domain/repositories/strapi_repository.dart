import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';

abstract class StrapiRepository {
  Future<Either<Failure, List<Story>>> getStories();
  Future<Either<Failure, UpdateInfo>> getLastUpdateInfo();
}
