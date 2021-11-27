import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/story_model.dart';

abstract class StrapiRemoteData {
  Future<List<StoryModel>> getStories();
}

class StrapiRemoteDataImpl implements StrapiRemoteData {
  static const _apiUrl = 'https://cms.mirea.ninja/';

  final Dio httpClient;

  StrapiRemoteDataImpl({required this.httpClient});

  @override
  Future<List<StoryModel>> getStories() async {
    final response = await httpClient.get(_apiUrl + 'stories');
    if (response.statusCode == 200) {
      final responseBody = response.data;
      List<StoryModel> stories = [];
      stories = List<StoryModel>.from(
          responseBody.map((x) => StoryModel.fromJson(x)));
      return stories;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
