import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/forum_member_model.dart';

abstract class ForumRemoteData {
  Future<List<ForumMemberModel>> getPatrons();
}

class ForumRemoteDataImpl implements ForumRemoteData {
  static const String _apiUrl = 'https://mirea.ninja/';

  final Dio httpClient;

  ForumRemoteDataImpl({required this.httpClient});

  @override
  Future<List<ForumMemberModel>> getPatrons() async {
    final response = await httpClient.get(_apiUrl +
        'groups/patrons/members.json?offset=0&order=&asc=true&filter=');
    if (response.statusCode == 200) {
      Map responseBody = response.data;
      List<ForumMemberModel> patrons = [];
      patrons = List<ForumMemberModel>.from(
          responseBody['members'].map((x) => ForumMemberModel.fromJson(x)));
      return patrons;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
