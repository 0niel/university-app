import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/news_item_model.dart';

abstract class NewsRemoteData {
  Future<List<NewsItemModel>> getNews(int page, int pageSize, bool isImportant, [String? tag]);
  Future<List<String>> getTags();
}

class NewsRemoteDataImpl extends NewsRemoteData {
  // Доступны методы: getNews, getEvents, getAds.
  static const _apiUrl = "https://mirea.ru/api/oCoGUGuMhQzPEDJYF6Qy.php";

  final Dio httpClient;

  NewsRemoteDataImpl({required this.httpClient});

  @override
  Future<List<NewsItemModel>> getNews(int page, int pageSize, bool isImportant, [String? tag]) async {
    String params = 'nPageSize=$pageSize&iNumPage=$page${tag != null ? "&tag=$tag" : ""}';

    Response response;
    if (!isImportant) {
      response = await httpClient.get('$_apiUrl?method=getNews&$params');
    } else {
      response = await httpClient.get('$_apiUrl?method=getAds&$params');
    }

    if (response.statusCode == 200) {
      Map responseBody = response.data;

      List<NewsItemModel> news =
          responseBody["result"].map<NewsItemModel>((newsItem) => NewsItemModel.fromJson(newsItem)).toList();

      return news;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<String>> getTags() async {
    final response = await httpClient.get('$_apiUrl?method=getNewsTags');

    if (response.statusCode == 200) {
      Map responseBody = response.data;

      final tagsResponse = responseBody["result"].map((e) => e as Map<String, dynamic>);

      final tags = tagsResponse.where((element) => int.parse(element["CNT"]) > 3).map((e) => e["NAME"]!);

      return tags.toList().cast<String>();
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
