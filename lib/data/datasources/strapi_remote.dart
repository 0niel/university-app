import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/story_model.dart';
import 'package:rtu_mirea_app/data/models/update_info_model/update_info_model.dart';

abstract class StrapiRemoteData {
  Future<List<StoryModel>> getStories();
  Future<List<UpdateInfoModel>> getLastUpdateInfo();
}

class StrapiRemoteDataImpl implements StrapiRemoteData {
  static const _apiUrl = 'https://cms.mirea.ninja/api';

  final Dio httpClient;

  StrapiRemoteDataImpl({required this.httpClient});

  @override
  Future<List<StoryModel>> getStories() async {
    final response = await httpClient.get(
      '$_apiUrl/stories?populate[0]=pages.actions&populate[1]=pages.media&populate[2]=author&populate[3]=author.logo&populate[4]=preview',
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      List<StoryModel> stories = [];
      stories = List<StoryModel>.from(responseBody['data'].map((x) => StoryModel.fromJson(x['attributes'])));
      return stories;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<UpdateInfoModel>> getLastUpdateInfo() async {
    final response = await httpClient.get('$_apiUrl/updates?sort=buildNumber:DESC');
    if (response.statusCode == 200) {
      try {
        final responseBody = response.data;
        List<UpdateInfoModel> updatesList = [];
        updatesList = List<UpdateInfoModel>.from(
          responseBody['data'].map((x) => UpdateInfoModel.fromJson(x['attributes'])),
        );
        return updatesList;
      } catch (e) {
        throw ParsingException("Couldn't parse UpdateInfo from strapi remote because $e");
      }
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
