import 'package:rtu_mirea_app/domain/entities/news.dart';
import 'package:rtu_mirea_app/domain/entities/tag.dart';

abstract class NewsRepository {
  Future<List<NewsModel>> getNews(int offset, int limit, String tag);
  Future<List<Tag>> getTags();
}
