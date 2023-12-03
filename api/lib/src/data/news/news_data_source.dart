import 'package:university_app_server_api/src/data/news/models/models.dart';

abstract class NewsDataSource {
  Future<List<String>> getCategories();

  Future<List<Article>> getNews({
    int limit = 20,
    int offset = 0,
    String? category,
  });

  Future<List<Article>> getAds({
    int limit = 20,
    int offset = 0,
  });
}
