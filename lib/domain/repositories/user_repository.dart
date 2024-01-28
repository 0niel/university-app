import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> logIn();
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, User>> getUserData();
  Future<Either<Failure, List<Announce>>> getAnnounces();
  Future<Either<Failure, List<Employee>>> getEmployees(String name);
  Future<Either<Failure, Map<String, Map<String, List<Score>>>>> getScores();
  Future<Either<Failure, List<Attendance>>> getAattendance(String dateStart, String dateEnd);
  Future<Either<Failure, String>> getAuthToken();
}
