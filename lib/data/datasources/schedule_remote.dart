import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';

abstract class ScheduleRemoteData {
  Future<ScheduleModel> getScheduleByGroup(String group);
  Future<List<String>> getGroups();
}

class ScheduleRemoteDataImpl implements ScheduleRemoteData {
  static const _apiUrl = 'http://schedule.mirea.ninja:5000/api/';

  final Dio httpClient;

  ScheduleRemoteDataImpl({required this.httpClient});

  @override
  Future<List<String>> getGroups() async {
    try {
      final response = await httpClient.get(_apiUrl + 'schedule/groups');
      if (response.statusCode == 200) {
        Map responseBody = response.data;
        List<String> groups = [];
        groups = List<String>.from(responseBody["groups"].map((x) => x));
        return groups;
      } else {
        throw ServerException('Response status code is $response.statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ScheduleModel> getScheduleByGroup(String group) async {
    try {
      final response =
          await httpClient.get(_apiUrl + 'schedule/$group/full_schedule');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        data["remote"] = true;
        return ScheduleModel.fromJson(data);
      } else {
        throw ServerException('Response status code is $response.statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
