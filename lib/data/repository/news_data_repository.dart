import 'package:news_page/domain/models/news.dart';
import 'package:news_page/domain/models/tag.dart';
import 'package:news_page/domain/repository/news_repository.dart';
import 'package:news_page/data/datasources/news_service.dart';

class NewsDataRepository extends NewsRepository {
  NewsService news_service;

  NewsDataRepository(this.news_service);

  @override
  Future<List<News_model>> getNews(int offset, int limit, String tag) async {
    return news_service.getNews(offset, limit, tag);
  }

  @override
  Future<List<Tag>> getTags() async {
    return news_service.getTags();
  }
}
