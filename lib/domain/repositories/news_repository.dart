import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsItem>>> getNews(
      int offset, int limit, bool isImportant, String? tag);
  Future<Either<Failure, List<String>>> getTags();
}
