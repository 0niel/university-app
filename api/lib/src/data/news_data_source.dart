import 'package:flutter_news_example_api/api.dart';
import 'package:flutter_news_example_api/src/data/models/models.dart';

abstract class NewsDataSource {
  Future<List<String>> getCategories();

  Future<List<NewsItem>> getNews({
    int limit = 20,
    int offset = 0,
    String? category,
  });

  Future<List<NewsItem>> getAds({
    int limit = 20,
    int offset = 0,
  });
}
