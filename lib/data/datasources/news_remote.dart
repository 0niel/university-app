import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/news_item_model.dart';

abstract class NewsRemoteData {
  Future<List<NewsItemModel>> getNews(int page, int pageSize, bool isImportant, [String? tag]);
  Future<List<String>> getTags();
}

class NewsRemoteDataImpl extends NewsRemoteData {
  // Available methods: getNews, getEvents, getAds.
  static const _apiUrl = "https://mirea.ru/api/oCoGUGuMhQzPEDJYF6Qy.php";
  static const _maxRetries = 3;

  final Dio httpClient;

  NewsRemoteDataImpl({Dio? httpClient}) : httpClient = httpClient ?? Dio();

  @override
  Future<List<NewsItemModel>> getNews(int page, int pageSize, bool isImportant, [String? tag]) async {
    String params = 'nPageSize=$pageSize&iNumPage=$page${tag != null ? "&tag=$tag" : ""}';
    String url = !isImportant ? '$_apiUrl?method=getNews&$params' : '$_apiUrl?method=getAds&$params';

    int retries = 0;
    while (retries < _maxRetries) {
      try {
        final response = await httpClient.get(url);

        if (response.statusCode == 200) {
          Map responseBody = response.data;

          if (responseBody.containsKey("result") && responseBody["result"] != null) {
            List<NewsItemModel> news =
                responseBody["result"].map<NewsItemModel>((newsItem) => NewsItemModel.fromJson(newsItem)).toList();

            return news;
          } else {
            return [];
          }
        } else {
          throw ServerException('Response status code is ${response.statusCode}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 500 && retries < _maxRetries - 1) {
          // Wait before retrying (exponential backoff)
          await Future.delayed(Duration(milliseconds: 500 * (retries + 1)));
          retries++;
          continue;
        }

        // If we've exhausted retries or it's not a 500 error, throw a more specific exception
        String message = 'Network error occurred';
        if (e.response != null) {
          message = 'Server error with status ${e.response?.statusCode}';
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'Connection timeout';
        }
        throw ServerException(message);
      } catch (e) {
        throw ServerException('Unexpected error: $e');
      }
    }

    throw ServerException('Failed after $_maxRetries retries');
  }

  @override
  Future<List<String>> getTags() async {
    int retries = 0;
    while (retries < _maxRetries) {
      try {
        final response = await httpClient.get('$_apiUrl?method=getNewsTags');

        if (response.statusCode == 200) {
          Map responseBody = response.data;

          if (responseBody.containsKey("result") && responseBody["result"] != null) {
            final tagsResponse = (responseBody["result"] as List).map((e) => e as Map<String, dynamic>);
            final tags = tagsResponse.where((element) => int.parse(element["CNT"] ?? '0') > 3).map((e) => e["NAME"]!);
            return tags.toList().cast<String>();
          } else {
            return [];
          }
        } else {
          throw ServerException('Response status code is ${response.statusCode}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 500 && retries < _maxRetries - 1) {
          await Future.delayed(Duration(milliseconds: 500 * (retries + 1)));
          retries++;
          continue;
        }

        String message = 'Network error occurred';
        if (e.response != null) {
          message = 'Server error with status ${e.response?.statusCode}';
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          message = 'Connection timeout';
        }
        throw ServerException(message);
      } catch (e) {
        throw ServerException('Unexpected error: $e');
      }
    }

    throw ServerException('Failed after $_maxRetries retries');
  }
}
