import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/contributor_model.dart';

abstract class GithubRemoteData {
  Future<List<ContributorModel>> getContributors();
}

class GithubRemoteDataImpl implements GithubRemoteData {
  static const _apiUrl =
      'https://api.github.com/repos/Ninja-Official/rtu-mirea-mobile/contributors';

  final Dio httpClient;

  GithubRemoteDataImpl({required this.httpClient});

  @override
  Future<List<ContributorModel>> getContributors() async {
    try {
      final response = await httpClient.get(_apiUrl);
      if (response.statusCode == 200) {
        final responseBody = response.data;
        List<ContributorModel> contributors = [];
        contributors = List<ContributorModel>.from(
            responseBody.map((x) => ContributorModel.fromJson(x)));
        return contributors;
      } else {
        throw ServerException('Response status code is $response.statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
