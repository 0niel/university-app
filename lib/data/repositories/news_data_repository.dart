import 'package:rtu_mirea_app/domain/entities/news.dart';
import 'package:rtu_mirea_app/domain/entities/tag.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/data/datasources/news_service.dart';

class NewsDataRepository extends NewsRepository {
  NewsService news_service;

  NewsDataRepository(this.news_service);

  @override
  Future<List<NewsModel>> getNews(int offset, int limit, String tag) async {
    return news_service.getNews(offset, limit, tag);
  }

  @override
  Future<List<Tag>> getTags() async {
    return news_service.getTags();
  }
}
