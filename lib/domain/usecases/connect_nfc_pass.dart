import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/common/errors/failures.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/usecase.dart';

class ConnectNfcPass extends UseCase<void, ConnectNfcPassParams> {
  final UserRepository userRepository;

  ConnectNfcPass(this.userRepository);

  @override
  Future<Either<Failure, void>> call(ConnectNfcPassParams params) {
    return userRepository.connectNfcPass(
        params.code, params.studentId, params.deviceId, params.deviceName);
  }
}

class ConnectNfcPassParams extends Equatable {
  const ConnectNfcPassParams(
      this.code, this.studentId, this.deviceId, this.deviceName);

  final String code;
  final String studentId;
  final String deviceId;
  final String deviceName;

  @override
  List<Object?> get props => [code, studentId, deviceId, deviceName];
}
