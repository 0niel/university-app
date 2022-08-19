import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/news_item_model.dart';

abstract class NewsRemoteData {
  Future<List<NewsItemModel>> getNews(int offset, int limit, bool isImportant,
      [String? tag]);
  Future<List<String>> getTags();
}

class NewsRemoteDataImpl extends NewsRemoteData {
  static const _apiUrl = "https://cms.mirea.ninja/api";

  final Dio httpClient;

  NewsRemoteDataImpl({required this.httpClient});

  @override
  Future<List<NewsItemModel>> getNews(int offset, int limit, bool isImportant,
      [String? tag]) async {
    final String tagsFilter =
        tag != null ? "&filters[tags][name][\$eq]=$tag" : "";
    final String requestUrl = _apiUrl +
        '/announcements?populate=*&pagination[limit]=$limit&pagination[start]=$offset&sort=date:DESC&filters[isImportant][\$eq]=${isImportant.toString()}' +
        tagsFilter;

    final response = await httpClient.get(requestUrl);

    if (response.statusCode == 200) {
      Map responseBody = response.data;
      return responseBody["data"]
          .map<NewsItemModel>(
              (newsItem) => NewsItemModel.fromJson(newsItem["attributes"]))
          .toList();
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<String>> getTags() async {
    final response = await httpClient.get(_apiUrl + '/tags');

    if (response.statusCode == 200) {
      Map responseBody = response.data;

      List<String> tags = [];
      tags = List<String>.from(
          responseBody["data"].map((x) => x['attributes']['name']));
      return tags;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
