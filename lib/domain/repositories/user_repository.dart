import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> logIn();
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, User>> getUserData();
  Future<Either<Failure, List<Announce>>> getAnnounces();
  Future<Either<Failure, List<Employee>>> getEmployees(String name);
  Future<Either<Failure, Map<String, Map<String, List<Score>>>>> getScores();
  Future<Either<Failure, List<Attendance>>> getAattendance(
      String dateStart, String dateEnd);
  Future<Either<Failure, String>> getAuthToken();

  Future<Either<Failure, List<NfcPass>>> getNfcPasses(
      String code, String studentId, String deviceId);
  Future<Either<Failure, void>> connectNfcPass(
      String code, String studentId, String deviceId, String deviceName);

  /// Fetch NFC code from server. If device is not connected, then clear all
  /// local NFC codes from [FlutterSecureStorage]. If device is connected, then
  /// update local data with new NFC code.
  ///
  /// Returns [Failure] if device is not connected or if there is no internet
  /// connection. Returns [void] if device is connected.
  Future<Either<Failure, void>> fetchNfcCode(
      String code, String studentId, String deviceId, String deviceName);

  Future<Either<Failure, void>> sendNfcNotExistFeedback(
      String fullName, String group, String personalNumber, String studentId);
}
