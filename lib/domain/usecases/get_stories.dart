import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/story.dart';
import 'package:rtu_mirea_app/domain/repositories/stories_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetStories extends UseCase<List<Story>, void> {
  final StoriesRepository strapiRepository;

  GetStories(this.strapiRepository);

  @override
  Future<Either<Failure, List<Story>>> call([params]) {
    return strapiRepository.getStories();
  }
}
