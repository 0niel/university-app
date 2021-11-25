import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> logIn(String login, String password);
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, User>> getUserData(String token);
  Future<Either<Failure, List<Announce>>> getAnnounces(String token);
  Future<Either<Failure, List<Employee>>> getEmployees(
      String token, String name);
  Future<Either<Failure, Map<String, List<Score>>>> getScores(String token);
  Future<Either<Failure, List<Attendance>>> getAattendance(
      String token, String dateStart, String dateEnd);
  Future<Either<Failure, String>> getAuthToken();
}
