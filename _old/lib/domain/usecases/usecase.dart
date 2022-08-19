import 'package:dartz/dartz.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseRight<Type, Params> {
  Future<Type> call(Params params);
}
