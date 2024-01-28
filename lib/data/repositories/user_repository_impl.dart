import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/utils/connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/user_local.dart';
import 'package:rtu_mirea_app/data/datasources/user_remote.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/entities/score.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteData remoteDataSource;
  final UserLocalData localDataSource;
  final InternetConnectionChecker connectionChecker;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker,
  });
  @override
  Future<Either<Failure, String>> logIn() async {
    if (await connectionChecker.hasConnection) {
      try {
        final authToken = await remoteDataSource.auth();
        return Right(authToken);
      } catch (e) {
        if (e is ServerException) {
          return Left(ServerFailure(e.cause));
        }
        return const Left(ServerFailure());
      }
    } else {
      return const Left(ServerFailure("Отсутсвует соединение с интернетом"));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await remoteDataSource.logOut();
      return Right(await localDataSource.removeTokenFromCache());
    } on CacheException {
      return Future.value(const Left(CacheFailure()));
    }
  }

  @override
  Future<Either<Failure, User>> getUserData() async {
    try {
      final user = await remoteDataSource.getProfileData();
      return Future.value(Right(user));
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, String>> getAuthToken() async {
    try {
      final token = await localDataSource.getTokenFromCache();
      return Future.value(Right(token));
    } on CacheException {
      return Future.value(const Left(CacheFailure()));
    }
  }

  @override
  Future<Either<Failure, List<Announce>>> getAnnounces() async {
    try {
      final announces = await remoteDataSource.getAnnounces();
      return Right(announces);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> getEmployees(String name) async {
    try {
      final employees = await remoteDataSource.getEmployees(name);
      return Right(employees);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, Map<String, Map<String, List<Score>>>>> getScores() async {
    try {
      final scores = await remoteDataSource.getScores();
      return Right(scores);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAattendance(String dateStart, String dateEnd) async {
    try {
      final attendance = await remoteDataSource.getAttendance(dateStart, dateEnd);
      return Right(attendance);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }
}
