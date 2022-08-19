import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetNewsTags extends UseCase<List<String>, void> {
  final NewsRepository newsRepository;

  GetNewsTags(this.newsRepository);

  @override
  Future<Either<Failure, List<String>>> call([params]) async {
    return await newsRepository.getTags();
  }
}
