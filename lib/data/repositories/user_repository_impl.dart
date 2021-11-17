import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/common/errors/exceptions.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/data/datasources/user_local.dart';
import 'package:rtu_mirea_app/data/datasources/user_remote.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteData remoteDataSource;
  final UserLocalData localDataSource;
  final InternetConnectionChecker connectionChecker;

  UserRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.connectionChecker});
  @override
  Future<Either<Failure, void>> logIn(String login, String password) async {
    if (await connectionChecker.hasConnection) {
      try {
        final authToken = await remoteDataSource.auth(login, password);
        localDataSource.setTokenToCache(authToken);
        return const Right(null);
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
  Either<Failure, void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserData() async {
    try {
      final token = await localDataSource.getTokenFromCache();
      final user = await remoteDataSource.getProfileData(token);
      print(user);
      return Future.value(Right(user));
    } on CacheException {
      return Future.value(const Left(CacheFailure()));
    }
  }
}
