import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/story_model.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';

abstract class StrapiRemoteData {
  Future<List<StoryModel>> getStories();
  Future<UpdateInfo> getLastUpdateInfo();
}

class StrapiRemoteDataImpl implements StrapiRemoteData {
  static const _apiUrl = 'https://cms.mirea.ninja/api';

  final Dio httpClient;

  StrapiRemoteDataImpl({required this.httpClient});

  @override
  Future<List<StoryModel>> getStories() async {
    final response = await httpClient.get(_apiUrl +
        '/stories?populate[0]=pages.actions&populate[1]=pages.media&populate[2]=author&populate[3]=author.logo&populate[4]=preview');
    if (response.statusCode == 200) {
      final responseBody = response.data;
      List<StoryModel> stories = [];
      stories = List<StoryModel>.from(responseBody['data']
          .map((x) => StoryModel.fromJson(x['attributes'])));
      return stories;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<UpdateInfo> getLastUpdateInfo() async {
    final response = await httpClient.get(_apiUrl + '/updates');
    if (response.statusCode == 200) {
      try {
        final listOfUpdates = response.data['data'] as List;
        final raw = listOfUpdates.last['attributes'];

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final appVersion = packageInfo.version;

        return UpdateInfo(
          title: raw['title'],
          description: raw['description'],
          changeLog: raw['text'],
          serverVersion: raw['appVersion'],
          appVersion: appVersion,
        );
      } catch (e) {
        throw ParsingException(
          "Couldn't parse UpdateInfo from strapi remote because $e",
        );
      }
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
