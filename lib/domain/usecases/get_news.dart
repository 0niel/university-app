import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetNews extends UseCase<List<NewsItem>, GetNewsParams> {
  final NewsRepository newsRepository;

  GetNews(this.newsRepository);

  @override
  Future<Either<Failure, List<NewsItem>>> call(GetNewsParams params) async {
    return await newsRepository.getNews(
        params.offset, params.limit, params.isImportant, params.tag);
  }
}

class GetNewsParams extends Equatable {
  final int offset;
  final int limit;
  final bool isImportant;
  final String? tag;

  const GetNewsParams({
    required this.offset,
    required this.limit,
    required this.isImportant,
    this.tag,
  });

  @override
  List<Object?> get props => [offset, limit, isImportant, tag];
}
