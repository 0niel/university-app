import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/utils/connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/user_local.dart';
import 'package:rtu_mirea_app/data/datasources/user_remote.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';
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
  Future<Either<Failure, Map<String, Map<String, List<Score>>>>>
      getScores() async {
    try {
      final scores = await remoteDataSource.getScores();
      return Right(scores);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAattendance(
      String dateStart, String dateEnd) async {
    try {
      final attendance =
          await remoteDataSource.getAttendance(dateStart, dateEnd);
      return Right(attendance);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, List<NfcPass>>> getNfcPasses(
      String code, String studentId, String deviceId) async {
    try {
      final nfcPasses =
          await remoteDataSource.getNfcPasses(code, studentId, deviceId);
      return Right(nfcPasses);
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> connectNfcPass(
      String code, String studentId, String deviceId, String deviceName) {
    try {
      remoteDataSource.connectNfcPass(code, studentId, deviceId, deviceName);
      return Future.value(const Right(null));
    } on ServerException {
      return Future.value(const Left(ServerFailure()));
    }
  }

  @override
  Future<Either<Failure, void>> fetchNfcCode(
      String code, String studentId, String deviceId, String deviceName) async {
    final isLoggedIn = await getAuthToken().then((value) => value.isRight());

    if (!isLoggedIn) {
      return const Left(ServerFailure("Пользователь не авторизован"));
    }

    if (await connectionChecker.hasConnection) {
      try {
        final nfcCode =
            await remoteDataSource.getNfcCode(code, studentId, deviceId);
        await localDataSource.setNfcCodeToCache(nfcCode);
        return const Right(null);
      } on ServerException catch (e) {
        if (e is NfcStaffnodeNotExistException) {
          return const Left(NfcStaffnodeNotExistFailure());
        }

        await localDataSource.removeNfcCodeFromCache();

        return Left(ServerFailure(e.cause));
      }
    } else {
      return const Left(ServerFailure("Отсутсвует соединение с интернетом"));
    }
  }

  @override
  Future<Either<Failure, void>> sendNfcNotExistFeedback(
      String fullName, String group, String personalNumber, String studentId) {
    try {
      remoteDataSource.sendNfcNotExistFeedback(
          fullName, group, personalNumber, studentId);
      return Future.value(const Right(null));
    } on ServerException catch (e) {
      return Future.value(Left(ServerFailure(e.cause)));
    }
  }
}
