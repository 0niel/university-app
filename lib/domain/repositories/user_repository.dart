import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, String>> logIn(String login, String password);
  Either<Failure, void> logOut();
  Future<Either<Failure, User>> getUserData(String token);
  Future<Either<Failure, List<Announce>>> getAnnounces(String token);
  Future<Either<Failure, String>> getAuthToken();
}
