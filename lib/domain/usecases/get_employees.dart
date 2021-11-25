import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/employee.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetEmployees extends UseCase<List<Employee>, GetEmployeesParams> {
  final UserRepository userRepository;

  GetEmployees(this.userRepository);

  @override
  Future<Either<Failure, List<Employee>>> call(GetEmployeesParams params) {
    return userRepository.getEmployees(params.token, params.name);
  }
}

class GetEmployeesParams extends Equatable {
  final String token;
  final String name;
  const GetEmployeesParams(this.token, this.name);

  @override
  List<Object?> get props => [token, name];
}
