import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/entities/attendance.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class GetAttendance extends UseCase<List<Attendance>, GetAttendanceParams> {
  final UserRepository userRepository;

  GetAttendance(this.userRepository);

  @override
  Future<Either<Failure, List<Attendance>>> call(
      GetAttendanceParams params) async {
    return await userRepository.getAattendance(
        params.token, params.startDate, params.endDate);
  }
}

class GetAttendanceParams extends Equatable {
  final String token;
  final String startDate;
  final String endDate;
  const GetAttendanceParams(this.token, this.startDate, this.endDate);

  @override
  List<Object?> get props => [token, startDate, endDate];
}
