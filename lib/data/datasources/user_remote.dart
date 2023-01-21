import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/data/models/announce_model.dart';
import 'package:rtu_mirea_app/data/models/attendance_model.dart';
import 'package:rtu_mirea_app/data/models/employee_model.dart';
import 'package:rtu_mirea_app/data/models/score_model.dart';
import 'package:rtu_mirea_app/data/models/user_model.dart';
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/oauth2_client.dart';

class MireaNinjaOauth2Client extends OAuth2Client {
  MireaNinjaOauth2Client({
    required String redirectUri,
    required String customUriScheme,
  }) : super(
          authorizeUrl: 'https://lks.mirea.ninja/oauth/authorize',
          tokenUrl: 'https://lks.mirea.ninja/oauth/token',
          redirectUri: redirectUri,
          customUriScheme: customUriScheme,
        );
}

abstract class UserRemoteData {
  Future<String> auth();
  Future<UserModel> getProfileData(String token);
  Future<List<AnnounceModel>> getAnnounces(String token);
  Future<List<EmployeeModel>> getEmployees(String token, String name);
  Future<List<AttendanceModel>> getAttendance(
      String token, String dateStart, String dateEnd);
  Future<Map<String, List<ScoreModel>>> getScores(String token);
}

class UserRemoteDataImpl implements UserRemoteData {
  static const _apiUrl = 'https://lks.mirea.ninja/api/';

  final Dio httpClient;

  final oauth2Client = MireaNinjaOauth2Client(
    customUriScheme: 'ninja.mirea.mireaapp',
    redirectUri: 'ninja.mirea.mireaapp:/oauth2redirect',
  );

  UserRemoteDataImpl({required this.httpClient});

  @override
  Future<String> auth() async {
    final OAuth2Helper oauth2Helper = OAuth2Helper(
      oauth2Client,
      grantType: OAuth2Helper.authorizationCode,
      clientId: const String.fromEnvironment('LK_CLIENT_ID', defaultValue: ''),
      clientSecret:
          const String.fromEnvironment('LK_CLIENT_SECRET', defaultValue: ''),
      scopes: ['profile', 'livestream', 'employees', 'attendance', 'scores'],
    );

    final token = await oauth2Helper.getToken();
    if (token != null) {
      return token.accessToken!;
    } else {
      throw ServerException('Token is null');
    }
  }

  @override
  Future<UserModel> getProfileData(String token) async {
    final response = await httpClient.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/profile/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    var jsonResponse = json.decode(response.data);

    log('Response: $jsonResponse');

    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }
    if (response.statusCode == 200) {
      return UserModel.fromRawJson(response.data);
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<AnnounceModel>> getAnnounces(String token) async {
    final response = await httpClient.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/livestream/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response: ${response.data}');

    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      List<AnnounceModel> announces = [];
      for (final announce in jsonResponse["ANNOUNCES"]) {
        announces.add(AnnounceModel.fromJson(announce));
      }
      return announces;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<EmployeeModel>> getEmployees(String token, String name) async {
    final response = await httpClient.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/lectors/&page=undefined&findname=$name',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response: ${response.data}');

    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      List<EmployeeModel> employees = [];
      if (jsonResponse.containsKey('HUMAN') && jsonResponse["HUMAN"] != null) {
        for (final employee in jsonResponse["HUMAN"].values) {
          employees.add(EmployeeModel.fromJson(employee));
        }
      }
      return employees;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<Map<String, List<ScoreModel>>> getScores(String token) async {
    final response = await httpClient.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/learning/scores/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response: ${response.data}');

    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      Map<String, List<ScoreModel>> scores = {};
      jsonResponse["SCORES"].values.first.forEach((key, value) {
        if (scores.containsKey(key) == false) {
          scores[key] = [];
        }

        for (final score in value.values) {
          scores[key]!.add(ScoreModel.fromJson(score[0]));
        }
      });

      return scores;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendance(
      String token, String dateStart, String dateEnd) async {
    final response = await httpClient.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/schedule/attendance/&startDate=$dateStart&endDate=$dateEnd',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    log('Response: ${response.data}');

    var jsonResponse = json.decode(response.data);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      List<AttendanceModel> attendance = [];
      if (jsonResponse["ROWS"] != null) {
        Map<String, dynamic>.from(jsonResponse["ROWS"]).forEach((date, row) {
          if (row.containsKey("START")) {
            attendance.add(
                AttendanceModel.fromJson(row["START"]).copyWith(date: date));
          }
          if (row.containsKey("END")) {
            attendance
                .add(AttendanceModel.fromJson(row["END"]).copyWith(date: date));
          }
        });
      }
      return attendance;
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }
}
