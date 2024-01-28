import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/oauth.dart';
import 'package:rtu_mirea_app/data/models/announce_model.dart';
import 'package:rtu_mirea_app/data/models/attendance_model.dart';
import 'package:rtu_mirea_app/data/models/employee_model.dart';
import 'package:rtu_mirea_app/data/models/score_model.dart';
import 'package:rtu_mirea_app/data/models/user_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract class UserRemoteData {
  Future<String> auth();
  Future<void> logOut();
  Future<UserModel> getProfileData();
  Future<List<AnnounceModel>> getAnnounces();
  Future<List<EmployeeModel>> getEmployees(String name);
  Future<List<AttendanceModel>> getAttendance(String dateStart, String dateEnd);
  Future<Map<String, Map<String, List<ScoreModel>>>> getScores();
}

class UserRemoteDataImpl implements UserRemoteData {
  static const _apiUrl = 'https://auth-app.mirea.ru/api';

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
  Future<UserModel> getProfileData() async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/profile/',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getProfileData');

    try {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('errors')) {
        throw ServerException(jsonResponse['errors'][0]);
      }
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonResponse);
      } else {
        throw ServerException('Response status code is ${response.statusCode}');
      }
    } catch (e) {
      Sentry.captureException(e, stackTrace: StackTrace.current);

      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AnnounceModel>> getAnnounces() async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/livestream/',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getAnnounces');

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
      throw ServerException('Response status code is ${response.statusCode}');
    }
  }

  @override
  Future<List<EmployeeModel>> getEmployees(String name) async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/lectors/&page=undefined&findname=$name',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getEmployees');

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
      throw ServerException('Response status code is ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, Map<String, List<ScoreModel>>>> getScores() async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/learning/scores/',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getScores');

    var jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      Map<String, Map<String, List<ScoreModel>>> scoresByStudentCode = {};
      final scoresRes = jsonResponse["SCORES"] as Map<String, dynamic>;

      scoresRes.forEach((studentId, semesters) {
        Map<String, List<ScoreModel>> scoresBySemester = {};
        final semestersRes = semesters as Map<String, dynamic>;

        semestersRes.forEach((semester, subjects) {
          List<ScoreModel> scores = [];
          final subjectsRes = subjects as Map<String, dynamic>;

          subjectsRes.forEach((subjectId, score) {
            for (final score in score) {
              scores.add(ScoreModel.fromJson(score));
            }
          });

          scoresBySemester[semester] = scores;
        });

        scoresByStudentCode[studentId] = scoresBySemester;
      });

      return scoresByStudentCode;
    } else {
      throw ServerException('Response status code is ${response.statusCode}');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendance(String dateStart, String dateEnd) async {
    final response = await lksOauth2.oauth2Helper.get(
      '$_apiUrl/?action=getData&url=https://lk.mirea.ru/schedule/attendance/&startDate=$dateStart&endDate=$dateEnd',
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getAttendance');

    var jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('errors')) {
      throw ServerException(jsonResponse['errors'][0]);
    }

    if (response.statusCode == 200) {
      List<AttendanceModel> attendance = [];
      if (jsonResponse["ROWS"] != null) {
        Map<String, dynamic>.from(jsonResponse["ROWS"]).forEach((date, row) {
          if (row.containsKey("START")) {
            if (row["START"] != null) {
              attendance.add(AttendanceModel.fromJson(row["START"]).copyWith(date: date));
            }
          }
          if (row.containsKey("END")) {
            if (row["END"] != null) {
              attendance.add(AttendanceModel.fromJson(row["END"]).copyWith(date: date));
            }
          }
        });
      }
      return attendance;
    } else {
      throw ServerException('Response status code is ${response.statusCode}');
    }
  }

  @override
  Future<int> getNfcCode(String code, String studentId, String deviceId) async {
    final response = await lksOauth2.oauth2Helper.get('$_apiUrl/get-nfc-code/$code/$studentId/$deviceId');

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'getNfcCode');

    var jsonResponse = json.decode(response.body);

    if (jsonResponse.containsKey('code')) {
      return jsonResponse['code'];
    } else {
      // Local api error
      if (jsonResponse.containsKey('message')) {
        throw ServerException(jsonResponse['message']);
      }
      // LKS api error
      else if (jsonResponse.containsKey('error') && jsonResponse['error'] == 'StaffnodeNotExist') {
        throw NfcStaffnodeNotExistException();
      } else {
        throw ServerException('${jsonResponse['error']}');
      }
    }
  }

  @override
  Future<void> sendNfcNotExistFeedback(String fullName, String group, String personalNumber, String studentId) async {
    final data = {
      'fullName': fullName,
      'group': group,
      'personalNumber': personalNumber,
      'studentId': studentId,
    };

    final response = await lksOauth2.oauth2Helper.post(
      '$_apiUrl/cms/nfc-pass-not-exist-feedback',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(data),
    );

    log('Status code: ${response.statusCode}, Response: ${response.body}', name: 'sendNfcNotExistFeedback');

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        if (response.body.contains("This attribute must be unique")) {
          throw ServerException('Уже отправлено. Пожалуйста, подождите. '
              'Время обработки заявки - до 7 рабочих дней.');
        }
      } else {
        throw ServerException('Response status code is ${response.statusCode}');
      }
    }
  }
}
