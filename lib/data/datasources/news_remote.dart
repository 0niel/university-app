import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/news_item_model.dart';

abstract class NewsRemoteData {
  Future<List<NewsItemModel>> getNews(int offset, int limit, [String? tag]);
  Future<List<String>> getTags();
}

class NewsRemoteDataImpl extends NewsRemoteData {
  static const _apiUrl = "http://schedule.mirea.ninja:5050";

  final Dio httpClient;

  NewsRemoteDataImpl({required this.httpClient});

  @override
  Future<List<NewsItemModel>> getNews(int offset, int limit,
      [String? tag]) async {
    try {
      final response = await httpClient
          .get(_apiUrl + '/news' + '?tag=$tag&limit=$limit&offset=$offset');

      if (response.statusCode == 200) {
        Map responseBody = response.data;
        return responseBody["news"]
            .map<NewsItemModel>((newsItem) => NewsItemModel.fromJson(newsItem))
            .toList();
      } else {
        throw ServerException('Response status code is $response.statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getTags() async {
    try {
      final response = await httpClient.get(_apiUrl + '/tags');

      if (response.statusCode == 200) {
        Map responseBody = response.data;

        List<String> tags = [];
        tags = List<String>.from(responseBody["tags"].map((x) => x['name']));
        return tags;
      } else {
        throw ServerException('Response status code is $response.statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
