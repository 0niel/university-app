import 'package:news_page/domain/models/news.dart';
import 'package:news_page/domain/models/tag.dart';

abstract class NewsRepository {
  Future<List<NewsModel>> getNews(int offset, int limit, String tag);
  Future<List<Tag>> getTags();
}
