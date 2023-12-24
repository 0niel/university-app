import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';

abstract class StoriesRepository {
  Future<Either<Failure, List<Story>>> getStories();
}
