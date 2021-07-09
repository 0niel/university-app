import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/data/models/schedule_model.dart';

abstract class ScheduleRemoteData {
  Future<ScheduleModel> getScheduleByGroup(String group);
  Future<List<String>> getGroups();
}

class ScheduleRemoteDataApi implements ScheduleRemoteData {
  static const _API_BASE_URL = 'http://127.0.0.1:5000/api/';

  final Dio _dio = Dio(
    BaseOptions(baseUrl: _API_BASE_URL),
  );

  @override
  Future<List<String>> getGroups() async {
    final response = await _dio.get('/schedule/groups');
    List<String> groups = response.data['groups'];
    return groups;
  }

  @override
  Future<ScheduleModel> getScheduleByGroup(String group) async {
    final response = await _dio.get('/schedule/$group/full_schedule');
    return ScheduleModel.fromJson(response.data);
  }
}
