import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/oauth.dart';
import 'package:rtu_mirea_app/data/models/announce_model.dart';
import 'package:rtu_mirea_app/data/models/attendance_model.dart';
import 'package:rtu_mirea_app/data/models/employee_model.dart';
import 'package:rtu_mirea_app/data/models/nfc_pass_model.dart';
import 'package:rtu_mirea_app/data/models/score_model.dart';
import 'package:rtu_mirea_app/data/models/user_model.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';

abstract class UserRemoteData {
  Future<String> auth();
  Future<void> logOut();
  Future<UserModel> getProfileData(String token);
  Future<List<AnnounceModel>> getAnnounces(String token);
  Future<List<EmployeeModel>> getEmployees(String token, String name);
  Future<List<AttendanceModel>> getAttendance(
      String token, String dateStart, String dateEnd);
  Future<Map<String, List<ScoreModel>>> getScores(String token);
  Future<List<NfcPassModel>> getNfcPasses(
      String code, String studentId, String deviceId);
  Future<void> connectNfcPass(
      String code, String studentId, String deviceId, String deviceName);
}

class UserRemoteDataImpl implements UserRemoteData {
  static const _apiUrl = 'https://lks.mirea.ninja/api';

  final Dio httpClient;
  final LksOauth2 lksOauth2;

  UserRemoteDataImpl({required this.httpClient, required this.lksOauth2});

  @override
  Future<String> auth() async {
    final token = await lksOauth2.oauth2Helper.getToken();

    if (token != null) {
      return token.accessToken!;
    } else {
      throw ServerException('Токен не получен');
    }
  }

  @override
  Future<void> logOut() async {
    await lksOauth2.oauth2Helper.removeAllTokens();
  }

  @override
  Future<UserModel> getProfileData(String token) async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/profile/',
    );
    var jsonResponse = json.decode(response.body);

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }
    if (response.statusCode == 200) {
      return UserModel.fromRawJson(response.body);
    } else {
      throw ServerException('Response status code is $response.statusCode');
    }
  }

  @override
  Future<List<AnnounceModel>> getAnnounces(String token) async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/livestream/',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    var jsonResponse = json.decode(response.body);
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
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/lectors/&page=undefined&findname=$name',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    var jsonResponse = json.decode(response.body);
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
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/learning/scores/',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    var jsonResponse = json.decode(response.body);
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
  Future<List<NfcPassModel>> getNfcPasses(
      String code, String studentId, String deviceId) async {
    final response = await lksOauth2.oauth2Helper
        .get('$_apiUrl/cms/nfc-passes/$code/$studentId/$deviceId');

    if (response.statusCode != 200) {
      throw ServerException('Response status code is $response.statusCode');
    }

    print(response.body);

    var jsonResponse = json.decode(response.body);

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    List<NfcPassModel> userNfcPasses = [];
    userNfcPasses = List<NfcPassModel>.from(jsonResponse['data']
        .map((x) => NfcPassModel.fromJson(x['attributes'])));
    return userNfcPasses;
  }

  @override
  Future<void> connectNfcPass(
      String code, String studentId, String deviceId, String deviceName) async {
    final data = {
      'code': code,
      'studentId': studentId,
      'deviceId': deviceId,
      'deviceName': deviceName,
    };

    final response = await lksOauth2.oauth2Helper.post(
      '$_apiUrl/cms/nfc-passes',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw ServerException('Response status code is $response.statusCode');
    }

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    var jsonResponse = json.decode(response.body);
  }

  @override
  Future<List<AttendanceModel>> getAttendance(
      String token, String dateStart, String dateEnd) async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl?action=getData&url=https://lk.mirea.ru/schedule/attendance/&startDate=$dateStart&endDate=$dateEnd',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}');

    var jsonResponse = json.decode(response.body);
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
