import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';

abstract class StrapiRepository {
  Future<Either<Failure, List<Story>>> getStories();
}
